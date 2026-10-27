// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MedicationsTable extends Medications
    with TableInfo<$MedicationsTable, MedicationRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lowStockThresholdMeta = const VerificationMeta(
    'lowStockThreshold',
  );
  @override
  late final GeneratedColumn<int> lowStockThreshold = GeneratedColumn<int>(
    'low_stock_threshold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    quantity,
    lowStockThreshold,
    imageUrl,
    notes,
    createdAt,
    updatedAt,
    isDeleted,
    serverId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medications';
  @override
  VerificationContext validateIntegrity(
    Insertable<MedicationRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
        _lowStockThresholdMeta,
        lowStockThreshold.isAcceptableOrUnknown(
          data['low_stock_threshold']!,
          _lowStockThresholdMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, id},
  ];
  @override
  MedicationRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicationRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      lowStockThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}low_stock_threshold'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
    );
  }

  @override
  $MedicationsTable createAlias(String alias) {
    return $MedicationsTable(attachedDatabase, alias);
  }
}

class MedicationRecord extends DataClass
    implements Insertable<MedicationRecord> {
  final String id;
  final String userId;
  final String name;
  final int quantity;
  final int lowStockThreshold;
  final String? imageUrl;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final String? serverId;
  const MedicationRecord({
    required this.id,
    required this.userId,
    required this.name,
    required this.quantity,
    required this.lowStockThreshold,
    this.imageUrl,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.serverId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<int>(quantity);
    map['low_stock_threshold'] = Variable<int>(lowStockThreshold);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    return map;
  }

  MedicationsCompanion toCompanion(bool nullToAbsent) {
    return MedicationsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      quantity: Value(quantity),
      lowStockThreshold: Value(lowStockThreshold),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory MedicationRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicationRecord(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<int>(json['quantity']),
      lowStockThreshold: serializer.fromJson<int>(json['lowStockThreshold']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      serverId: serializer.fromJson<String?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<int>(quantity),
      'lowStockThreshold': serializer.toJson<int>(lowStockThreshold),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'serverId': serializer.toJson<String?>(serverId),
    };
  }

  MedicationRecord copyWith({
    String? id,
    String? userId,
    String? name,
    int? quantity,
    int? lowStockThreshold,
    Value<String?> imageUrl = const Value.absent(),
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    Value<String?> serverId = const Value.absent(),
  }) => MedicationRecord(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    serverId: serverId.present ? serverId.value : this.serverId,
  );
  MedicationRecord copyWithCompanion(MedicationsCompanion data) {
    return MedicationRecord(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicationRecord(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    quantity,
    lowStockThreshold,
    imageUrl,
    notes,
    createdAt,
    updatedAt,
    isDeleted,
    serverId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicationRecord &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.lowStockThreshold == this.lowStockThreshold &&
          other.imageUrl == this.imageUrl &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.serverId == this.serverId);
}

class MedicationsCompanion extends UpdateCompanion<MedicationRecord> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<int> quantity;
  final Value<int> lowStockThreshold;
  final Value<String?> imageUrl;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<String?> serverId;
  final Value<int> rowid;
  const MedicationsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicationsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required int quantity,
    this.lowStockThreshold = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.serverId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       quantity = Value(quantity),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<MedicationRecord> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<int>? quantity,
    Expression<int>? lowStockThreshold,
    Expression<String>? imageUrl,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<String>? serverId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (imageUrl != null) 'image_url': imageUrl,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (serverId != null) 'server_id': serverId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicationsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<int>? quantity,
    Value<int>? lowStockThreshold,
    Value<String?>? imageUrl,
    Value<String>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<String?>? serverId,
    Value<int>? rowid,
  }) {
    return MedicationsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      imageUrl: imageUrl ?? this.imageUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      serverId: serverId ?? this.serverId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<int>(lowStockThreshold.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicationsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverId: $serverId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SchedulesTable extends Schedules
    with TableInfo<$SchedulesTable, ScheduleRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medIdMeta = const VerificationMeta('medId');
  @override
  late final GeneratedColumn<String> medId = GeneratedColumn<String>(
    'med_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timesMeta = const VerificationMeta('times');
  @override
  late final GeneratedColumn<String> times = GeneratedColumn<String>(
    'times',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _daysOfWeekMeta = const VerificationMeta(
    'daysOfWeek',
  );
  @override
  late final GeneratedColumn<String> daysOfWeek = GeneratedColumn<String>(
    'days_of_week',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosePerTimeMeta = const VerificationMeta(
    'dosePerTime',
  );
  @override
  late final GeneratedColumn<int> dosePerTime = GeneratedColumn<int>(
    'dose_per_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medId,
    userId,
    times,
    daysOfWeek,
    dosePerTime,
    isActive,
    updatedAt,
    isDeleted,
    serverId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedules';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('med_id')) {
      context.handle(
        _medIdMeta,
        medId.isAcceptableOrUnknown(data['med_id']!, _medIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('times')) {
      context.handle(
        _timesMeta,
        times.isAcceptableOrUnknown(data['times']!, _timesMeta),
      );
    } else if (isInserting) {
      context.missing(_timesMeta);
    }
    if (data.containsKey('days_of_week')) {
      context.handle(
        _daysOfWeekMeta,
        daysOfWeek.isAcceptableOrUnknown(
          data['days_of_week']!,
          _daysOfWeekMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_daysOfWeekMeta);
    }
    if (data.containsKey('dose_per_time')) {
      context.handle(
        _dosePerTimeMeta,
        dosePerTime.isAcceptableOrUnknown(
          data['dose_per_time']!,
          _dosePerTimeMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}med_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      times: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}times'],
      )!,
      daysOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}days_of_week'],
      )!,
      dosePerTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dose_per_time'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
    );
  }

  @override
  $SchedulesTable createAlias(String alias) {
    return $SchedulesTable(attachedDatabase, alias);
  }
}

class ScheduleRecord extends DataClass implements Insertable<ScheduleRecord> {
  final String id;
  final String medId;
  final String userId;
  final String times;
  final String daysOfWeek;
  final int dosePerTime;
  final bool isActive;
  final DateTime updatedAt;
  final bool isDeleted;
  final String? serverId;
  const ScheduleRecord({
    required this.id,
    required this.medId,
    required this.userId,
    required this.times,
    required this.daysOfWeek,
    required this.dosePerTime,
    required this.isActive,
    required this.updatedAt,
    required this.isDeleted,
    this.serverId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['med_id'] = Variable<String>(medId);
    map['user_id'] = Variable<String>(userId);
    map['times'] = Variable<String>(times);
    map['days_of_week'] = Variable<String>(daysOfWeek);
    map['dose_per_time'] = Variable<int>(dosePerTime);
    map['is_active'] = Variable<bool>(isActive);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    return map;
  }

  SchedulesCompanion toCompanion(bool nullToAbsent) {
    return SchedulesCompanion(
      id: Value(id),
      medId: Value(medId),
      userId: Value(userId),
      times: Value(times),
      daysOfWeek: Value(daysOfWeek),
      dosePerTime: Value(dosePerTime),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory ScheduleRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleRecord(
      id: serializer.fromJson<String>(json['id']),
      medId: serializer.fromJson<String>(json['medId']),
      userId: serializer.fromJson<String>(json['userId']),
      times: serializer.fromJson<String>(json['times']),
      daysOfWeek: serializer.fromJson<String>(json['daysOfWeek']),
      dosePerTime: serializer.fromJson<int>(json['dosePerTime']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      serverId: serializer.fromJson<String?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medId': serializer.toJson<String>(medId),
      'userId': serializer.toJson<String>(userId),
      'times': serializer.toJson<String>(times),
      'daysOfWeek': serializer.toJson<String>(daysOfWeek),
      'dosePerTime': serializer.toJson<int>(dosePerTime),
      'isActive': serializer.toJson<bool>(isActive),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'serverId': serializer.toJson<String?>(serverId),
    };
  }

  ScheduleRecord copyWith({
    String? id,
    String? medId,
    String? userId,
    String? times,
    String? daysOfWeek,
    int? dosePerTime,
    bool? isActive,
    DateTime? updatedAt,
    bool? isDeleted,
    Value<String?> serverId = const Value.absent(),
  }) => ScheduleRecord(
    id: id ?? this.id,
    medId: medId ?? this.medId,
    userId: userId ?? this.userId,
    times: times ?? this.times,
    daysOfWeek: daysOfWeek ?? this.daysOfWeek,
    dosePerTime: dosePerTime ?? this.dosePerTime,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
    serverId: serverId.present ? serverId.value : this.serverId,
  );
  ScheduleRecord copyWithCompanion(SchedulesCompanion data) {
    return ScheduleRecord(
      id: data.id.present ? data.id.value : this.id,
      medId: data.medId.present ? data.medId.value : this.medId,
      userId: data.userId.present ? data.userId.value : this.userId,
      times: data.times.present ? data.times.value : this.times,
      daysOfWeek: data.daysOfWeek.present
          ? data.daysOfWeek.value
          : this.daysOfWeek,
      dosePerTime: data.dosePerTime.present
          ? data.dosePerTime.value
          : this.dosePerTime,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleRecord(')
          ..write('id: $id, ')
          ..write('medId: $medId, ')
          ..write('userId: $userId, ')
          ..write('times: $times, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('dosePerTime: $dosePerTime, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medId,
    userId,
    times,
    daysOfWeek,
    dosePerTime,
    isActive,
    updatedAt,
    isDeleted,
    serverId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleRecord &&
          other.id == this.id &&
          other.medId == this.medId &&
          other.userId == this.userId &&
          other.times == this.times &&
          other.daysOfWeek == this.daysOfWeek &&
          other.dosePerTime == this.dosePerTime &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted &&
          other.serverId == this.serverId);
}

class SchedulesCompanion extends UpdateCompanion<ScheduleRecord> {
  final Value<String> id;
  final Value<String> medId;
  final Value<String> userId;
  final Value<String> times;
  final Value<String> daysOfWeek;
  final Value<int> dosePerTime;
  final Value<bool> isActive;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<String?> serverId;
  final Value<int> rowid;
  const SchedulesCompanion({
    this.id = const Value.absent(),
    this.medId = const Value.absent(),
    this.userId = const Value.absent(),
    this.times = const Value.absent(),
    this.daysOfWeek = const Value.absent(),
    this.dosePerTime = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SchedulesCompanion.insert({
    required String id,
    required String medId,
    required String userId,
    required String times,
    required String daysOfWeek,
    this.dosePerTime = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.serverId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medId = Value(medId),
       userId = Value(userId),
       times = Value(times),
       daysOfWeek = Value(daysOfWeek),
       updatedAt = Value(updatedAt);
  static Insertable<ScheduleRecord> custom({
    Expression<String>? id,
    Expression<String>? medId,
    Expression<String>? userId,
    Expression<String>? times,
    Expression<String>? daysOfWeek,
    Expression<int>? dosePerTime,
    Expression<bool>? isActive,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<String>? serverId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medId != null) 'med_id': medId,
      if (userId != null) 'user_id': userId,
      if (times != null) 'times': times,
      if (daysOfWeek != null) 'days_of_week': daysOfWeek,
      if (dosePerTime != null) 'dose_per_time': dosePerTime,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (serverId != null) 'server_id': serverId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SchedulesCompanion copyWith({
    Value<String>? id,
    Value<String>? medId,
    Value<String>? userId,
    Value<String>? times,
    Value<String>? daysOfWeek,
    Value<int>? dosePerTime,
    Value<bool>? isActive,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
    Value<String?>? serverId,
    Value<int>? rowid,
  }) {
    return SchedulesCompanion(
      id: id ?? this.id,
      medId: medId ?? this.medId,
      userId: userId ?? this.userId,
      times: times ?? this.times,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      dosePerTime: dosePerTime ?? this.dosePerTime,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      serverId: serverId ?? this.serverId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medId.present) {
      map['med_id'] = Variable<String>(medId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (times.present) {
      map['times'] = Variable<String>(times.value);
    }
    if (daysOfWeek.present) {
      map['days_of_week'] = Variable<String>(daysOfWeek.value);
    }
    if (dosePerTime.present) {
      map['dose_per_time'] = Variable<int>(dosePerTime.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchedulesCompanion(')
          ..write('id: $id, ')
          ..write('medId: $medId, ')
          ..write('userId: $userId, ')
          ..write('times: $times, ')
          ..write('daysOfWeek: $daysOfWeek, ')
          ..write('dosePerTime: $dosePerTime, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverId: $serverId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IntakeLogsTable extends IntakeLogs
    with TableInfo<$IntakeLogsTable, IntakeLogRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntakeLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medIdMeta = const VerificationMeta('medId');
  @override
  late final GeneratedColumn<String> medId = GeneratedColumn<String>(
    'med_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledAtMeta = const VerificationMeta(
    'scheduledAt',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledAt = GeneratedColumn<DateTime>(
    'scheduled_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actedAtMeta = const VerificationMeta(
    'actedAt',
  );
  @override
  late final GeneratedColumn<DateTime> actedAt = GeneratedColumn<DateTime>(
    'acted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<int> dose = GeneratedColumn<int>(
    'dose',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _idempotencyKeyMeta = const VerificationMeta(
    'idempotencyKey',
  );
  @override
  late final GeneratedColumn<String> idempotencyKey = GeneratedColumn<String>(
    'idempotency_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medId,
    userId,
    scheduledAt,
    actedAt,
    status,
    dose,
    idempotencyKey,
    createdAt,
    serverId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'intake_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<IntakeLogRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('med_id')) {
      context.handle(
        _medIdMeta,
        medId.isAcceptableOrUnknown(data['med_id']!, _medIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('scheduled_at')) {
      context.handle(
        _scheduledAtMeta,
        scheduledAt.isAcceptableOrUnknown(
          data['scheduled_at']!,
          _scheduledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledAtMeta);
    }
    if (data.containsKey('acted_at')) {
      context.handle(
        _actedAtMeta,
        actedAt.isAcceptableOrUnknown(data['acted_at']!, _actedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
        _doseMeta,
        dose.isAcceptableOrUnknown(data['dose']!, _doseMeta),
      );
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    if (data.containsKey('idempotency_key')) {
      context.handle(
        _idempotencyKeyMeta,
        idempotencyKey.isAcceptableOrUnknown(
          data['idempotency_key']!,
          _idempotencyKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_idempotencyKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {medId, scheduledAt},
  ];
  @override
  IntakeLogRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IntakeLogRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      medId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}med_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      scheduledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_at'],
      )!,
      actedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}acted_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      dose: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dose'],
      )!,
      idempotencyKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}idempotency_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
    );
  }

  @override
  $IntakeLogsTable createAlias(String alias) {
    return $IntakeLogsTable(attachedDatabase, alias);
  }
}

class IntakeLogRecord extends DataClass implements Insertable<IntakeLogRecord> {
  final String id;
  final String medId;
  final String userId;
  final DateTime scheduledAt;
  final DateTime? actedAt;
  final String status;
  final int dose;
  final String idempotencyKey;
  final DateTime createdAt;
  final String? serverId;
  const IntakeLogRecord({
    required this.id,
    required this.medId,
    required this.userId,
    required this.scheduledAt,
    this.actedAt,
    required this.status,
    required this.dose,
    required this.idempotencyKey,
    required this.createdAt,
    this.serverId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['med_id'] = Variable<String>(medId);
    map['user_id'] = Variable<String>(userId);
    map['scheduled_at'] = Variable<DateTime>(scheduledAt);
    if (!nullToAbsent || actedAt != null) {
      map['acted_at'] = Variable<DateTime>(actedAt);
    }
    map['status'] = Variable<String>(status);
    map['dose'] = Variable<int>(dose);
    map['idempotency_key'] = Variable<String>(idempotencyKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    return map;
  }

  IntakeLogsCompanion toCompanion(bool nullToAbsent) {
    return IntakeLogsCompanion(
      id: Value(id),
      medId: Value(medId),
      userId: Value(userId),
      scheduledAt: Value(scheduledAt),
      actedAt: actedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(actedAt),
      status: Value(status),
      dose: Value(dose),
      idempotencyKey: Value(idempotencyKey),
      createdAt: Value(createdAt),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
    );
  }

  factory IntakeLogRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IntakeLogRecord(
      id: serializer.fromJson<String>(json['id']),
      medId: serializer.fromJson<String>(json['medId']),
      userId: serializer.fromJson<String>(json['userId']),
      scheduledAt: serializer.fromJson<DateTime>(json['scheduledAt']),
      actedAt: serializer.fromJson<DateTime?>(json['actedAt']),
      status: serializer.fromJson<String>(json['status']),
      dose: serializer.fromJson<int>(json['dose']),
      idempotencyKey: serializer.fromJson<String>(json['idempotencyKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      serverId: serializer.fromJson<String?>(json['serverId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'medId': serializer.toJson<String>(medId),
      'userId': serializer.toJson<String>(userId),
      'scheduledAt': serializer.toJson<DateTime>(scheduledAt),
      'actedAt': serializer.toJson<DateTime?>(actedAt),
      'status': serializer.toJson<String>(status),
      'dose': serializer.toJson<int>(dose),
      'idempotencyKey': serializer.toJson<String>(idempotencyKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'serverId': serializer.toJson<String?>(serverId),
    };
  }

  IntakeLogRecord copyWith({
    String? id,
    String? medId,
    String? userId,
    DateTime? scheduledAt,
    Value<DateTime?> actedAt = const Value.absent(),
    String? status,
    int? dose,
    String? idempotencyKey,
    DateTime? createdAt,
    Value<String?> serverId = const Value.absent(),
  }) => IntakeLogRecord(
    id: id ?? this.id,
    medId: medId ?? this.medId,
    userId: userId ?? this.userId,
    scheduledAt: scheduledAt ?? this.scheduledAt,
    actedAt: actedAt.present ? actedAt.value : this.actedAt,
    status: status ?? this.status,
    dose: dose ?? this.dose,
    idempotencyKey: idempotencyKey ?? this.idempotencyKey,
    createdAt: createdAt ?? this.createdAt,
    serverId: serverId.present ? serverId.value : this.serverId,
  );
  IntakeLogRecord copyWithCompanion(IntakeLogsCompanion data) {
    return IntakeLogRecord(
      id: data.id.present ? data.id.value : this.id,
      medId: data.medId.present ? data.medId.value : this.medId,
      userId: data.userId.present ? data.userId.value : this.userId,
      scheduledAt: data.scheduledAt.present
          ? data.scheduledAt.value
          : this.scheduledAt,
      actedAt: data.actedAt.present ? data.actedAt.value : this.actedAt,
      status: data.status.present ? data.status.value : this.status,
      dose: data.dose.present ? data.dose.value : this.dose,
      idempotencyKey: data.idempotencyKey.present
          ? data.idempotencyKey.value
          : this.idempotencyKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IntakeLogRecord(')
          ..write('id: $id, ')
          ..write('medId: $medId, ')
          ..write('userId: $userId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('actedAt: $actedAt, ')
          ..write('status: $status, ')
          ..write('dose: $dose, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('serverId: $serverId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medId,
    userId,
    scheduledAt,
    actedAt,
    status,
    dose,
    idempotencyKey,
    createdAt,
    serverId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IntakeLogRecord &&
          other.id == this.id &&
          other.medId == this.medId &&
          other.userId == this.userId &&
          other.scheduledAt == this.scheduledAt &&
          other.actedAt == this.actedAt &&
          other.status == this.status &&
          other.dose == this.dose &&
          other.idempotencyKey == this.idempotencyKey &&
          other.createdAt == this.createdAt &&
          other.serverId == this.serverId);
}

class IntakeLogsCompanion extends UpdateCompanion<IntakeLogRecord> {
  final Value<String> id;
  final Value<String> medId;
  final Value<String> userId;
  final Value<DateTime> scheduledAt;
  final Value<DateTime?> actedAt;
  final Value<String> status;
  final Value<int> dose;
  final Value<String> idempotencyKey;
  final Value<DateTime> createdAt;
  final Value<String?> serverId;
  final Value<int> rowid;
  const IntakeLogsCompanion({
    this.id = const Value.absent(),
    this.medId = const Value.absent(),
    this.userId = const Value.absent(),
    this.scheduledAt = const Value.absent(),
    this.actedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.dose = const Value.absent(),
    this.idempotencyKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.serverId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IntakeLogsCompanion.insert({
    required String id,
    required String medId,
    required String userId,
    required DateTime scheduledAt,
    this.actedAt = const Value.absent(),
    required String status,
    required int dose,
    required String idempotencyKey,
    required DateTime createdAt,
    this.serverId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       medId = Value(medId),
       userId = Value(userId),
       scheduledAt = Value(scheduledAt),
       status = Value(status),
       dose = Value(dose),
       idempotencyKey = Value(idempotencyKey),
       createdAt = Value(createdAt);
  static Insertable<IntakeLogRecord> custom({
    Expression<String>? id,
    Expression<String>? medId,
    Expression<String>? userId,
    Expression<DateTime>? scheduledAt,
    Expression<DateTime>? actedAt,
    Expression<String>? status,
    Expression<int>? dose,
    Expression<String>? idempotencyKey,
    Expression<DateTime>? createdAt,
    Expression<String>? serverId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medId != null) 'med_id': medId,
      if (userId != null) 'user_id': userId,
      if (scheduledAt != null) 'scheduled_at': scheduledAt,
      if (actedAt != null) 'acted_at': actedAt,
      if (status != null) 'status': status,
      if (dose != null) 'dose': dose,
      if (idempotencyKey != null) 'idempotency_key': idempotencyKey,
      if (createdAt != null) 'created_at': createdAt,
      if (serverId != null) 'server_id': serverId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IntakeLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? medId,
    Value<String>? userId,
    Value<DateTime>? scheduledAt,
    Value<DateTime?>? actedAt,
    Value<String>? status,
    Value<int>? dose,
    Value<String>? idempotencyKey,
    Value<DateTime>? createdAt,
    Value<String?>? serverId,
    Value<int>? rowid,
  }) {
    return IntakeLogsCompanion(
      id: id ?? this.id,
      medId: medId ?? this.medId,
      userId: userId ?? this.userId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      actedAt: actedAt ?? this.actedAt,
      status: status ?? this.status,
      dose: dose ?? this.dose,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      createdAt: createdAt ?? this.createdAt,
      serverId: serverId ?? this.serverId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (medId.present) {
      map['med_id'] = Variable<String>(medId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (scheduledAt.present) {
      map['scheduled_at'] = Variable<DateTime>(scheduledAt.value);
    }
    if (actedAt.present) {
      map['acted_at'] = Variable<DateTime>(actedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dose.present) {
      map['dose'] = Variable<int>(dose.value);
    }
    if (idempotencyKey.present) {
      map['idempotency_key'] = Variable<String>(idempotencyKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntakeLogsCompanion(')
          ..write('id: $id, ')
          ..write('medId: $medId, ')
          ..write('userId: $userId, ')
          ..write('scheduledAt: $scheduledAt, ')
          ..write('actedAt: $actedAt, ')
          ..write('status: $status, ')
          ..write('dose: $dose, ')
          ..write('idempotencyKey: $idempotencyKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('serverId: $serverId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payload,
    retryCount,
    status,
    errorMessage,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueRecord extends DataClass implements Insertable<SyncQueueRecord> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final int retryCount;
  final String status;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncQueueRecord({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.retryCount,
    required this.status,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['retry_count'] = Variable<int>(retryCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      retryCount: Value(retryCount),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueRecord(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'retryCount': serializer.toJson<int>(retryCount),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncQueueRecord copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payload,
    int? retryCount,
    String? status,
    Value<String?> errorMessage = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SyncQueueRecord(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    retryCount: retryCount ?? this.retryCount,
    status: status ?? this.status,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SyncQueueRecord copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueRecord(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueRecord(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payload,
    retryCount,
    status,
    errorMessage,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueRecord &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.retryCount == this.retryCount &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueRecord> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<int> retryCount;
  final Value<String> status;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    this.retryCount = const Value.absent(),
    required String status,
    this.errorMessage = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       payload = Value(payload),
       status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SyncQueueRecord> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<int>? retryCount,
    Expression<String>? status,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (retryCount != null) 'retry_count': retryCount,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payload,
    Value<int>? retryCount,
    Value<String>? status,
    Value<String?>? errorMessage,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSettingsRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remindersEnabledMeta = const VerificationMeta(
    'remindersEnabled',
  );
  @override
  late final GeneratedColumn<bool> remindersEnabled = GeneratedColumn<bool>(
    'reminders_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminders_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lowStockAlertsEnabledMeta =
      const VerificationMeta('lowStockAlertsEnabled');
  @override
  late final GeneratedColumn<bool> lowStockAlertsEnabled =
      GeneratedColumn<bool>(
        'low_stock_alerts_enabled',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("low_stock_alerts_enabled" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _lastSyncTimeMeta = const VerificationMeta(
    'lastSyncTime',
  );
  @override
  late final GeneratedColumn<String> lastSyncTime = GeneratedColumn<String>(
    'last_sync_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    remindersEnabled,
    lowStockAlertsEnabled,
    lastSyncTime,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('reminders_enabled')) {
      context.handle(
        _remindersEnabledMeta,
        remindersEnabled.isAcceptableOrUnknown(
          data['reminders_enabled']!,
          _remindersEnabledMeta,
        ),
      );
    }
    if (data.containsKey('low_stock_alerts_enabled')) {
      context.handle(
        _lowStockAlertsEnabledMeta,
        lowStockAlertsEnabled.isAcceptableOrUnknown(
          data['low_stock_alerts_enabled']!,
          _lowStockAlertsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_time')) {
      context.handle(
        _lastSyncTimeMeta,
        lastSyncTime.isAcceptableOrUnknown(
          data['last_sync_time']!,
          _lastSyncTimeMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserSettingsRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsRecord(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      remindersEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminders_enabled'],
      )!,
      lowStockAlertsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}low_stock_alerts_enabled'],
      )!,
      lastSyncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_time'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSettingsRecord extends DataClass
    implements Insertable<UserSettingsRecord> {
  final String userId;
  final bool remindersEnabled;
  final bool lowStockAlertsEnabled;
  final String? lastSyncTime;
  final DateTime updatedAt;
  const UserSettingsRecord({
    required this.userId,
    required this.remindersEnabled,
    required this.lowStockAlertsEnabled,
    this.lastSyncTime,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['reminders_enabled'] = Variable<bool>(remindersEnabled);
    map['low_stock_alerts_enabled'] = Variable<bool>(lowStockAlertsEnabled);
    if (!nullToAbsent || lastSyncTime != null) {
      map['last_sync_time'] = Variable<String>(lastSyncTime);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      userId: Value(userId),
      remindersEnabled: Value(remindersEnabled),
      lowStockAlertsEnabled: Value(lowStockAlertsEnabled),
      lastSyncTime: lastSyncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncTime),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserSettingsRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsRecord(
      userId: serializer.fromJson<String>(json['userId']),
      remindersEnabled: serializer.fromJson<bool>(json['remindersEnabled']),
      lowStockAlertsEnabled: serializer.fromJson<bool>(
        json['lowStockAlertsEnabled'],
      ),
      lastSyncTime: serializer.fromJson<String?>(json['lastSyncTime']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'remindersEnabled': serializer.toJson<bool>(remindersEnabled),
      'lowStockAlertsEnabled': serializer.toJson<bool>(lowStockAlertsEnabled),
      'lastSyncTime': serializer.toJson<String?>(lastSyncTime),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserSettingsRecord copyWith({
    String? userId,
    bool? remindersEnabled,
    bool? lowStockAlertsEnabled,
    Value<String?> lastSyncTime = const Value.absent(),
    DateTime? updatedAt,
  }) => UserSettingsRecord(
    userId: userId ?? this.userId,
    remindersEnabled: remindersEnabled ?? this.remindersEnabled,
    lowStockAlertsEnabled: lowStockAlertsEnabled ?? this.lowStockAlertsEnabled,
    lastSyncTime: lastSyncTime.present ? lastSyncTime.value : this.lastSyncTime,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserSettingsRecord copyWithCompanion(UserSettingsCompanion data) {
    return UserSettingsRecord(
      userId: data.userId.present ? data.userId.value : this.userId,
      remindersEnabled: data.remindersEnabled.present
          ? data.remindersEnabled.value
          : this.remindersEnabled,
      lowStockAlertsEnabled: data.lowStockAlertsEnabled.present
          ? data.lowStockAlertsEnabled.value
          : this.lowStockAlertsEnabled,
      lastSyncTime: data.lastSyncTime.present
          ? data.lastSyncTime.value
          : this.lastSyncTime,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsRecord(')
          ..write('userId: $userId, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('lowStockAlertsEnabled: $lowStockAlertsEnabled, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    remindersEnabled,
    lowStockAlertsEnabled,
    lastSyncTime,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsRecord &&
          other.userId == this.userId &&
          other.remindersEnabled == this.remindersEnabled &&
          other.lowStockAlertsEnabled == this.lowStockAlertsEnabled &&
          other.lastSyncTime == this.lastSyncTime &&
          other.updatedAt == this.updatedAt);
}

class UserSettingsCompanion extends UpdateCompanion<UserSettingsRecord> {
  final Value<String> userId;
  final Value<bool> remindersEnabled;
  final Value<bool> lowStockAlertsEnabled;
  final Value<String?> lastSyncTime;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserSettingsCompanion({
    this.userId = const Value.absent(),
    this.remindersEnabled = const Value.absent(),
    this.lowStockAlertsEnabled = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    required String userId,
    this.remindersEnabled = const Value.absent(),
    this.lowStockAlertsEnabled = const Value.absent(),
    this.lastSyncTime = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       updatedAt = Value(updatedAt);
  static Insertable<UserSettingsRecord> custom({
    Expression<String>? userId,
    Expression<bool>? remindersEnabled,
    Expression<bool>? lowStockAlertsEnabled,
    Expression<String>? lastSyncTime,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (remindersEnabled != null) 'reminders_enabled': remindersEnabled,
      if (lowStockAlertsEnabled != null)
        'low_stock_alerts_enabled': lowStockAlertsEnabled,
      if (lastSyncTime != null) 'last_sync_time': lastSyncTime,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsCompanion copyWith({
    Value<String>? userId,
    Value<bool>? remindersEnabled,
    Value<bool>? lowStockAlertsEnabled,
    Value<String?>? lastSyncTime,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserSettingsCompanion(
      userId: userId ?? this.userId,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      lowStockAlertsEnabled:
          lowStockAlertsEnabled ?? this.lowStockAlertsEnabled,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (remindersEnabled.present) {
      map['reminders_enabled'] = Variable<bool>(remindersEnabled.value);
    }
    if (lowStockAlertsEnabled.present) {
      map['low_stock_alerts_enabled'] = Variable<bool>(
        lowStockAlertsEnabled.value,
      );
    }
    if (lastSyncTime.present) {
      map['last_sync_time'] = Variable<String>(lastSyncTime.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('userId: $userId, ')
          ..write('remindersEnabled: $remindersEnabled, ')
          ..write('lowStockAlertsEnabled: $lowStockAlertsEnabled, ')
          ..write('lastSyncTime: $lastSyncTime, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MedicationsTable medications = $MedicationsTable(this);
  late final $SchedulesTable schedules = $SchedulesTable(this);
  late final $IntakeLogsTable intakeLogs = $IntakeLogsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    medications,
    schedules,
    intakeLogs,
    syncQueue,
    userSettings,
  ];
}

typedef $$MedicationsTableCreateCompanionBuilder =
    MedicationsCompanion Function({
      required String id,
      required String userId,
      required String name,
      required int quantity,
      Value<int> lowStockThreshold,
      Value<String?> imageUrl,
      Value<String> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<String?> serverId,
      Value<int> rowid,
    });
typedef $$MedicationsTableUpdateCompanionBuilder =
    MedicationsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> name,
      Value<int> quantity,
      Value<int> lowStockThreshold,
      Value<String?> imageUrl,
      Value<String> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<String?> serverId,
      Value<int> rowid,
    });

class $$MedicationsTableFilterComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MedicationsTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicationsTable> {
  $$MedicationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);
}

class $$MedicationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicationsTable,
          MedicationRecord,
          $$MedicationsTableFilterComposer,
          $$MedicationsTableOrderingComposer,
          $$MedicationsTableAnnotationComposer,
          $$MedicationsTableCreateCompanionBuilder,
          $$MedicationsTableUpdateCompanionBuilder,
          (
            MedicationRecord,
            BaseReferences<_$AppDatabase, $MedicationsTable, MedicationRecord>,
          ),
          MedicationRecord,
          PrefetchHooks Function()
        > {
  $$MedicationsTableTableManager(_$AppDatabase db, $MedicationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> lowStockThreshold = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion(
                id: id,
                userId: userId,
                name: name,
                quantity: quantity,
                lowStockThreshold: lowStockThreshold,
                imageUrl: imageUrl,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                serverId: serverId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required int quantity,
                Value<int> lowStockThreshold = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MedicationsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                quantity: quantity,
                lowStockThreshold: lowStockThreshold,
                imageUrl: imageUrl,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                serverId: serverId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MedicationsTable, MedicationRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MedicationsTable,
                    MedicationRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MedicationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicationsTable,
      MedicationRecord,
      $$MedicationsTableFilterComposer,
      $$MedicationsTableOrderingComposer,
      $$MedicationsTableAnnotationComposer,
      $$MedicationsTableCreateCompanionBuilder,
      $$MedicationsTableUpdateCompanionBuilder,
      (
        MedicationRecord,
        BaseReferences<_$AppDatabase, $MedicationsTable, MedicationRecord>,
      ),
      MedicationRecord,
      PrefetchHooks Function()
    >;
typedef $$SchedulesTableCreateCompanionBuilder =
    SchedulesCompanion Function({
      required String id,
      required String medId,
      required String userId,
      required String times,
      required String daysOfWeek,
      Value<int> dosePerTime,
      Value<bool> isActive,
      required DateTime updatedAt,
      Value<bool> isDeleted,
      Value<String?> serverId,
      Value<int> rowid,
    });
typedef $$SchedulesTableUpdateCompanionBuilder =
    SchedulesCompanion Function({
      Value<String> id,
      Value<String> medId,
      Value<String> userId,
      Value<String> times,
      Value<String> daysOfWeek,
      Value<int> dosePerTime,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
      Value<String?> serverId,
      Value<int> rowid,
    });

class $$SchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medId => $composableBuilder(
    column: $table.medId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get times => $composableBuilder(
    column: $table.times,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dosePerTime => $composableBuilder(
    column: $table.dosePerTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medId => $composableBuilder(
    column: $table.medId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get times => $composableBuilder(
    column: $table.times,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dosePerTime => $composableBuilder(
    column: $table.dosePerTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchedulesTable> {
  $$SchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medId =>
      $composableBuilder(column: $table.medId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get times =>
      $composableBuilder(column: $table.times, builder: (column) => column);

  GeneratedColumn<String> get daysOfWeek => $composableBuilder(
    column: $table.daysOfWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dosePerTime => $composableBuilder(
    column: $table.dosePerTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);
}

class $$SchedulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchedulesTable,
          ScheduleRecord,
          $$SchedulesTableFilterComposer,
          $$SchedulesTableOrderingComposer,
          $$SchedulesTableAnnotationComposer,
          $$SchedulesTableCreateCompanionBuilder,
          $$SchedulesTableUpdateCompanionBuilder,
          (
            ScheduleRecord,
            BaseReferences<_$AppDatabase, $SchedulesTable, ScheduleRecord>,
          ),
          ScheduleRecord,
          PrefetchHooks Function()
        > {
  $$SchedulesTableTableManager(_$AppDatabase db, $SchedulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchedulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchedulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> times = const Value.absent(),
                Value<String> daysOfWeek = const Value.absent(),
                Value<int> dosePerTime = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchedulesCompanion(
                id: id,
                medId: medId,
                userId: userId,
                times: times,
                daysOfWeek: daysOfWeek,
                dosePerTime: dosePerTime,
                isActive: isActive,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                serverId: serverId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medId,
                required String userId,
                required String times,
                required String daysOfWeek,
                Value<int> dosePerTime = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SchedulesCompanion.insert(
                id: id,
                medId: medId,
                userId: userId,
                times: times,
                daysOfWeek: daysOfWeek,
                dosePerTime: dosePerTime,
                isActive: isActive,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
                serverId: serverId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SchedulesTable, ScheduleRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SchedulesTable,
                    ScheduleRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchedulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchedulesTable,
      ScheduleRecord,
      $$SchedulesTableFilterComposer,
      $$SchedulesTableOrderingComposer,
      $$SchedulesTableAnnotationComposer,
      $$SchedulesTableCreateCompanionBuilder,
      $$SchedulesTableUpdateCompanionBuilder,
      (
        ScheduleRecord,
        BaseReferences<_$AppDatabase, $SchedulesTable, ScheduleRecord>,
      ),
      ScheduleRecord,
      PrefetchHooks Function()
    >;
typedef $$IntakeLogsTableCreateCompanionBuilder =
    IntakeLogsCompanion Function({
      required String id,
      required String medId,
      required String userId,
      required DateTime scheduledAt,
      Value<DateTime?> actedAt,
      required String status,
      required int dose,
      required String idempotencyKey,
      required DateTime createdAt,
      Value<String?> serverId,
      Value<int> rowid,
    });
typedef $$IntakeLogsTableUpdateCompanionBuilder =
    IntakeLogsCompanion Function({
      Value<String> id,
      Value<String> medId,
      Value<String> userId,
      Value<DateTime> scheduledAt,
      Value<DateTime?> actedAt,
      Value<String> status,
      Value<int> dose,
      Value<String> idempotencyKey,
      Value<DateTime> createdAt,
      Value<String?> serverId,
      Value<int> rowid,
    });

class $$IntakeLogsTableFilterComposer
    extends Composer<_$AppDatabase, $IntakeLogsTable> {
  $$IntakeLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medId => $composableBuilder(
    column: $table.medId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actedAt => $composableBuilder(
    column: $table.actedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IntakeLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $IntakeLogsTable> {
  $$IntakeLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medId => $composableBuilder(
    column: $table.medId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actedAt => $composableBuilder(
    column: $table.actedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dose => $composableBuilder(
    column: $table.dose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IntakeLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IntakeLogsTable> {
  $$IntakeLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get medId =>
      $composableBuilder(column: $table.medId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledAt => $composableBuilder(
    column: $table.scheduledAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actedAt =>
      $composableBuilder(column: $table.actedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<String> get idempotencyKey => $composableBuilder(
    column: $table.idempotencyKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);
}

class $$IntakeLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IntakeLogsTable,
          IntakeLogRecord,
          $$IntakeLogsTableFilterComposer,
          $$IntakeLogsTableOrderingComposer,
          $$IntakeLogsTableAnnotationComposer,
          $$IntakeLogsTableCreateCompanionBuilder,
          $$IntakeLogsTableUpdateCompanionBuilder,
          (
            IntakeLogRecord,
            BaseReferences<_$AppDatabase, $IntakeLogsTable, IntakeLogRecord>,
          ),
          IntakeLogRecord,
          PrefetchHooks Function()
        > {
  $$IntakeLogsTableTableManager(_$AppDatabase db, $IntakeLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IntakeLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IntakeLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IntakeLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> medId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<DateTime> scheduledAt = const Value.absent(),
                Value<DateTime?> actedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> dose = const Value.absent(),
                Value<String> idempotencyKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IntakeLogsCompanion(
                id: id,
                medId: medId,
                userId: userId,
                scheduledAt: scheduledAt,
                actedAt: actedAt,
                status: status,
                dose: dose,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                serverId: serverId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String medId,
                required String userId,
                required DateTime scheduledAt,
                Value<DateTime?> actedAt = const Value.absent(),
                required String status,
                required int dose,
                required String idempotencyKey,
                required DateTime createdAt,
                Value<String?> serverId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IntakeLogsCompanion.insert(
                id: id,
                medId: medId,
                userId: userId,
                scheduledAt: scheduledAt,
                actedAt: actedAt,
                status: status,
                dose: dose,
                idempotencyKey: idempotencyKey,
                createdAt: createdAt,
                serverId: serverId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IntakeLogsTable, IntakeLogRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $IntakeLogsTable,
                    IntakeLogRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$IntakeLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IntakeLogsTable,
      IntakeLogRecord,
      $$IntakeLogsTableFilterComposer,
      $$IntakeLogsTableOrderingComposer,
      $$IntakeLogsTableAnnotationComposer,
      $$IntakeLogsTableCreateCompanionBuilder,
      $$IntakeLogsTableUpdateCompanionBuilder,
      (
        IntakeLogRecord,
        BaseReferences<_$AppDatabase, $IntakeLogsTable, IntakeLogRecord>,
      ),
      IntakeLogRecord,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String operation,
      required String payload,
      Value<int> retryCount,
      required String status,
      Value<String?> errorMessage,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<String> payload,
      Value<int> retryCount,
      Value<String> status,
      Value<String?> errorMessage,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueRecord,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueRecord,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueRecord>,
          ),
          SyncQueueRecord,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                retryCount: retryCount,
                status: status,
                errorMessage: errorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String operation,
                required String payload,
                Value<int> retryCount = const Value.absent(),
                required String status,
                Value<String?> errorMessage = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                retryCount: retryCount,
                status: status,
                errorMessage: errorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncQueueTable, SyncQueueRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SyncQueueTable,
                    SyncQueueRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueRecord,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueRecord,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueRecord>,
      ),
      SyncQueueRecord,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      required String userId,
      Value<bool> remindersEnabled,
      Value<bool> lowStockAlertsEnabled,
      Value<String?> lastSyncTime,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<String> userId,
      Value<bool> remindersEnabled,
      Value<bool> lowStockAlertsEnabled,
      Value<String?> lastSyncTime,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get lowStockAlertsEnabled => $composableBuilder(
    column: $table.lowStockAlertsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get lowStockAlertsEnabled => $composableBuilder(
    column: $table.lowStockAlertsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get remindersEnabled => $composableBuilder(
    column: $table.remindersEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get lowStockAlertsEnabled => $composableBuilder(
    column: $table.lowStockAlertsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSyncTime => $composableBuilder(
    column: $table.lastSyncTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTable,
          UserSettingsRecord,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (
            UserSettingsRecord,
            BaseReferences<
              _$AppDatabase,
              $UserSettingsTable,
              UserSettingsRecord
            >,
          ),
          UserSettingsRecord,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<bool> remindersEnabled = const Value.absent(),
                Value<bool> lowStockAlertsEnabled = const Value.absent(),
                Value<String?> lastSyncTime = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion(
                userId: userId,
                remindersEnabled: remindersEnabled,
                lowStockAlertsEnabled: lowStockAlertsEnabled,
                lastSyncTime: lastSyncTime,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<bool> remindersEnabled = const Value.absent(),
                Value<bool> lowStockAlertsEnabled = const Value.absent(),
                Value<String?> lastSyncTime = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                userId: userId,
                remindersEnabled: remindersEnabled,
                lowStockAlertsEnabled: lowStockAlertsEnabled,
                lastSyncTime: lastSyncTime,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserSettingsTable, UserSettingsRecord>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserSettingsTable,
                    UserSettingsRecord
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTable,
      UserSettingsRecord,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (
        UserSettingsRecord,
        BaseReferences<_$AppDatabase, $UserSettingsTable, UserSettingsRecord>,
      ),
      UserSettingsRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MedicationsTableTableManager get medications =>
      $$MedicationsTableTableManager(_db, _db.medications);
  $$SchedulesTableTableManager get schedules =>
      $$SchedulesTableTableManager(_db, _db.schedules);
  $$IntakeLogsTableTableManager get intakeLogs =>
      $$IntakeLogsTableTableManager(_db, _db.intakeLogs);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
}
