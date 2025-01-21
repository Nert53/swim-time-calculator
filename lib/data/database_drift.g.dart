// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_drift.dart';

// ignore_for_file: type=lint
class $SwimRecordItemsTable extends SwimRecordItems
    with TableInfo<$SwimRecordItemsTable, SwimRecordItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SwimRecordItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _originalTimeMeta =
      const VerificationMeta('originalTime');
  @override
  late final GeneratedColumn<double> originalTime = GeneratedColumn<double>(
      'original_time', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _originalStrokeRateMeta =
      const VerificationMeta('originalStrokeRate');
  @override
  late final GeneratedColumn<double> originalStrokeRate =
      GeneratedColumn<double>('original_stroke_rate', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sectionLengthMeta =
      const VerificationMeta('sectionLength');
  @override
  late final GeneratedColumn<double> sectionLength = GeneratedColumn<double>(
      'section_length', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _newTimeMeta =
      const VerificationMeta('newTime');
  @override
  late final GeneratedColumn<double> newTime = GeneratedColumn<double>(
      'new_time', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _newStrokeRateMeta =
      const VerificationMeta('newStrokeRate');
  @override
  late final GeneratedColumn<double> newStrokeRate = GeneratedColumn<double>(
      'new_stroke_rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _newStrokeLengthMeta =
      const VerificationMeta('newStrokeLength');
  @override
  late final GeneratedColumn<double> newStrokeLength = GeneratedColumn<double>(
      'new_stroke_length', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateCreatedMeta =
      const VerificationMeta('dateCreated');
  @override
  late final GeneratedColumn<DateTime> dateCreated = GeneratedColumn<DateTime>(
      'date_created', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        originalTime,
        originalStrokeRate,
        sectionLength,
        newTime,
        newStrokeRate,
        newStrokeLength,
        note,
        dateCreated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'swim_record_items';
  @override
  VerificationContext validateIntegrity(Insertable<SwimRecordItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('original_time')) {
      context.handle(
          _originalTimeMeta,
          originalTime.isAcceptableOrUnknown(
              data['original_time']!, _originalTimeMeta));
    } else if (isInserting) {
      context.missing(_originalTimeMeta);
    }
    if (data.containsKey('original_stroke_rate')) {
      context.handle(
          _originalStrokeRateMeta,
          originalStrokeRate.isAcceptableOrUnknown(
              data['original_stroke_rate']!, _originalStrokeRateMeta));
    } else if (isInserting) {
      context.missing(_originalStrokeRateMeta);
    }
    if (data.containsKey('section_length')) {
      context.handle(
          _sectionLengthMeta,
          sectionLength.isAcceptableOrUnknown(
              data['section_length']!, _sectionLengthMeta));
    } else if (isInserting) {
      context.missing(_sectionLengthMeta);
    }
    if (data.containsKey('new_time')) {
      context.handle(_newTimeMeta,
          newTime.isAcceptableOrUnknown(data['new_time']!, _newTimeMeta));
    } else if (isInserting) {
      context.missing(_newTimeMeta);
    }
    if (data.containsKey('new_stroke_rate')) {
      context.handle(
          _newStrokeRateMeta,
          newStrokeRate.isAcceptableOrUnknown(
              data['new_stroke_rate']!, _newStrokeRateMeta));
    } else if (isInserting) {
      context.missing(_newStrokeRateMeta);
    }
    if (data.containsKey('new_stroke_length')) {
      context.handle(
          _newStrokeLengthMeta,
          newStrokeLength.isAcceptableOrUnknown(
              data['new_stroke_length']!, _newStrokeLengthMeta));
    } else if (isInserting) {
      context.missing(_newStrokeLengthMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('date_created')) {
      context.handle(
          _dateCreatedMeta,
          dateCreated.isAcceptableOrUnknown(
              data['date_created']!, _dateCreatedMeta));
    } else if (isInserting) {
      context.missing(_dateCreatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SwimRecordItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SwimRecordItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      originalTime: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}original_time'])!,
      originalStrokeRate: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}original_stroke_rate'])!,
      sectionLength: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}section_length'])!,
      newTime: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}new_time'])!,
      newStrokeRate: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}new_stroke_rate'])!,
      newStrokeLength: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}new_stroke_length'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note'])!,
      dateCreated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_created'])!,
    );
  }

  @override
  $SwimRecordItemsTable createAlias(String alias) {
    return $SwimRecordItemsTable(attachedDatabase, alias);
  }
}

class SwimRecordItem extends DataClass implements Insertable<SwimRecordItem> {
  final int id;
  final double originalTime;
  final double originalStrokeRate;
  final double sectionLength;
  final double newTime;
  final double newStrokeRate;
  final double newStrokeLength;
  final String note;
  final DateTime dateCreated;
  const SwimRecordItem(
      {required this.id,
      required this.originalTime,
      required this.originalStrokeRate,
      required this.sectionLength,
      required this.newTime,
      required this.newStrokeRate,
      required this.newStrokeLength,
      required this.note,
      required this.dateCreated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['original_time'] = Variable<double>(originalTime);
    map['original_stroke_rate'] = Variable<double>(originalStrokeRate);
    map['section_length'] = Variable<double>(sectionLength);
    map['new_time'] = Variable<double>(newTime);
    map['new_stroke_rate'] = Variable<double>(newStrokeRate);
    map['new_stroke_length'] = Variable<double>(newStrokeLength);
    map['note'] = Variable<String>(note);
    map['date_created'] = Variable<DateTime>(dateCreated);
    return map;
  }

  SwimRecordItemsCompanion toCompanion(bool nullToAbsent) {
    return SwimRecordItemsCompanion(
      id: Value(id),
      originalTime: Value(originalTime),
      originalStrokeRate: Value(originalStrokeRate),
      sectionLength: Value(sectionLength),
      newTime: Value(newTime),
      newStrokeRate: Value(newStrokeRate),
      newStrokeLength: Value(newStrokeLength),
      note: Value(note),
      dateCreated: Value(dateCreated),
    );
  }

  factory SwimRecordItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SwimRecordItem(
      id: serializer.fromJson<int>(json['id']),
      originalTime: serializer.fromJson<double>(json['originalTime']),
      originalStrokeRate:
          serializer.fromJson<double>(json['originalStrokeRate']),
      sectionLength: serializer.fromJson<double>(json['sectionLength']),
      newTime: serializer.fromJson<double>(json['newTime']),
      newStrokeRate: serializer.fromJson<double>(json['newStrokeRate']),
      newStrokeLength: serializer.fromJson<double>(json['newStrokeLength']),
      note: serializer.fromJson<String>(json['note']),
      dateCreated: serializer.fromJson<DateTime>(json['dateCreated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'originalTime': serializer.toJson<double>(originalTime),
      'originalStrokeRate': serializer.toJson<double>(originalStrokeRate),
      'sectionLength': serializer.toJson<double>(sectionLength),
      'newTime': serializer.toJson<double>(newTime),
      'newStrokeRate': serializer.toJson<double>(newStrokeRate),
      'newStrokeLength': serializer.toJson<double>(newStrokeLength),
      'note': serializer.toJson<String>(note),
      'dateCreated': serializer.toJson<DateTime>(dateCreated),
    };
  }

  SwimRecordItem copyWith(
          {int? id,
          double? originalTime,
          double? originalStrokeRate,
          double? sectionLength,
          double? newTime,
          double? newStrokeRate,
          double? newStrokeLength,
          String? note,
          DateTime? dateCreated}) =>
      SwimRecordItem(
        id: id ?? this.id,
        originalTime: originalTime ?? this.originalTime,
        originalStrokeRate: originalStrokeRate ?? this.originalStrokeRate,
        sectionLength: sectionLength ?? this.sectionLength,
        newTime: newTime ?? this.newTime,
        newStrokeRate: newStrokeRate ?? this.newStrokeRate,
        newStrokeLength: newStrokeLength ?? this.newStrokeLength,
        note: note ?? this.note,
        dateCreated: dateCreated ?? this.dateCreated,
      );
  SwimRecordItem copyWithCompanion(SwimRecordItemsCompanion data) {
    return SwimRecordItem(
      id: data.id.present ? data.id.value : this.id,
      originalTime: data.originalTime.present
          ? data.originalTime.value
          : this.originalTime,
      originalStrokeRate: data.originalStrokeRate.present
          ? data.originalStrokeRate.value
          : this.originalStrokeRate,
      sectionLength: data.sectionLength.present
          ? data.sectionLength.value
          : this.sectionLength,
      newTime: data.newTime.present ? data.newTime.value : this.newTime,
      newStrokeRate: data.newStrokeRate.present
          ? data.newStrokeRate.value
          : this.newStrokeRate,
      newStrokeLength: data.newStrokeLength.present
          ? data.newStrokeLength.value
          : this.newStrokeLength,
      note: data.note.present ? data.note.value : this.note,
      dateCreated:
          data.dateCreated.present ? data.dateCreated.value : this.dateCreated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SwimRecordItem(')
          ..write('id: $id, ')
          ..write('originalTime: $originalTime, ')
          ..write('originalStrokeRate: $originalStrokeRate, ')
          ..write('sectionLength: $sectionLength, ')
          ..write('newTime: $newTime, ')
          ..write('newStrokeRate: $newStrokeRate, ')
          ..write('newStrokeLength: $newStrokeLength, ')
          ..write('note: $note, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      originalTime,
      originalStrokeRate,
      sectionLength,
      newTime,
      newStrokeRate,
      newStrokeLength,
      note,
      dateCreated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SwimRecordItem &&
          other.id == this.id &&
          other.originalTime == this.originalTime &&
          other.originalStrokeRate == this.originalStrokeRate &&
          other.sectionLength == this.sectionLength &&
          other.newTime == this.newTime &&
          other.newStrokeRate == this.newStrokeRate &&
          other.newStrokeLength == this.newStrokeLength &&
          other.note == this.note &&
          other.dateCreated == this.dateCreated);
}

class SwimRecordItemsCompanion extends UpdateCompanion<SwimRecordItem> {
  final Value<int> id;
  final Value<double> originalTime;
  final Value<double> originalStrokeRate;
  final Value<double> sectionLength;
  final Value<double> newTime;
  final Value<double> newStrokeRate;
  final Value<double> newStrokeLength;
  final Value<String> note;
  final Value<DateTime> dateCreated;
  const SwimRecordItemsCompanion({
    this.id = const Value.absent(),
    this.originalTime = const Value.absent(),
    this.originalStrokeRate = const Value.absent(),
    this.sectionLength = const Value.absent(),
    this.newTime = const Value.absent(),
    this.newStrokeRate = const Value.absent(),
    this.newStrokeLength = const Value.absent(),
    this.note = const Value.absent(),
    this.dateCreated = const Value.absent(),
  });
  SwimRecordItemsCompanion.insert({
    this.id = const Value.absent(),
    required double originalTime,
    required double originalStrokeRate,
    required double sectionLength,
    required double newTime,
    required double newStrokeRate,
    required double newStrokeLength,
    required String note,
    required DateTime dateCreated,
  })  : originalTime = Value(originalTime),
        originalStrokeRate = Value(originalStrokeRate),
        sectionLength = Value(sectionLength),
        newTime = Value(newTime),
        newStrokeRate = Value(newStrokeRate),
        newStrokeLength = Value(newStrokeLength),
        note = Value(note),
        dateCreated = Value(dateCreated);
  static Insertable<SwimRecordItem> custom({
    Expression<int>? id,
    Expression<double>? originalTime,
    Expression<double>? originalStrokeRate,
    Expression<double>? sectionLength,
    Expression<double>? newTime,
    Expression<double>? newStrokeRate,
    Expression<double>? newStrokeLength,
    Expression<String>? note,
    Expression<DateTime>? dateCreated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (originalTime != null) 'original_time': originalTime,
      if (originalStrokeRate != null)
        'original_stroke_rate': originalStrokeRate,
      if (sectionLength != null) 'section_length': sectionLength,
      if (newTime != null) 'new_time': newTime,
      if (newStrokeRate != null) 'new_stroke_rate': newStrokeRate,
      if (newStrokeLength != null) 'new_stroke_length': newStrokeLength,
      if (note != null) 'note': note,
      if (dateCreated != null) 'date_created': dateCreated,
    });
  }

  SwimRecordItemsCompanion copyWith(
      {Value<int>? id,
      Value<double>? originalTime,
      Value<double>? originalStrokeRate,
      Value<double>? sectionLength,
      Value<double>? newTime,
      Value<double>? newStrokeRate,
      Value<double>? newStrokeLength,
      Value<String>? note,
      Value<DateTime>? dateCreated}) {
    return SwimRecordItemsCompanion(
      id: id ?? this.id,
      originalTime: originalTime ?? this.originalTime,
      originalStrokeRate: originalStrokeRate ?? this.originalStrokeRate,
      sectionLength: sectionLength ?? this.sectionLength,
      newTime: newTime ?? this.newTime,
      newStrokeRate: newStrokeRate ?? this.newStrokeRate,
      newStrokeLength: newStrokeLength ?? this.newStrokeLength,
      note: note ?? this.note,
      dateCreated: dateCreated ?? this.dateCreated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (originalTime.present) {
      map['original_time'] = Variable<double>(originalTime.value);
    }
    if (originalStrokeRate.present) {
      map['original_stroke_rate'] = Variable<double>(originalStrokeRate.value);
    }
    if (sectionLength.present) {
      map['section_length'] = Variable<double>(sectionLength.value);
    }
    if (newTime.present) {
      map['new_time'] = Variable<double>(newTime.value);
    }
    if (newStrokeRate.present) {
      map['new_stroke_rate'] = Variable<double>(newStrokeRate.value);
    }
    if (newStrokeLength.present) {
      map['new_stroke_length'] = Variable<double>(newStrokeLength.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (dateCreated.present) {
      map['date_created'] = Variable<DateTime>(dateCreated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SwimRecordItemsCompanion(')
          ..write('id: $id, ')
          ..write('originalTime: $originalTime, ')
          ..write('originalStrokeRate: $originalStrokeRate, ')
          ..write('sectionLength: $sectionLength, ')
          ..write('newTime: $newTime, ')
          ..write('newStrokeRate: $newStrokeRate, ')
          ..write('newStrokeLength: $newStrokeLength, ')
          ..write('note: $note, ')
          ..write('dateCreated: $dateCreated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SwimRecordItemsTable swimRecordItems =
      $SwimRecordItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [swimRecordItems];
}

typedef $$SwimRecordItemsTableCreateCompanionBuilder = SwimRecordItemsCompanion
    Function({
  Value<int> id,
  required double originalTime,
  required double originalStrokeRate,
  required double sectionLength,
  required double newTime,
  required double newStrokeRate,
  required double newStrokeLength,
  required String note,
  required DateTime dateCreated,
});
typedef $$SwimRecordItemsTableUpdateCompanionBuilder = SwimRecordItemsCompanion
    Function({
  Value<int> id,
  Value<double> originalTime,
  Value<double> originalStrokeRate,
  Value<double> sectionLength,
  Value<double> newTime,
  Value<double> newStrokeRate,
  Value<double> newStrokeLength,
  Value<String> note,
  Value<DateTime> dateCreated,
});

class $$SwimRecordItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SwimRecordItemsTable> {
  $$SwimRecordItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get originalTime => $composableBuilder(
      column: $table.originalTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get originalStrokeRate => $composableBuilder(
      column: $table.originalStrokeRate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sectionLength => $composableBuilder(
      column: $table.sectionLength, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get newTime => $composableBuilder(
      column: $table.newTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get newStrokeRate => $composableBuilder(
      column: $table.newStrokeRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get newStrokeLength => $composableBuilder(
      column: $table.newStrokeLength,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateCreated => $composableBuilder(
      column: $table.dateCreated, builder: (column) => ColumnFilters(column));
}

class $$SwimRecordItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SwimRecordItemsTable> {
  $$SwimRecordItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get originalTime => $composableBuilder(
      column: $table.originalTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get originalStrokeRate => $composableBuilder(
      column: $table.originalStrokeRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sectionLength => $composableBuilder(
      column: $table.sectionLength,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get newTime => $composableBuilder(
      column: $table.newTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get newStrokeRate => $composableBuilder(
      column: $table.newStrokeRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get newStrokeLength => $composableBuilder(
      column: $table.newStrokeLength,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateCreated => $composableBuilder(
      column: $table.dateCreated, builder: (column) => ColumnOrderings(column));
}

class $$SwimRecordItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SwimRecordItemsTable> {
  $$SwimRecordItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get originalTime => $composableBuilder(
      column: $table.originalTime, builder: (column) => column);

  GeneratedColumn<double> get originalStrokeRate => $composableBuilder(
      column: $table.originalStrokeRate, builder: (column) => column);

  GeneratedColumn<double> get sectionLength => $composableBuilder(
      column: $table.sectionLength, builder: (column) => column);

  GeneratedColumn<double> get newTime =>
      $composableBuilder(column: $table.newTime, builder: (column) => column);

  GeneratedColumn<double> get newStrokeRate => $composableBuilder(
      column: $table.newStrokeRate, builder: (column) => column);

  GeneratedColumn<double> get newStrokeLength => $composableBuilder(
      column: $table.newStrokeLength, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get dateCreated => $composableBuilder(
      column: $table.dateCreated, builder: (column) => column);
}

class $$SwimRecordItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SwimRecordItemsTable,
    SwimRecordItem,
    $$SwimRecordItemsTableFilterComposer,
    $$SwimRecordItemsTableOrderingComposer,
    $$SwimRecordItemsTableAnnotationComposer,
    $$SwimRecordItemsTableCreateCompanionBuilder,
    $$SwimRecordItemsTableUpdateCompanionBuilder,
    (
      SwimRecordItem,
      BaseReferences<_$AppDatabase, $SwimRecordItemsTable, SwimRecordItem>
    ),
    SwimRecordItem,
    PrefetchHooks Function()> {
  $$SwimRecordItemsTableTableManager(
      _$AppDatabase db, $SwimRecordItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SwimRecordItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SwimRecordItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SwimRecordItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<double> originalTime = const Value.absent(),
            Value<double> originalStrokeRate = const Value.absent(),
            Value<double> sectionLength = const Value.absent(),
            Value<double> newTime = const Value.absent(),
            Value<double> newStrokeRate = const Value.absent(),
            Value<double> newStrokeLength = const Value.absent(),
            Value<String> note = const Value.absent(),
            Value<DateTime> dateCreated = const Value.absent(),
          }) =>
              SwimRecordItemsCompanion(
            id: id,
            originalTime: originalTime,
            originalStrokeRate: originalStrokeRate,
            sectionLength: sectionLength,
            newTime: newTime,
            newStrokeRate: newStrokeRate,
            newStrokeLength: newStrokeLength,
            note: note,
            dateCreated: dateCreated,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required double originalTime,
            required double originalStrokeRate,
            required double sectionLength,
            required double newTime,
            required double newStrokeRate,
            required double newStrokeLength,
            required String note,
            required DateTime dateCreated,
          }) =>
              SwimRecordItemsCompanion.insert(
            id: id,
            originalTime: originalTime,
            originalStrokeRate: originalStrokeRate,
            sectionLength: sectionLength,
            newTime: newTime,
            newStrokeRate: newStrokeRate,
            newStrokeLength: newStrokeLength,
            note: note,
            dateCreated: dateCreated,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SwimRecordItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SwimRecordItemsTable,
    SwimRecordItem,
    $$SwimRecordItemsTableFilterComposer,
    $$SwimRecordItemsTableOrderingComposer,
    $$SwimRecordItemsTableAnnotationComposer,
    $$SwimRecordItemsTableCreateCompanionBuilder,
    $$SwimRecordItemsTableUpdateCompanionBuilder,
    (
      SwimRecordItem,
      BaseReferences<_$AppDatabase, $SwimRecordItemsTable, SwimRecordItem>
    ),
    SwimRecordItem,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SwimRecordItemsTableTableManager get swimRecordItems =>
      $$SwimRecordItemsTableTableManager(_db, _db.swimRecordItems);
}
