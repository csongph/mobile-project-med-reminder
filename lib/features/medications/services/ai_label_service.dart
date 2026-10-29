import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

/// Result returned by the server-side vision model. Values are suggestions
/// only and must be confirmed by the user before saving a medication.
class AiLabelResult {
  final String? brandName;
  final String? genericName;
  final String? strength;
  final String? dosageForm;
  final int? quantity;
  final String? instructions;
  final double confidence;
  final String rawText;

  const AiLabelResult({
    this.brandName,
    this.genericName,
    this.strength,
    this.dosageForm,
    this.quantity,
    this.instructions,
    required this.confidence,
    required this.rawText,
  });

  factory AiLabelResult.fromMap(Map<Object?, Object?> map) {
    int? parseInt(Object? value) => int.tryParse(value?.toString() ?? '');
    double parseDouble(Object? value) =>
        double.tryParse(value?.toString() ?? '') ?? 0;
    String? text(Object? value) {
      final result = value?.toString().trim();
      return result == null || result.isEmpty ? null : result;
    }

    return AiLabelResult(
      brandName: text(map['brandName']),
      genericName: text(map['genericName']),
      strength: text(map['strength']),
      dosageForm: text(map['dosageForm']),
      quantity: parseInt(map['quantity']),
      instructions: text(map['instructions']),
      confidence: parseDouble(map['confidence']),
      rawText: text(map['rawText']) ?? '',
    );
  }

  String? get bestName => brandName ?? genericName;
}

class AiLabelService {
  // Demo-only mode. Pass this at build/run time; never commit the key.
  static const _demoApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static const _model = 'gemini-2.5-flash';

  Future<AiLabelResult?> analyze(String imagePath) async {
    if (_demoApiKey.isNotEmpty) {
      return _analyzeDirect(imagePath);
    }
    if (Firebase.apps.isEmpty || FirebaseAuth.instance.currentUser == null) {
      return null;
    }
    final bytes = await File(imagePath).readAsBytes();
    // Keep callable payloads small enough for mobile networks and the
    // callable function limit. The picker already limits dimensions.
    if (bytes.length > 8 * 1024 * 1024) return null;
    final mimeType = imagePath.toLowerCase().endsWith('.png')
        ? 'image/png'
        : 'image/jpeg';
    final callable = FirebaseFunctions.instanceFor(
      region: 'asia-southeast1',
    ).httpsCallable('analyzeMedicineLabel');
    final response = await callable.call(<String, dynamic>{
      'imageBase64': base64Encode(bytes),
      'mimeType': mimeType,
    });
    final data = Map<Object?, Object?>.from(response.data as Map);
    return AiLabelResult.fromMap(data);
  }

  Future<AiLabelResult?> _analyzeDirect(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    if (bytes.length > 8 * 1024 * 1024) return null;
    final mimeType = imagePath.toLowerCase().endsWith('.png')
        ? 'image/png'
        : 'image/jpeg';
    const prompt = '''อ่านข้อความจากฉลากยาในภาพและตอบเป็น JSON เท่านั้น
ห้ามเดาชื่อยาหรือขนาดยาที่อ่านไม่เห็น ให้ใช้ null และ confidence ต่ำแทน
แยกชื่อการค้าและชื่อสามัญถ้าอ่านได้ และคงภาษาไทย/อังกฤษตามฉลาก
ฟิลด์: brandName, genericName, strength, dosageForm, quantity, instructions,
confidence, rawText. confidence เป็นตัวเลข 0 ถึง 1 และ instructions ต้องเป็น
ข้อความตามฉลากเท่านั้น ไม่ให้คำแนะนำทางการแพทย์เพิ่ม''';
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent',
    ).replace(queryParameters: {'key': _demoApiKey});
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'contents': [
              {
                'parts': [
                  {'text': prompt},
                  {
                    'inline_data': {
                      'mime_type': mimeType,
                      'data': base64Encode(bytes),
                    },
                  },
                ],
              },
            ],
            'generationConfig': {'responseMimeType': 'application/json'},
          }),
        )
        .timeout(const Duration(seconds: 45));
    if (response.statusCode != 200) {
      throw Exception('Gemini API error ${response.statusCode}');
    }
    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = payload['candidates'] as List?;
    List? parts;
    if (candidates != null && candidates.isNotEmpty) {
      final first = candidates.first;
      if (first is Map) {
        final content = first['content'];
        if (content is Map) parts = content['parts'] as List?;
      }
    }
    final raw = parts?.isNotEmpty == true
        ? ((parts!.first as Map)['text']?.toString() ?? '')
        : '';
    if (raw.isEmpty) return null;
    final cleaned = raw
        .replaceFirst(RegExp(r'^```json\s*'), '')
        .replaceFirst(RegExp(r'\s*```$'), '')
        .trim();
    return AiLabelResult.fromMap(
      Map<Object?, Object?>.from(jsonDecode(cleaned) as Map),
    );
  }
}
