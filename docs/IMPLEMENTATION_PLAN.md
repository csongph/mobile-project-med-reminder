# Med Reminder Implementation Plan

## Executive Summary

Med Reminder เป็น Flutter application สำหรับแจ้งเตือนการทานยา ที่มี UI พื้นฐานและ local storage (JSON) แล้ว แต่ยังขาด:
- Firebase Authentication และ Firestore integration
- Local database ที่เหมาะสม (SQLite/Drift)
- Offline-first architecture และ sync queue
- Automated tests (unit, widget, integration, security)
- GitHub Actions CI
- Documentation ครบถ้วน

---

## Initial Gap Matrix (Based on Evidence)

| เกณฑ์ประเมิน | สิ่งที่มีอยู่ | สิ่งที่ขาด | สถานะ |
|---|---|---|---|
| **UI/UX (3 คะแนน)** | • Navigation ครบ 4 หน้า<br>• Thai locale<br>• Material Design<br>• OCR scan flow<br>• Form validation | • Accessibility semantics<br>• Loading/error states บางส่วน<br>• Full-screen intent handling<br>• Dark theme<br>• Figma references | PARTIAL |
| **Firebase Backend (3 คะแนน)** | • Dependencies เตรียมไว้<br>• Models รองรับ Firestore timestamp | • No google-services.json<br>• No firebase_options.dart<br>• No Auth implementation<br>• No Firestore CRUD<br>• No Security Rules<br>• No user ownership enforcement | MISSING |
| **AI/OCR (3 คะแนน)** | • google_mlkit_text_recognition<br>• MedicationLabelParser<br>• Scan flow UI<br>• User confirmation before save | • Thai language support จำกัด<br>• No OCR test fixtures<br>• No parser unit tests<br>• No confidence scoring from engine | PARTIAL |
| **Local DB + Firestore (3 คะแนน)** | • JSON storage ผ่าน MethodChannel<br>• Basic CRUD operations<br>• Models with toMap/fromMap | • No SQLite/Drift database<br>• No migration system<br>• No sync queue<br>• No conflict resolution<br>• No account isolation<br>• No offline queue recovery | MISSING |
| **Testing + Coverage (5 คะแนน)** | • 1 widget test (smoke test)<br>• flutter_lints configured | • No unit tests<br>• No integration tests<br>• No security tests<br>• No coverage measurement<br>• No coverage threshold enforcement<br>• No coverage report | MISSING |
| **GitHub Actions (3 คะแนน)** | • Flutter project structure<br>• Gradle configured | • No .github/workflows/<br>• No CI pipeline<br>• No artifact uploads<br>• No test automation | MISSING |

---

## Milestones & Dependencies

### Milestone 1: Audit & Planning ✅ COMPLETED
- [x] ตรวจ Repository structure
- [x] ตรวจ dependencies และ configuration
- [x] ตรวจ implementation ที่มีอยู่
- [x] สร้าง Gap Matrix
- [x] สร้าง IMPLEMENTATION_PLAN.md

**Evidence:** `docs/IMPLEMENTATION_PLAN.md`, audit of 17 Dart files, Android manifest, pubspec.yaml

---

### Milestone 2: Data Architecture & Safe Migration
**Status:** IN PROGRESS

**Tasks:**
1. เลือก local database (Drift แนะนำสำหรับ Flutter)
2. ออกแบบ schema (Medication, Schedule, IntakeLog, SyncQueue, UserSettings)
3. สร้าง migration logic จาก JSON → Drift
4. สร้าง backup/recovery path
5. เขียน migration tests
6. เขียน offline CRUD tests
7. เขียน reopen tests (ปิดเปิดแอปใหม่)

**Acceptance Criteria:**
- มี `docs/DATA_ARCHITECTURE.md` อธิบาย schema, migration, conflict resolution
- Migration จาก JSON สำเร็จโดยไม่ทำลายข้อมูลเดิม
- Offline CRUD ทำงานได้
- ปิดเปิดแอปใหม่ข้อมูลยังอยู่ครบ
- มี tests ยืนยัน

**Blockers:** ไม่มี

---

### Milestone 3: Firebase Authentication, Firestore & Security
**Status:** BLOCKED (NEEDS USER ACTION)

**Tasks:**
1. สร้าง Firebase project
2. เพิ่ม google-services.json และ firebase_options.dart
3. Implement Firebase Auth (sign in, sign up, sign out, state restoration)
4. Implement Firestore CRUD สำหรับ medications, schedules, logs
5. สร้าง Firestore Security Rules
6. เขียน Security Rules tests ด้วย Firebase Emulator
7. กำหนด user ownership ใน local database
8. Implement account switching logic

**Acceptance Criteria:**
- Auth flow ทำงานได้ (sign in/out)
- Firestore CRUD ทำงานได้ผ่าน Repository
- Security Rules ป้องกัน cross-user access
- Rules tests pass ทั้ง allowed และ denied cases
- User data แยกกันชัดเจน

**User Action Required:**
- สร้าง Firebase project ที่ https://console.firebase.google.com/
- เปิดใช้ Authentication (Email/Password หรือ provider ที่ต้องการ)
- เปิดใช้ Firestore
- Download google-services.json สำหรับ Android
- รัน FlutterFire CLI: `flutterfire configure`

**Fallback:** สร้าง config template และ integration seam สำหรับ mock/auth mode

---

### Milestone 4: Offline-first & Synchronization
**Status:** BLOCKED (Depends on Milestone 2 & 3)

**Tasks:**
1. ออกแบบ sync queue schema
2. Implement sync queue operations (add, retry, mark success/fail)
3. Implement offline-first CRUD (local first, then sync)
4. Implement conflict resolution policy
5. Implement sync retry ด้วย backoff
6. Implement duplicate operation detection
7. Implement account isolation (local data ต่อ user)
8. เขียน sync tests (offline, reconnect, retry, conflict, account switch)

**Acceptance Criteria:**
- Offline CRUD ทำงานได้
- Sync เมื่อ online สำเร็จ
- Retry ด้วย backoff ทำงานได้
- Conflict resolution ตาม policy
- Account switching ไม่แสดงข้อมูลคนอื่น
- Tests ครอบคลุม

---

### Milestone 5: AI/OCR Scan Label Enhancement
**Status:** IN PROGRESS (Can work in parallel)

**Tasks:**
1. ทดสอบและปรับ MedicationLabelParser
2. สร้าง synthetic test fixtures สำหรับ Thai/English labels
3. เขียน parser unit tests
4. เขียน field extraction tests
5. เพิ่ม error handling สำหรับภาพเบลอ/มืด/เอียง
6. ปรับ UI ให้แสดง raw text และ confidence ถ้า engine ให้
7. สร้าง protocol วัด accuracy

**Acceptance Criteria:**
- Parser มี unit tests
- Field extraction มี tests
- Error cases ครอบคลุม
- ผู้ใช้ตรวจยืนยันก่อนบันทึกเสมอ
- ไม่เดาข้อมูลที่อ่านไม่ได้

---

### Milestone 6: Medication Stock & Intake Integrity
**Status:** IN PROGRESS (Can work in parallel after Milestone 2)

**Tasks:**
1. ตรวจ logic การลด stock ใน AppStateNotifier.recordIntake
2. เพิ่ม idempotency key สำหรับ intake operations
3. เขียน unit tests สำหรับ stock calculations
4. เขียน tests สำหรับ duplicate tap prevention
5. เขียน tests สำหรับ undo operations
6. เขียน tests สำหรับ sync ซ้ำไม่ทำให้ stock เพี้ยน
7. เพิ่ม transaction ใน database operations

**Acceptance Criteria:**
- Unit tests พิสูจน์ความถูกต้องของ stock
- Duplicate tap ไม่สร้าง log ซ้ำ
- Undo operations รักษาความสัมพันธ์
- Sync ซ้ำไม่ทำให้ stock เปลี่ยน

---

### Milestone 7: Android Reminder & Notification
**Status:** PARTIAL (Implementation exists, needs verification)

**Tasks:**
1. ตรวจ NotificationService.syncMedicationReminders
2. ตรวจ alarm restoration หลัง reboot
3. ตรวจ timezone handling (Asia/Bangkok)
4. สร้าง manual test checklist สำหรับ device
5. เขียน business logic tests สำหรับ scheduling
6. ตรวจ permission handling (POST_NOTIFICATIONS, USE_FULL_SCREEN_INTENT)
7. ตรวจ duplicate scheduling prevention

**Acceptance Criteria:**
- Business logic มี tests
- Manual test checklist สำหรับ device verification
- Permission handling ถูกต้อง
- Timezone ทำงานถูกต้อง

**Note:** หากไม่มี Android device/emulator ให้บันทึกเป็น BLOCKED และสร้าง checklist

---

### Milestone 8: UI/UX, Material Design 3 & Accessibility
**Status:** IN PROGRESS (Can work in parallel)

**Tasks:**
1. ตรวจ contrast, spacing, component consistency
2. เพิ่ม accessibility semantics (TalkBack)
3. เพิ่ม loading states ที่ขาด
4. เพิ่ม error states ที่ขาด
5. เพิ่ม offline status indicator
6. ตรวจ text scaling และ responsive layout
7. สร้าง `docs/USABILITY_TEST_PROTOCOL.md`
8. สร้าง `docs/USABILITY_TEST_FORM.md`

**Acceptance Criteria:**
- UI ครอบคลุม loading/error/offline states
- Accessibility semantics ครบถ้วน
- Usability protocol และ form พร้อมใช้
- Figma หรือ design reference หากมี

---

### Milestone 9: Automated Testing (4 Types)
**Status:** BLOCKED (Depends on Milestone 2, 3, 4, 5, 6)

**Tasks:**
1. **Unit Tests:** OCR parser, stock calculations, sync queue, conflict resolution
2. **Widget Tests:** Navigation, forms, empty/loading/error states, accessibility
3. **Integration Tests:** Add medication → local save → sync → Firestore → read back
4. **Security Tests:** Firebase Security Rules tests ด้วย Emulator
5. Setup coverage measurement (LCOV)
6. Enforce coverage threshold ≥70%
7. สร้าง `docs/TESTING.md`

**Acceptance Criteria:**
- ทั้ง 4 ประเภท tests มี implementation
- Tests รันซ้ำได้
- Coverage report จากผลรันจริง
- Coverage ≥70% หรือระบุสถานะที่แท้จริง

---

### Milestone 10: GitHub Actions CI
**Status:** BLOCKED (Depends on Milestone 9)

**Tasks:**
1. สร้าง `.github/workflows/ci.yml`
2. Setup Flutter cache
3. Setup Java/Android SDK
4. Configure format check
5. Configure flutter analyze
6. Configure unit tests
7. Configure widget tests
8. Configure integration tests
9. Configure Firebase Emulator for Security Rules tests
10. Configure coverage generation
11. Enforce coverage threshold
12. Configure Android debug build
13. Upload artifacts (test results, coverage, build)

**Acceptance Criteria:**
- Workflow รันบน push/PR
- All checks pass
- Coverage threshold enforced
- Artifacts uploaded
- Workflow อ้างอิง run จริง

---

### Milestone 11: Regression, Build & Security Review
**Status:** BLOCKED (Depends on all previous milestones)

**Tasks:**
1. รัน flutter analyze
2. รัน format check
3. รันทั้งหมด tests
4. รัน Android debug build
5. ตรวจ Git diff สำหรับ secrets
6. ตรวจ health data leakage
7. ตรวจ unhandled exceptions
8. ตรวจ database initialization failure
9. ตรวจ migration interruption
10. ตรวจ dependency updates

**Acceptance Criteria:**
- Flutter analyze pass
- Format check pass
- All tests pass
- Android build pass
- No secrets in Git
- No health data in logs

---

### Milestone 12: Demo & Evidence for 20-Point Criteria
**Status:** BLOCKED (Depends on all previous milestones)

**Tasks:**
1. สร้าง `docs/DEMO_SCRIPT.md`
2. เตรียม fallback สำหรับส่วนที่ทำไม่ได้
3. รวบรวม evidence จากทุก milestone
4. สรุป Final Gap Matrix
5. เตรียม demo readiness report

**Acceptance Criteria:**
- Demo script ครอบคลุม 6 เกณฑ์
- Fallback แสดงสถานะอย่างตรงไปตรงมา
- Evidence จากผลรันจริง
- Final Gap Matrix อ้างอิงไฟล์จริง

---

## Dependency Graph

```
Milestone 1 (Audit) → All other milestones
Milestone 2 (Data Architecture) → Milestone 4, 6, 9
Milestone 3 (Firebase) → Milestone 4, 9
Milestone 4 (Sync) → Milestone 9
Milestone 5 (OCR) → Milestone 9 (independent from others)
Milestone 6 (Stock) → Milestone 9 (depends on Milestone 2)
Milestone 7 (Notification) → Milestone 9 (independent, can verify in parallel)
Milestone 8 (UI/UX) → Milestone 9 (independent)
Milestone 9 (Testing) → Milestone 10, 11, 12
Milestone 10 (CI) → Milestone 11, 12
Milestone 11 (Regression) → Milestone 12
```

**Parallel work possible:**
- Milestone 5 (OCR) + Milestone 7 (Notification) + Milestone 8 (UI/UX) can run in parallel
- Milestone 2 (Data Architecture) + Milestone 3 preparation (config template) can run in parallel
- Milestone 6 (Stock) after Milestone 2, can run with other independent work

---

## Blockers & User Actions

### Critical Blockers (ทำต่อไม่ได้):
1. **Firebase project ยังไม่มี** → User ต้องสร้าง Firebase project และดาวน์โหลด config
2. **Android device/emulator ไม่มี** → Device verification สำหรับ notifications จำเป็นต้องมี hardware

### Partial Blockers (ทำได้บางส่วน):
1. **No macOS/Xcode** → iOS build verification ไม่สามารถทำได้ (แต่โปรเจกต์ focus Android)
2. **No real device** → Manual device tests ต้องบันทึกเป็น "NEEDS DEVICE"

---

## Next Steps (Immediate)

1. **Start Milestone 2:** Add Drift database, design schema, implement migration
2. **Work in parallel:** Milestone 5 (OCR tests), Milestone 8 (UI/UX improvements)
3. **Prepare Firebase config template:** สำหรับ Milestone 3 เมื่อ user มี credentials
4. **Create Firebase setup guide:** วิธีสร้าง project และตั้งค่า FlutterFire CLI

---

## Files to Create

- `docs/DATA_ARCHITECTURE.md`
- `docs/USABILITY_TEST_PROTOCOL.md`
- `docs/USABILITY_TEST_FORM.md`
- `docs/TESTING.md`
- `docs/DEMO_SCRIPT.md`
- `docs/FIREBASE_SETUP.md` (template)
- `.github/workflows/ci.yml`
- `lib/data/database/` (Drift database)
- `lib/data/repositories/` (Repository layer)
- `test/unit/`
- `test/widget/`
- `test/integration/`
- `test/security/`

---

## Evidence Collection

ทุก milestone ต้องเก็บ:
- Screenshot ของผลรัน tests
- Coverage report (LCOV HTML)
- CI run logs
- Build artifacts
- Demo recordings (ถ้าทำได้)

---

## Last Updated

2026-10-27 - Initial audit and planning
