# Firebase Setup Guide for Med Reminder

## Overview

Med Reminder ต้องการ Firebase เพื่อ:
- **Authentication:** จัดการ sign in, sign up, sign out
- **Cloud Firestore:** Sync ข้อมูลยา, ตารางเวลา, ประวัติการทานยา
- **Firebase Storage:** (Optional) เก็บรูปภาพฉลากยา

---

## Prerequisites

- Google Account
- Flutter project ที่เตรียมไว้แล้ว
- Android Studio หรือ VS Code พร้อม Flutter SDK

---

## Step 1: Create Firebase Project

1. ไปที่ [Firebase Console](https://console.firebase.google.com/)
2. คลิก **"Add project"**
3. ตั้งชื่อ project เช่น `med-reminder-app`
4. (Optional) เลือก Google Analytics ถ้าต้องการ
5. คลิก **"Create project"**

---

## Step 2: Register Android App

1. ใน Firebase Console คลิก **Android icon** (โลโก้ Android)
2. **Android package name:** `com.medreminder.app.med_reminder`
   - ดูได้จาก `android/app/build.gradle.kts` → `applicationId`
3. **App nickname:** ใส่ชื่อเช่น `Med Reminder Android`
4. **Debug signing certificate SHA-1:**
   ```bash
   cd android
   ./gradlew signingReport
   ```
   - คัดลอก SHA-1 จาก output
5. คลิก **"Register app"**

---

## Step 3: Download Configuration File

1. หลังจาก register app แล้ว Firebase จะให้ดาวน์โหลด `google-services.json`
2. วางไฟล์ใน path:
   ```
   android/app/google-services.json
   ```
3. คลิก **"Next"** ใน Firebase Console

---

## Step 4: Add Firebase SDK to Android

### 4.1 Update `android/build.gradle.kts`

```kotlin
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

### 4.2 Update `android/app/build.gradle.kts`

เพิ่มด้านบนสุด:
```kotlin
plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // เพิ่มบรรทัดนี้
}
```

---

## Step 5: Enable Firebase Services

### 5.1 Enable Authentication

1. ใน Firebase Console → **Build** → **Authentication**
2. คลิก **"Get started"**
3. เลือก **Sign-in method** tab
4. เปิดใช้ **Email/Password**:
   - คลิก **Email/Password**
   - เปิด switch **Enable**
   - คลิก **Save**

### 5.2 Enable Firestore

1. ใน Firebase Console → **Build** → **Firestore Database**
2. คลิก **"Create database"**
3. เลือก location (เลือก asia-southeast1 สำหรับ Thailand)
4. เลือก **Start in Test Mode** (ชั่วคราวสำหรับ development)
5. คลิก **"Enable"**

**หมายเหตุ:** Test mode rules จะอนุญาตทุกคนอ่าน/เขียนได้ ต้องเปลี่ยนเป็น production rules ก่อน deploy

### 5.3 (Optional) Enable Storage

1. ใน Firebase Console → **Build** → **Storage**
2. คลิก **"Get started"**
3. เลือก rules แบบ test mode
4. คลิก **"Enable"**

---

## Step 6: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

---

## Step 7: Configure FlutterFire

```bash
cd "D:\mobile project med reminder"
flutterfire configure
```

เลือก project ที่สร้างไว้ใน Step 1

FlutterFire CLI จะ:
- สร้าง `lib/firebase_options.dart`
- อัปเดต `android/app/build.gradle.kts`
- อัปเดต `ios/Runner/Runner.xcodeproj/project.pbxproj` (ถ้ามี iOS)

---

## Step 8: Initialize Firebase in App

ใน `lib/main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // สร้างโดย FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // ... rest of main
}
```

---

## Step 9: Firebase Security Rules

สร้างไฟล์ `firestore.rules`:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Helper function: check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }

    // Helper function: check if user owns the document
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if isOwner(userId);

      // Subcollections under user
      match /medications/{medId} {
        allow read, write: if isOwner(userId);
      }

      match /schedules/{scheduleId} {
        allow read, write: if isOwner(userId);
      }

      match /intake_logs/{logId} {
        allow read, write: if isOwner(userId);
      }
    }
  }
}
```

Deploy rules:

```bash
firebase firestore:rules deploy firestore.rules
```

หรือใช้ Firebase Console → **Firestore** → **Rules** tab → วาง rules → **Publish**

---

## Step 10: Test Firebase Connection

สร้าง test script ใน `lib/main.dart`:

```dart
// In main() after Firebase.initializeApp
try {
  await FirebaseAuth.instance.signInAnonymously();
  print('Firebase Auth connected successfully');
} catch (e) {
  print('Firebase Auth error: $e');
}
```

รัน app และตรวจ log ใน console

---

## Common Issues

### Issue: "google-services.json not found"

**Solution:** ตรวจสอบว่าไฟล์อยู่ใน `android/app/google-services.json`

### Issue: "SHA-1 certificate mismatch"

**Solution:**
- รัน `./gradlew signingReport` อีกครั้ง
- เพิ่ม SHA-1 ทั้ง debug และ release ใน Firebase Console

### Issue: "Firebase not initialized"

**Solution:** ตรวจสอบว่า `Firebase.initializeApp()` ถูกเรียกก่อนใช้ Firebase services

### Issue: "Permission denied" in Firestore

**Solution:** ตรวจสอบ Security Rules และ user authentication state

---

## Production Checklist

ก่อน deploy ไป production:

- [ ] เปลี่ยน Firestore Rules จาก test mode เป็น production rules
- [ ] เปิดใช้ App Check (optional)
- [ ] ตั้งค่า Firebase Analytics (optional)
- [ ] ตรวจสอบ billing limits
- [ ] เปิดใช้ App Distribution สำหรับ beta testing
- [ ] ตั้งค่า Crashlytics (optional)

---

## Firebase Emulator (สำหรับ Local Development)

เพื่อหลีกเลี่ยงการใช้ production data ใน development:

### Install Firebase CLI

```bash
npm install -g firebase-tools
```

### Initialize Emulator

```bash
firebase init emulators
```

เลือก:
- Firestore
- Authentication
- Functions (ถ้าต้องการ)

### Start Emulator

```bash
firebase emulators:start
```

### Connect Flutter to Emulator

ใน `lib/main.dart`:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Connect to emulator (development only)
if (kDebugMode) {
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
```

---

## References

- [FlutterFire Documentation](https://firebase.flutter.dev/docs/overview)
- [Firebase Console](https://console.firebase.google.com/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite)

---

## Last Updated

2026-10-27 - Initial setup guide
