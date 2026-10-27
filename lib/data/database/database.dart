import 'package:drift/drift.dart';

part 'database.g.dart';

@DataClassName('MedicationRecord')
class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  IntColumn get quantity => integer()();
  IntColumn get lowStockThreshold => integer().withDefault(const Constant(5))();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get serverId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>>? get uniqueKeys => [
        {userId, id},
      ];
}

@DataClassName('ScheduleRecord')
class Schedules extends Table {
  TextColumn get id => text()();
  TextColumn get medId => text()();
  TextColumn get userId => text()();
  TextColumn get times => text()();
  TextColumn get daysOfWeek => text()();
  IntColumn get dosePerTime => integer().withDefault(const Constant(1))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  TextColumn get serverId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('IntakeLogRecord')
class IntakeLogs extends Table {
  TextColumn get id => text()();
  TextColumn get medId => text()();
  TextColumn get userId => text()();
  DateTimeColumn get scheduledAt => dateTime()();
  DateTimeColumn get actedAt => dateTime().nullable()();
  TextColumn get status => text()();
  IntColumn get dose => integer()();
  TextColumn get idempotencyKey => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get serverId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>>? get uniqueKeys => [
        {medId, scheduledAt},
      ];
}

@DataClassName('SyncQueueRecord')
class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('UserSettingsRecord')
class UserSettings extends Table {
  TextColumn get userId => text()();
  BoolColumn get remindersEnabled => boolean().withDefault(const Constant(false))();
  BoolColumn get lowStockAlertsEnabled => boolean().withDefault(const Constant(true))();
  TextColumn get lastSyncTime => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId};
}

@DriftDatabase(
  tables: [Medications, Schedules, IntakeLogs, SyncQueue, UserSettings],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations
      },
    );
  }
}
