import { GoogleGenerativeAI } from "@google/generative-ai";
import { onCall, HttpsError } from "firebase-functions/v2/https";
import { defineSecret } from "firebase-functions/params";

const geminiApiKey = defineSecret("GEMINI_API_KEY");

const prompt = `อ่านข้อความจากฉลากยาในภาพและตอบเป็น JSON เท่านั้น
ห้ามเดาชื่อยาหรือขนาดยาที่อ่านไม่เห็น ให้ใช้ null และ confidence ต่ำแทน
แยกชื่อการค้าและชื่อสามัญถ้าอ่านได้ และคงภาษาไทย/อังกฤษตามฉลาก
ฟิลด์ที่ต้องส่ง: brandName, genericName, strength, dosageForm, quantity,
instructions, confidence, rawText
confidence เป็นตัวเลข 0 ถึง 1; quantity เป็นจำนวนเม็ด/หน่วยถ้าเห็นชัด
instructions คือข้อความวิธีใช้ตามฉลากเท่านั้น ไม่ให้คำแนะนำทางการแพทย์เพิ่ม`;

export const analyzeMedicineLabel = onCall(
  {
    region: "asia-southeast1",
    timeoutSeconds: 60,
    memory: "512MiB",
    secrets: [geminiApiKey],
  },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError("unauthenticated", "ต้องเข้าสู่ระบบก่อนสแกนฉลากยา");
    }
    const imageBase64 = request.data?.imageBase64;
    const mimeType = request.data?.mimeType;
    if (typeof imageBase64 !== "string" || imageBase64.length === 0 ||
        !["image/jpeg", "image/png", "image/webp"].includes(mimeType)) {
      throw new HttpsError("invalid-argument", "รูปภาพไม่ถูกต้อง");
    }
    if (imageBase64.length > 11_000_000) {
      throw new HttpsError("resource-exhausted", "ไฟล์ภาพใหญ่เกินไป");
    }
    try {
      const client = new GoogleGenerativeAI(geminiApiKey.value());
      const model = client.getGenerativeModel({
        model: "gemini-2.5-flash",
        generationConfig: { responseMimeType: "application/json" },
      });
      const result = await model.generateContent([
        { inlineData: { data: imageBase64, mimeType } },
        { text: prompt },
      ]);
      const raw = result.response.text().trim();
      const parsed = JSON.parse(raw) as Record<string, unknown>;
      return {
        brandName: typeof parsed.brandName === "string" ? parsed.brandName : null,
        genericName: typeof parsed.genericName === "string" ? parsed.genericName : null,
        strength: typeof parsed.strength === "string" ? parsed.strength : null,
        dosageForm: typeof parsed.dosageForm === "string" ? parsed.dosageForm : null,
        quantity: typeof parsed.quantity === "number" ? parsed.quantity : null,
        instructions: typeof parsed.instructions === "string" ? parsed.instructions : null,
        confidence: typeof parsed.confidence === "number" ? parsed.confidence : 0,
        rawText: typeof parsed.rawText === "string" ? parsed.rawText : "",
      };
    } catch (error) {
      console.error("Gemini label analysis failed", error);
      throw new HttpsError("unavailable", "บริการ AI ไม่พร้อมใช้งาน กรุณาลองใหม่");
    }
  },
);
