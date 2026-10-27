# Med Reminder Data Architecture

## Overview

ระบบใช้ **Drift (SQLite wrapper)** เป็น local database และ **Cloud Firestore** เป็น remote backend สำหรับ sync ข้อมูล

### Single Source of Truth
- **Local Database (Drift):** Primary source สำหรับ offline operations
- **Cloud Firestore:** Remote sync และ cross-device access
- **Sync Queue:** อิง local database สำหรับ tracking pending operations

---

## Schema Design

### 1. Medication Table

```dart
@DataClassName('MedicationRecord')
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()(); // Firebase Auth UID
  TextColumn get name => text()();
  IntColumn get quantity => integer()();
  IntColumn get lowStockThreshold => integer().withDefault(const Constant(5))();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get serverId => text().nullable()(); // Firestore document ID

  @override
  Set<Column> get primaryKey => {id};
}
```

**Constraints:**
- `id` เป็น primary key (UUID หรือ timestamp-based)
- `userId` สำหรับ account isolation
- `isDeleted` สำหรับ soft delete (tombstone policy)
- `serverId` สำหรับ mapping กับ Firestore

---

### 2. Schedule Table

```dart
@DataClassName('ScheduleRecord')
class Schedules extends Table {
  TextColumn get id => text()();
  TextColumn get medId => text()();
  TextColumn get userId => text()();
  TextColumn get times => text()(); // JSON array: ["08:00", "20:00"]
  TextColumn get daysOfWeek => text()(); // JSON array: [1,2,3,4,5,6,7]
  IntColumn get dosePerTime => integer().withDefault(const Constant(1))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get serverId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  // Foreign key logic enforced at application level
}
```

**Constraints:**
- `medId` ต้องอ้างอิงถึง medication ที่มีอยู่
- `userId` สำหรับ account isolation
- `times` และ `daysOfWeek` เก็บเป็น JSON string

---

### 3. IntakeLog Table

```dart
@DataClassName('IntakeLogRecord')
class IntakeLogs extends Table {
  TextColumn get id => text()();
  TextColumn get medId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  DateTimeColumn get actedAt => dateTime().nullable()();
  TextColumn get status => text()(); // "taken", "skipped", "missed"
  IntColumn get dose => integer()();
  TextColumn get idempotencyKey => text()(); // ป้องกัน duplicate sync
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get serverId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  // Unique constraint: ป้องกัน log ซ้ำสำหรับ medId + scheduledAt
  @override
  List<Set<Column>>? get uniqueKeys => [
        {medId, scheduledAt},
      ];
}
```

**Constraints:**
- `idempotencyKey` สำหรับ sync operations
- Unique constraint บน `(medId, scheduledAt)` ป้องกัน duplicate logs
- `userId` สำหรับ account isolation

---

### 4. SyncQueue Table

```dart
@DataClassName('SyncQueueRecord')
class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()(); // "medication", "schedule", "intake_log"
  TextColumn get entityId => text()();
  TextColumn get operation => text()(); // "create", "update", "delete"
  TextColumn get payload => text()(); // JSON string of entity data
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text()(); // "pending", "synced", "failed"
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Constraints:**
- `entityType` + `entityId` ระบุ entity ที่ต้อง sync
- `retryCount` สำหรับ backoff logic
- `status` tracking

---

### 5. UserSettings Table

```dart
@DataClassName('UserSettingsRecord')
class UserSettings extends Table {
  TextColumn get userId => text()();
  BoolColumn get remindersEnabled => boolean().withDefault(const Constant(false))();
  BoolColumn get lowStockAlertsEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get lastSyncTime => text().nullable()(); // ISO string
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId};
}
```

**Constraints:**
- `userId` เป็น primary key (1 record per user)

---

## Migration Strategy

### Migration from JSON to Drift

**Source:** `med_reminder_data_v1.json` (MethodChannel storage)

**Target:** Drift SQLite database

**Steps:**

1. **Backup JSON data** → `med_reminder_data_v1_backup_<timestamp>.json`
2. **Initialize Drift database** (schema version 1)
3. **Read JSON** → Parse medications, schedules, logs
4. **Validate data integrity** → Check relationships, null checks
5. **Write to Drift** → Insert records in transaction
6. **Verify counts** → Compare JSON count vs Drift count
7. **Mark migration complete** → Store migration version in UserSettings
8. **Keep JSON backup** → ไม่ลบจนกว่า verification ผ่าน

**Rollback:**
- หาก migration ล้มเหลว → Restore จาก JSON backup
- หาก Drift ใช้งานได้ → ลบ JSON backup หลัง 7 วัน

---

### Migration Versioning

| Version | Changes | Date |
|---|---|---|
| v1 (Initial) | Migrate from JSON to Drift | 2026-10-27 |
| v2 (Future) | Add sync queue table | TBD |
| v3 (Future) | Add index optimization | TBD |

**Implementation:**
```dart
@DriftDatabase(tables: [Medications, Schedules, IntakeLogs, SyncQueue, UserSettings])
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAllTables();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations
      },
    );
  }
}
```

---

## Firestore Mapping

### Collection Structure

```
users/{userId}
  ├── medications/{medicationId}
  ├── schedules/{scheduleId}
  └── intake_logs/{intakeLogId}
```

### Firestore Document Examples

**Medication:**
```json
{
  "name": "Paracetamol",
  "quantity": 30,
  "lowStockThreshold": 5,
  "imageUrl": "https://...",
  "notes": "Take after meals",
  "createdAt": "2026-10-27T10:00:00Z",
  "updatedAt": "2026-10-27T10:00:00Z",
  "isDeleted": false
}
```

**Schedule:**
```json
{
  "medId": "med_123",
  "times": ["08:00", "20:00"],
  "daysOfWeek": [1, 2, 3, 4, 5, 6, 7],
  "dosePerTime": 1,
  "isActive": true,
  "updatedAt": "2026-10-27T10:00:00Z",
  "isDeleted": false
}
```

**IntakeLog:**
```json
{
  "medId": "med_123",
  "scheduledAt": "2026-10-27T08:00:00Z",
  "actedAt": "2026-10-27T08:05:00Z",
  "status": "taken",
  "dose": 1,
  "idempotencyKey": "log_123",
  "createdAt": "2026-10-27T08:05:00Z"
}
```

---

## Sync Queue & Retry Logic

### Sync Flow

1. **User action** → Update local database
2. **Add to SyncQueue** → `entityType`, `entityId`, `operation`, `payload`
3. **Background sync** → Process pending operations
4. **On success** → Mark status `synced`, update `serverId`
5. **On failure** → Increment `retryCount`, mark status `failed`
6. **Retry logic** → Exponential backoff (1s, 2s, 4s, 8s, 16s, max 60s)
7. **Max retries** → 5 attempts, then manual user action

### Conflict Resolution Policy

| Entity Type | Conflict Policy | Rationale |
|---|---|---|
| Medication (name, notes) | Last-write-wins | Text fields ไม่สำคัญที่ critical |
| Medication (quantity) | Max value | ป้องกัน stock ติดลบ |
| Schedule (times, days) | Last-write-wins | User แก้ตาราง = ตั้งใจ |
| IntakeLog | Idempotency key | ป้องกัน duplicate sync |
| Deletion | Soft delete wins | ถ้าลบแล้ว ไม่ควรกลับมา |

**Implementation:**
```dart
Future<void> resolveConflict(String entityType, String entityId, Map<String, dynamic> local, Map<String, dynamic> remote) {
  switch (entityType) {
    case 'medication':
      final localQty = local['quantity'] as int;
      final remoteQty = remote['quantity'] as int;
      return max(localQty, remoteQty); // Keep higher stock
    case 'intake_log':
      // Use idempotency key
      return local['idempotencyKey'] == remote['idempotencyKey'] ? local : remote;
    default:
      return remote; // Last-write-wins
  }
}
```

---

## Delete / Tombstone Policy

### Soft Delete

- เมื่อลบ medication → ตั้ง `isDeleted = true`
- เมื่อลบ schedule → ตั้ง `isDeleted = true`
- **ไม่ลบ intake logs** (คงประวัติไว้)

### Sync Behavior

- Local delete → Add to SyncQueue with operation `delete`
- Remote delete → Mark local `isDeleted = true`
- **Tombstone retention:** 30 วัน หลังจากนั้นถึง hard delete ได้

---

## Account Isolation

### Sign-Out / Account Switch

**Policy:**
1. **Sign-out:** ไม่ลบ local data (offline access)
2. **Switch account:** แสดงเฉพาะ data ของ user ปัจจุบัน
3. **Data visibility:** Query ต้อง filter ด้วย `userId`

**Implementation:**
```dart
// All queries must include userId filter
Future<List<MedicationRecord>> getMedications(String userId) {
  return (select(medications)..where((m) => m.userId.equals(userId))).get();
}
```

**First-time user:**
- หากไม่มี local data → Load จาก Firestore
- หาก Firestore ว่าง → Start with empty state

---

## Backup / Restore

### Backup Strategy

1. **Automatic backup:** ทุกครั้งที่มีการเปลี่ยนแปลงสำคัญ (เพิ่มยา, ลบยา)
2. **Manual backup:** Export JSON ผ่าน settings screen
3. **Backup location:** `filesDir/med_reminder_backup_v2_<timestamp>.json`

### Restore Flow

1. User เลือก backup file
2. Validate JSON structure
3. Confirm restore (warning: จะทับข้อมูลปัจจุบัน)
4. Restore to Drift in transaction
5. Verify counts
6. Clear SyncQueue (reset sync state)

---

## Offline-First Architecture

### Read Flow

```
UI → Repository → Local Database (Drift) → Return
```

### Write Flow

```
UI → Repository → Local Database (Drift) → SyncQueue → Background Sync
```

### Sync Flow

```
Background Service → Check network
  → If online: Process SyncQueue
  → For each operation:
    - Serialize payload
    - Send to Firestore
    - On success: Update serverId, mark synced
    - On failure: Increment retryCount, mark failed
```

### Reconnect Handling

```
App gains network
  → Trigger sync immediately
  → Process all pending operations
  → Show sync status in UI
```

---

## Error Handling

### Database Errors

- **Corruption:** Attempt migration from backup
- **Lock timeout:** Retry with exponential backoff
- **Constraint violation:** Show user-friendly error, don't crash

### Sync Errors

- **Network timeout:** Add to retry queue
- **Permission denied:** Show auth error, prompt sign-in
- **Server error:** Log error, show "sync failed" status

---

## Transaction Requirements

### Critical Transactions

1. **Add medication:**
   - Insert Medication
   - Insert Schedule
   - Add to SyncQueue (2 operations)

2. **Record intake:**
   - Insert IntakeLog
   - Update Medication.quantity
   - Add to SyncQueue (2 operations)

3. **Delete medication:**
   - Update Medication.isDeleted = true
   - Update Schedule.isDeleted = true
   - Add to SyncQueue (2 operations)

---

## Performance Considerations

### Indexes

```dart
@Index(name: 'idx_medications_userId', columns: [#userId])
@Index(name: 'idx_schedules_medId', columns: [#medId])
@Index(name: 'idx_intake_logs_medId_scheduledAt', columns: [#medId, #scheduledAt])
@Index(name: 'idx_sync_queue_status', columns: [#status])
```

### Query Optimization

- ใช้ indexed columns สำหรับ filter หลัก (userId, medId)
- Limit query results สำหรับ UI lists (pagination ถ้าจำเป็น)
- Cache frequent queries ใน memory (Riverpod)

---

## Security Considerations

### Local Data

- SQLite database อยู่ใน app-private directory (protected by Android sandbox)
- **ไม่ encrypt** เพื่อ performance (acceptable สำหรับ health data non-critical)
- User สามารถ root device และเข้าถึงได้ (accepted risk)

### Firestore Data

- **Server-side security rules** ป้องกัน cross-user access
- **No PII** ใน document IDs
- **Timestamp validation** ป้องกัน clock skew attacks

---

## Testing Strategy

### Unit Tests

- Migration logic (JSON → Drift)
- Stock calculations
- Idempotency key generation
- Conflict resolution logic

### Integration Tests

- Offline CRUD
- Reconnect sync
- Retry logic
- Account switching

### Recovery Tests

- Corrupted database recovery
- Migration failure rollback
- Backup/restore flow

---

## Last Updated

2026-10-27 - Initial schema design and migration strategy
