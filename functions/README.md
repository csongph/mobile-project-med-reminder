# Medicine label AI function

This function keeps the Gemini key on the server. From the project root run:

```powershell
cd functions
npm install
npm run build
cd ..
firebase functions:secrets:set GEMINI_API_KEY
firebase deploy --only functions:analyzeMedicineLabel
```

The Flutter app calls `analyzeMedicineLabel` only for signed-in users. If the
function is unavailable, the app automatically falls back to on-device OCR.
The returned fields are suggestions; the user must verify them before saving.
