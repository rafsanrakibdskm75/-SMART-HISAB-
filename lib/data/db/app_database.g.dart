// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PersonsTable extends Persons with TableInfo<$PersonsTable, Person> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localVersionMeta =
      const VerificationMeta('localVersion');
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
      'local_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendingUpload'));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<int> serverUpdatedAt = GeneratedColumn<int>(
      'server_updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
      'mobile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoPathMeta =
      const VerificationMeta('photoPath');
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
      'photo_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _personTypeMeta =
      const VerificationMeta('personType');
  @override
  late final GeneratedColumn<String> personType = GeneratedColumn<String>(
      'person_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('customer'));
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        createdAt,
        updatedAt,
        deviceId,
        localVersion,
        syncStatus,
        isDeleted,
        serverUpdatedAt,
        id,
        name,
        mobile,
        photoPath,
        address,
        personType
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'persons';
  @override
  VerificationContext validateIntegrity(Insertable<Person> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('local_version')) {
      context.handle(
          _localVersionMeta,
          localVersion.isAcceptableOrUnknown(
              data['local_version']!, _localVersionMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('mobile')) {
      context.handle(_mobileMeta,
          mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta));
    }
    if (data.containsKey('photo_path')) {
      context.handle(_photoPathMeta,
          photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('person_type')) {
      context.handle(
          _personTypeMeta,
          personType.isAcceptableOrUnknown(
              data['person_type']!, _personTypeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Person(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      localVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_version'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      serverUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_updated_at']),
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      mobile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mobile']),
      photoPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_path']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      personType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_type'])!,
    );
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(attachedDatabase, alias);
  }
}

class Person extends DataClass implements Insertable<Person> {
  final String userId;
  final int createdAt;
  final int updatedAt;
  final String? deviceId;
  final int localVersion;
  final String syncStatus;
  final bool isDeleted;
  final int? serverUpdatedAt;
  final String id;
  final String name;
  final String? mobile;
  final String? photoPath;
  final String? address;
  final String personType;
  const Person(
      {required this.userId,
      required this.createdAt,
      required this.updatedAt,
      this.deviceId,
      required this.localVersion,
      required this.syncStatus,
      required this.isDeleted,
      this.serverUpdatedAt,
      required this.id,
      required this.name,
      this.mobile,
      this.photoPath,
      this.address,
      required this.personType});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['local_version'] = Variable<int>(localVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    map['person_type'] = Variable<String>(personType);
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      userId: Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      localVersion: Value(localVersion),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      name: Value(name),
      mobile:
          mobile == null && nullToAbsent ? const Value.absent() : Value(mobile),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      personType: Value(personType),
    );
  }

  factory Person.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Person(
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      serverUpdatedAt: serializer.fromJson<int?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      mobile: serializer.fromJson<String?>(json['mobile']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      address: serializer.fromJson<String?>(json['address']),
      personType: serializer.fromJson<String>(json['personType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'localVersion': serializer.toJson<int>(localVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'serverUpdatedAt': serializer.toJson<int?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'mobile': serializer.toJson<String?>(mobile),
      'photoPath': serializer.toJson<String?>(photoPath),
      'address': serializer.toJson<String?>(address),
      'personType': serializer.toJson<String>(personType),
    };
  }

  Person copyWith(
          {String? userId,
          int? createdAt,
          int? updatedAt,
          Value<String?> deviceId = const Value.absent(),
          int? localVersion,
          String? syncStatus,
          bool? isDeleted,
          Value<int?> serverUpdatedAt = const Value.absent(),
          String? id,
          String? name,
          Value<String?> mobile = const Value.absent(),
          Value<String?> photoPath = const Value.absent(),
          Value<String?> address = const Value.absent(),
          String? personType}) =>
      Person(
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        localVersion: localVersion ?? this.localVersion,
        syncStatus: syncStatus ?? this.syncStatus,
        isDeleted: isDeleted ?? this.isDeleted,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        id: id ?? this.id,
        name: name ?? this.name,
        mobile: mobile.present ? mobile.value : this.mobile,
        photoPath: photoPath.present ? photoPath.value : this.photoPath,
        address: address.present ? address.value : this.address,
        personType: personType ?? this.personType,
      );
  Person copyWithCompanion(PersonsCompanion data) {
    return Person(
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      address: data.address.present ? data.address.value : this.address,
      personType:
          data.personType.present ? data.personType.value : this.personType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mobile: $mobile, ')
          ..write('photoPath: $photoPath, ')
          ..write('address: $address, ')
          ..write('personType: $personType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      createdAt,
      updatedAt,
      deviceId,
      localVersion,
      syncStatus,
      isDeleted,
      serverUpdatedAt,
      id,
      name,
      mobile,
      photoPath,
      address,
      personType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.localVersion == this.localVersion &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.mobile == this.mobile &&
          other.photoPath == this.photoPath &&
          other.address == this.address &&
          other.personType == this.personType);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<String> userId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String?> deviceId;
  final Value<int> localVersion;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<int?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> name;
  final Value<String?> mobile;
  final Value<String?> photoPath;
  final Value<String?> address;
  final Value<String> personType;
  final Value<int> rowid;
  const PersonsCompanion({
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.mobile = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.address = const Value.absent(),
    this.personType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PersonsCompanion.insert({
    required String userId,
    required int createdAt,
    required int updatedAt,
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String name,
    this.mobile = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.address = const Value.absent(),
    this.personType = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        id = Value(id),
        name = Value(name);
  static Insertable<Person> custom({
    Expression<String>? userId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? localVersion,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<int>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? mobile,
    Expression<String>? photoPath,
    Expression<String>? address,
    Expression<String>? personType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (localVersion != null) 'local_version': localVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (mobile != null) 'mobile': mobile,
      if (photoPath != null) 'photo_path': photoPath,
      if (address != null) 'address': address,
      if (personType != null) 'person_type': personType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PersonsCompanion copyWith(
      {Value<String>? userId,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String?>? deviceId,
      Value<int>? localVersion,
      Value<String>? syncStatus,
      Value<bool>? isDeleted,
      Value<int?>? serverUpdatedAt,
      Value<String>? id,
      Value<String>? name,
      Value<String?>? mobile,
      Value<String?>? photoPath,
      Value<String?>? address,
      Value<String>? personType,
      Value<int>? rowid}) {
    return PersonsCompanion(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      localVersion: localVersion ?? this.localVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      photoPath: photoPath ?? this.photoPath,
      address: address ?? this.address,
      personType: personType ?? this.personType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (personType.present) {
      map['person_type'] = Variable<String>(personType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('mobile: $mobile, ')
          ..write('photoPath: $photoPath, ')
          ..write('address: $address, ')
          ..write('personType: $personType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectionSchedulesTable extends CollectionSchedules
    with TableInfo<$CollectionSchedulesTable, CollectionSchedule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionSchedulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localVersionMeta =
      const VerificationMeta('localVersion');
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
      'local_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendingUpload'));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<int> serverUpdatedAt = GeneratedColumn<int>(
      'server_updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES persons (id)'));
  static const VerificationMeta _expectedPoishaMeta =
      const VerificationMeta('expectedPoisha');
  @override
  late final GeneratedColumn<int> expectedPoisha = GeneratedColumn<int>(
      'expected_poisha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _scheduleTypeMeta =
      const VerificationMeta('scheduleType');
  @override
  late final GeneratedColumn<String> scheduleType = GeneratedColumn<String>(
      'schedule_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
      'start_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
      'end_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weekdaysMeta =
      const VerificationMeta('weekdays');
  @override
  late final GeneratedColumn<String> weekdays = GeneratedColumn<String>(
      'weekdays', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dayOfMonthMeta =
      const VerificationMeta('dayOfMonth');
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
      'day_of_month', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _graceDaysMeta =
      const VerificationMeta('graceDays');
  @override
  late final GeneratedColumn<int> graceDays = GeneratedColumn<int>(
      'grace_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _allowAdvanceMeta =
      const VerificationMeta('allowAdvance');
  @override
  late final GeneratedColumn<bool> allowAdvance = GeneratedColumn<bool>(
      'allow_advance', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("allow_advance" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _pausedMeta = const VerificationMeta('paused');
  @override
  late final GeneratedColumn<bool> paused = GeneratedColumn<bool>(
      'paused', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("paused" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _effectiveFromMeta =
      const VerificationMeta('effectiveFrom');
  @override
  late final GeneratedColumn<String> effectiveFrom = GeneratedColumn<String>(
      'effective_from', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        createdAt,
        updatedAt,
        deviceId,
        localVersion,
        syncStatus,
        isDeleted,
        serverUpdatedAt,
        id,
        personId,
        expectedPoisha,
        scheduleType,
        startDate,
        endDate,
        weekdays,
        dayOfMonth,
        graceDays,
        allowAdvance,
        paused,
        effectiveFrom
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collection_schedules';
  @override
  VerificationContext validateIntegrity(Insertable<CollectionSchedule> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('local_version')) {
      context.handle(
          _localVersionMeta,
          localVersion.isAcceptableOrUnknown(
              data['local_version']!, _localVersionMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('expected_poisha')) {
      context.handle(
          _expectedPoishaMeta,
          expectedPoisha.isAcceptableOrUnknown(
              data['expected_poisha']!, _expectedPoishaMeta));
    } else if (isInserting) {
      context.missing(_expectedPoishaMeta);
    }
    if (data.containsKey('schedule_type')) {
      context.handle(
          _scheduleTypeMeta,
          scheduleType.isAcceptableOrUnknown(
              data['schedule_type']!, _scheduleTypeMeta));
    } else if (isInserting) {
      context.missing(_scheduleTypeMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('weekdays')) {
      context.handle(_weekdaysMeta,
          weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta));
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
          _dayOfMonthMeta,
          dayOfMonth.isAcceptableOrUnknown(
              data['day_of_month']!, _dayOfMonthMeta));
    }
    if (data.containsKey('grace_days')) {
      context.handle(_graceDaysMeta,
          graceDays.isAcceptableOrUnknown(data['grace_days']!, _graceDaysMeta));
    }
    if (data.containsKey('allow_advance')) {
      context.handle(
          _allowAdvanceMeta,
          allowAdvance.isAcceptableOrUnknown(
              data['allow_advance']!, _allowAdvanceMeta));
    }
    if (data.containsKey('paused')) {
      context.handle(_pausedMeta,
          paused.isAcceptableOrUnknown(data['paused']!, _pausedMeta));
    }
    if (data.containsKey('effective_from')) {
      context.handle(
          _effectiveFromMeta,
          effectiveFrom.isAcceptableOrUnknown(
              data['effective_from']!, _effectiveFromMeta));
    } else if (isInserting) {
      context.missing(_effectiveFromMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CollectionSchedule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionSchedule(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      localVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_version'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      serverUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_updated_at']),
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
      expectedPoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expected_poisha'])!,
      scheduleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_type'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_date']),
      weekdays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}weekdays']),
      dayOfMonth: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_of_month']),
      graceDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grace_days'])!,
      allowAdvance: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}allow_advance'])!,
      paused: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}paused'])!,
      effectiveFrom: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}effective_from'])!,
    );
  }

  @override
  $CollectionSchedulesTable createAlias(String alias) {
    return $CollectionSchedulesTable(attachedDatabase, alias);
  }
}

class CollectionSchedule extends DataClass
    implements Insertable<CollectionSchedule> {
  final String userId;
  final int createdAt;
  final int updatedAt;
  final String? deviceId;
  final int localVersion;
  final String syncStatus;
  final bool isDeleted;
  final int? serverUpdatedAt;
  final String id;
  final String personId;
  final int expectedPoisha;
  final String scheduleType;
  final String startDate;
  final String? endDate;
  final String? weekdays;
  final int? dayOfMonth;
  final int graceDays;
  final bool allowAdvance;
  final bool paused;
  final String effectiveFrom;
  const CollectionSchedule(
      {required this.userId,
      required this.createdAt,
      required this.updatedAt,
      this.deviceId,
      required this.localVersion,
      required this.syncStatus,
      required this.isDeleted,
      this.serverUpdatedAt,
      required this.id,
      required this.personId,
      required this.expectedPoisha,
      required this.scheduleType,
      required this.startDate,
      this.endDate,
      this.weekdays,
      this.dayOfMonth,
      required this.graceDays,
      required this.allowAdvance,
      required this.paused,
      required this.effectiveFrom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['local_version'] = Variable<int>(localVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['person_id'] = Variable<String>(personId);
    map['expected_poisha'] = Variable<int>(expectedPoisha);
    map['schedule_type'] = Variable<String>(scheduleType);
    map['start_date'] = Variable<String>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    if (!nullToAbsent || weekdays != null) {
      map['weekdays'] = Variable<String>(weekdays);
    }
    if (!nullToAbsent || dayOfMonth != null) {
      map['day_of_month'] = Variable<int>(dayOfMonth);
    }
    map['grace_days'] = Variable<int>(graceDays);
    map['allow_advance'] = Variable<bool>(allowAdvance);
    map['paused'] = Variable<bool>(paused);
    map['effective_from'] = Variable<String>(effectiveFrom);
    return map;
  }

  CollectionSchedulesCompanion toCompanion(bool nullToAbsent) {
    return CollectionSchedulesCompanion(
      userId: Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      localVersion: Value(localVersion),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      personId: Value(personId),
      expectedPoisha: Value(expectedPoisha),
      scheduleType: Value(scheduleType),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      weekdays: weekdays == null && nullToAbsent
          ? const Value.absent()
          : Value(weekdays),
      dayOfMonth: dayOfMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(dayOfMonth),
      graceDays: Value(graceDays),
      allowAdvance: Value(allowAdvance),
      paused: Value(paused),
      effectiveFrom: Value(effectiveFrom),
    );
  }

  factory CollectionSchedule.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionSchedule(
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      serverUpdatedAt: serializer.fromJson<int?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      personId: serializer.fromJson<String>(json['personId']),
      expectedPoisha: serializer.fromJson<int>(json['expectedPoisha']),
      scheduleType: serializer.fromJson<String>(json['scheduleType']),
      startDate: serializer.fromJson<String>(json['startDate']),
      endDate: serializer.fromJson<String?>(json['endDate']),
      weekdays: serializer.fromJson<String?>(json['weekdays']),
      dayOfMonth: serializer.fromJson<int?>(json['dayOfMonth']),
      graceDays: serializer.fromJson<int>(json['graceDays']),
      allowAdvance: serializer.fromJson<bool>(json['allowAdvance']),
      paused: serializer.fromJson<bool>(json['paused']),
      effectiveFrom: serializer.fromJson<String>(json['effectiveFrom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'localVersion': serializer.toJson<int>(localVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'serverUpdatedAt': serializer.toJson<int?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'personId': serializer.toJson<String>(personId),
      'expectedPoisha': serializer.toJson<int>(expectedPoisha),
      'scheduleType': serializer.toJson<String>(scheduleType),
      'startDate': serializer.toJson<String>(startDate),
      'endDate': serializer.toJson<String?>(endDate),
      'weekdays': serializer.toJson<String?>(weekdays),
      'dayOfMonth': serializer.toJson<int?>(dayOfMonth),
      'graceDays': serializer.toJson<int>(graceDays),
      'allowAdvance': serializer.toJson<bool>(allowAdvance),
      'paused': serializer.toJson<bool>(paused),
      'effectiveFrom': serializer.toJson<String>(effectiveFrom),
    };
  }

  CollectionSchedule copyWith(
          {String? userId,
          int? createdAt,
          int? updatedAt,
          Value<String?> deviceId = const Value.absent(),
          int? localVersion,
          String? syncStatus,
          bool? isDeleted,
          Value<int?> serverUpdatedAt = const Value.absent(),
          String? id,
          String? personId,
          int? expectedPoisha,
          String? scheduleType,
          String? startDate,
          Value<String?> endDate = const Value.absent(),
          Value<String?> weekdays = const Value.absent(),
          Value<int?> dayOfMonth = const Value.absent(),
          int? graceDays,
          bool? allowAdvance,
          bool? paused,
          String? effectiveFrom}) =>
      CollectionSchedule(
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        localVersion: localVersion ?? this.localVersion,
        syncStatus: syncStatus ?? this.syncStatus,
        isDeleted: isDeleted ?? this.isDeleted,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        id: id ?? this.id,
        personId: personId ?? this.personId,
        expectedPoisha: expectedPoisha ?? this.expectedPoisha,
        scheduleType: scheduleType ?? this.scheduleType,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        weekdays: weekdays.present ? weekdays.value : this.weekdays,
        dayOfMonth: dayOfMonth.present ? dayOfMonth.value : this.dayOfMonth,
        graceDays: graceDays ?? this.graceDays,
        allowAdvance: allowAdvance ?? this.allowAdvance,
        paused: paused ?? this.paused,
        effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      );
  CollectionSchedule copyWithCompanion(CollectionSchedulesCompanion data) {
    return CollectionSchedule(
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      expectedPoisha: data.expectedPoisha.present
          ? data.expectedPoisha.value
          : this.expectedPoisha,
      scheduleType: data.scheduleType.present
          ? data.scheduleType.value
          : this.scheduleType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      dayOfMonth:
          data.dayOfMonth.present ? data.dayOfMonth.value : this.dayOfMonth,
      graceDays: data.graceDays.present ? data.graceDays.value : this.graceDays,
      allowAdvance: data.allowAdvance.present
          ? data.allowAdvance.value
          : this.allowAdvance,
      paused: data.paused.present ? data.paused.value : this.paused,
      effectiveFrom: data.effectiveFrom.present
          ? data.effectiveFrom.value
          : this.effectiveFrom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionSchedule(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('expectedPoisha: $expectedPoisha, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('weekdays: $weekdays, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('graceDays: $graceDays, ')
          ..write('allowAdvance: $allowAdvance, ')
          ..write('paused: $paused, ')
          ..write('effectiveFrom: $effectiveFrom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      createdAt,
      updatedAt,
      deviceId,
      localVersion,
      syncStatus,
      isDeleted,
      serverUpdatedAt,
      id,
      personId,
      expectedPoisha,
      scheduleType,
      startDate,
      endDate,
      weekdays,
      dayOfMonth,
      graceDays,
      allowAdvance,
      paused,
      effectiveFrom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionSchedule &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.localVersion == this.localVersion &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.expectedPoisha == this.expectedPoisha &&
          other.scheduleType == this.scheduleType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.weekdays == this.weekdays &&
          other.dayOfMonth == this.dayOfMonth &&
          other.graceDays == this.graceDays &&
          other.allowAdvance == this.allowAdvance &&
          other.paused == this.paused &&
          other.effectiveFrom == this.effectiveFrom);
}

class CollectionSchedulesCompanion extends UpdateCompanion<CollectionSchedule> {
  final Value<String> userId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String?> deviceId;
  final Value<int> localVersion;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<int?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> personId;
  final Value<int> expectedPoisha;
  final Value<String> scheduleType;
  final Value<String> startDate;
  final Value<String?> endDate;
  final Value<String?> weekdays;
  final Value<int?> dayOfMonth;
  final Value<int> graceDays;
  final Value<bool> allowAdvance;
  final Value<bool> paused;
  final Value<String> effectiveFrom;
  final Value<int> rowid;
  const CollectionSchedulesCompanion({
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.expectedPoisha = const Value.absent(),
    this.scheduleType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.graceDays = const Value.absent(),
    this.allowAdvance = const Value.absent(),
    this.paused = const Value.absent(),
    this.effectiveFrom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectionSchedulesCompanion.insert({
    required String userId,
    required int createdAt,
    required int updatedAt,
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String personId,
    required int expectedPoisha,
    required String scheduleType,
    required String startDate,
    this.endDate = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.graceDays = const Value.absent(),
    this.allowAdvance = const Value.absent(),
    this.paused = const Value.absent(),
    required String effectiveFrom,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        id = Value(id),
        personId = Value(personId),
        expectedPoisha = Value(expectedPoisha),
        scheduleType = Value(scheduleType),
        startDate = Value(startDate),
        effectiveFrom = Value(effectiveFrom);
  static Insertable<CollectionSchedule> custom({
    Expression<String>? userId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? localVersion,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<int>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? personId,
    Expression<int>? expectedPoisha,
    Expression<String>? scheduleType,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? weekdays,
    Expression<int>? dayOfMonth,
    Expression<int>? graceDays,
    Expression<bool>? allowAdvance,
    Expression<bool>? paused,
    Expression<String>? effectiveFrom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (localVersion != null) 'local_version': localVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (expectedPoisha != null) 'expected_poisha': expectedPoisha,
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (weekdays != null) 'weekdays': weekdays,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (graceDays != null) 'grace_days': graceDays,
      if (allowAdvance != null) 'allow_advance': allowAdvance,
      if (paused != null) 'paused': paused,
      if (effectiveFrom != null) 'effective_from': effectiveFrom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectionSchedulesCompanion copyWith(
      {Value<String>? userId,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String?>? deviceId,
      Value<int>? localVersion,
      Value<String>? syncStatus,
      Value<bool>? isDeleted,
      Value<int?>? serverUpdatedAt,
      Value<String>? id,
      Value<String>? personId,
      Value<int>? expectedPoisha,
      Value<String>? scheduleType,
      Value<String>? startDate,
      Value<String?>? endDate,
      Value<String?>? weekdays,
      Value<int?>? dayOfMonth,
      Value<int>? graceDays,
      Value<bool>? allowAdvance,
      Value<bool>? paused,
      Value<String>? effectiveFrom,
      Value<int>? rowid}) {
    return CollectionSchedulesCompanion(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      localVersion: localVersion ?? this.localVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      personId: personId ?? this.personId,
      expectedPoisha: expectedPoisha ?? this.expectedPoisha,
      scheduleType: scheduleType ?? this.scheduleType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      weekdays: weekdays ?? this.weekdays,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      graceDays: graceDays ?? this.graceDays,
      allowAdvance: allowAdvance ?? this.allowAdvance,
      paused: paused ?? this.paused,
      effectiveFrom: effectiveFrom ?? this.effectiveFrom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (expectedPoisha.present) {
      map['expected_poisha'] = Variable<int>(expectedPoisha.value);
    }
    if (scheduleType.present) {
      map['schedule_type'] = Variable<String>(scheduleType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<String>(weekdays.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (graceDays.present) {
      map['grace_days'] = Variable<int>(graceDays.value);
    }
    if (allowAdvance.present) {
      map['allow_advance'] = Variable<bool>(allowAdvance.value);
    }
    if (paused.present) {
      map['paused'] = Variable<bool>(paused.value);
    }
    if (effectiveFrom.present) {
      map['effective_from'] = Variable<String>(effectiveFrom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionSchedulesCompanion(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('expectedPoisha: $expectedPoisha, ')
          ..write('scheduleType: $scheduleType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('weekdays: $weekdays, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('graceDays: $graceDays, ')
          ..write('allowAdvance: $allowAdvance, ')
          ..write('paused: $paused, ')
          ..write('effectiveFrom: $effectiveFrom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollectionObligationsTable extends CollectionObligations
    with TableInfo<$CollectionObligationsTable, CollectionObligation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionObligationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localVersionMeta =
      const VerificationMeta('localVersion');
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
      'local_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendingUpload'));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<int> serverUpdatedAt = GeneratedColumn<int>(
      'server_updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES persons (id)'));
  static const VerificationMeta _scheduleIdMeta =
      const VerificationMeta('scheduleId');
  @override
  late final GeneratedColumn<String> scheduleId = GeneratedColumn<String>(
      'schedule_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expectedPoishaMeta =
      const VerificationMeta('expectedPoisha');
  @override
  late final GeneratedColumn<int> expectedPoisha = GeneratedColumn<int>(
      'expected_poisha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _paidPoishaMeta =
      const VerificationMeta('paidPoisha');
  @override
  late final GeneratedColumn<int> paidPoisha = GeneratedColumn<int>(
      'paid_poisha', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isHolidayMeta =
      const VerificationMeta('isHoliday');
  @override
  late final GeneratedColumn<bool> isHoliday = GeneratedColumn<bool>(
      'is_holiday', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_holiday" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastAllocationDateMeta =
      const VerificationMeta('lastAllocationDate');
  @override
  late final GeneratedColumn<String> lastAllocationDate =
      GeneratedColumn<String>('last_allocation_date', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        createdAt,
        updatedAt,
        deviceId,
        localVersion,
        syncStatus,
        isDeleted,
        serverUpdatedAt,
        id,
        personId,
        scheduleId,
        date,
        expectedPoisha,
        paidPoisha,
        isHoliday,
        lastAllocationDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collection_obligations';
  @override
  VerificationContext validateIntegrity(
      Insertable<CollectionObligation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('local_version')) {
      context.handle(
          _localVersionMeta,
          localVersion.isAcceptableOrUnknown(
              data['local_version']!, _localVersionMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('schedule_id')) {
      context.handle(
          _scheduleIdMeta,
          scheduleId.isAcceptableOrUnknown(
              data['schedule_id']!, _scheduleIdMeta));
    } else if (isInserting) {
      context.missing(_scheduleIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('expected_poisha')) {
      context.handle(
          _expectedPoishaMeta,
          expectedPoisha.isAcceptableOrUnknown(
              data['expected_poisha']!, _expectedPoishaMeta));
    } else if (isInserting) {
      context.missing(_expectedPoishaMeta);
    }
    if (data.containsKey('paid_poisha')) {
      context.handle(
          _paidPoishaMeta,
          paidPoisha.isAcceptableOrUnknown(
              data['paid_poisha']!, _paidPoishaMeta));
    }
    if (data.containsKey('is_holiday')) {
      context.handle(_isHolidayMeta,
          isHoliday.isAcceptableOrUnknown(data['is_holiday']!, _isHolidayMeta));
    }
    if (data.containsKey('last_allocation_date')) {
      context.handle(
          _lastAllocationDateMeta,
          lastAllocationDate.isAcceptableOrUnknown(
              data['last_allocation_date']!, _lastAllocationDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {personId, date},
      ];
  @override
  CollectionObligation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionObligation(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      localVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_version'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      serverUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_updated_at']),
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
      scheduleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}schedule_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      expectedPoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}expected_poisha'])!,
      paidPoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}paid_poisha'])!,
      isHoliday: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_holiday'])!,
      lastAllocationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_allocation_date']),
    );
  }

  @override
  $CollectionObligationsTable createAlias(String alias) {
    return $CollectionObligationsTable(attachedDatabase, alias);
  }
}

class CollectionObligation extends DataClass
    implements Insertable<CollectionObligation> {
  final String userId;
  final int createdAt;
  final int updatedAt;
  final String? deviceId;
  final int localVersion;
  final String syncStatus;
  final bool isDeleted;
  final int? serverUpdatedAt;
  final String id;
  final String personId;
  final String scheduleId;
  final String date;
  final int expectedPoisha;
  final int paidPoisha;
  final bool isHoliday;
  final String? lastAllocationDate;
  const CollectionObligation(
      {required this.userId,
      required this.createdAt,
      required this.updatedAt,
      this.deviceId,
      required this.localVersion,
      required this.syncStatus,
      required this.isDeleted,
      this.serverUpdatedAt,
      required this.id,
      required this.personId,
      required this.scheduleId,
      required this.date,
      required this.expectedPoisha,
      required this.paidPoisha,
      required this.isHoliday,
      this.lastAllocationDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['local_version'] = Variable<int>(localVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['person_id'] = Variable<String>(personId);
    map['schedule_id'] = Variable<String>(scheduleId);
    map['date'] = Variable<String>(date);
    map['expected_poisha'] = Variable<int>(expectedPoisha);
    map['paid_poisha'] = Variable<int>(paidPoisha);
    map['is_holiday'] = Variable<bool>(isHoliday);
    if (!nullToAbsent || lastAllocationDate != null) {
      map['last_allocation_date'] = Variable<String>(lastAllocationDate);
    }
    return map;
  }

  CollectionObligationsCompanion toCompanion(bool nullToAbsent) {
    return CollectionObligationsCompanion(
      userId: Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      localVersion: Value(localVersion),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      personId: Value(personId),
      scheduleId: Value(scheduleId),
      date: Value(date),
      expectedPoisha: Value(expectedPoisha),
      paidPoisha: Value(paidPoisha),
      isHoliday: Value(isHoliday),
      lastAllocationDate: lastAllocationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAllocationDate),
    );
  }

  factory CollectionObligation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionObligation(
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      serverUpdatedAt: serializer.fromJson<int?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      personId: serializer.fromJson<String>(json['personId']),
      scheduleId: serializer.fromJson<String>(json['scheduleId']),
      date: serializer.fromJson<String>(json['date']),
      expectedPoisha: serializer.fromJson<int>(json['expectedPoisha']),
      paidPoisha: serializer.fromJson<int>(json['paidPoisha']),
      isHoliday: serializer.fromJson<bool>(json['isHoliday']),
      lastAllocationDate:
          serializer.fromJson<String?>(json['lastAllocationDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'localVersion': serializer.toJson<int>(localVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'serverUpdatedAt': serializer.toJson<int?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'personId': serializer.toJson<String>(personId),
      'scheduleId': serializer.toJson<String>(scheduleId),
      'date': serializer.toJson<String>(date),
      'expectedPoisha': serializer.toJson<int>(expectedPoisha),
      'paidPoisha': serializer.toJson<int>(paidPoisha),
      'isHoliday': serializer.toJson<bool>(isHoliday),
      'lastAllocationDate': serializer.toJson<String?>(lastAllocationDate),
    };
  }

  CollectionObligation copyWith(
          {String? userId,
          int? createdAt,
          int? updatedAt,
          Value<String?> deviceId = const Value.absent(),
          int? localVersion,
          String? syncStatus,
          bool? isDeleted,
          Value<int?> serverUpdatedAt = const Value.absent(),
          String? id,
          String? personId,
          String? scheduleId,
          String? date,
          int? expectedPoisha,
          int? paidPoisha,
          bool? isHoliday,
          Value<String?> lastAllocationDate = const Value.absent()}) =>
      CollectionObligation(
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        localVersion: localVersion ?? this.localVersion,
        syncStatus: syncStatus ?? this.syncStatus,
        isDeleted: isDeleted ?? this.isDeleted,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        id: id ?? this.id,
        personId: personId ?? this.personId,
        scheduleId: scheduleId ?? this.scheduleId,
        date: date ?? this.date,
        expectedPoisha: expectedPoisha ?? this.expectedPoisha,
        paidPoisha: paidPoisha ?? this.paidPoisha,
        isHoliday: isHoliday ?? this.isHoliday,
        lastAllocationDate: lastAllocationDate.present
            ? lastAllocationDate.value
            : this.lastAllocationDate,
      );
  CollectionObligation copyWithCompanion(CollectionObligationsCompanion data) {
    return CollectionObligation(
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      scheduleId:
          data.scheduleId.present ? data.scheduleId.value : this.scheduleId,
      date: data.date.present ? data.date.value : this.date,
      expectedPoisha: data.expectedPoisha.present
          ? data.expectedPoisha.value
          : this.expectedPoisha,
      paidPoisha:
          data.paidPoisha.present ? data.paidPoisha.value : this.paidPoisha,
      isHoliday: data.isHoliday.present ? data.isHoliday.value : this.isHoliday,
      lastAllocationDate: data.lastAllocationDate.present
          ? data.lastAllocationDate.value
          : this.lastAllocationDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionObligation(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('date: $date, ')
          ..write('expectedPoisha: $expectedPoisha, ')
          ..write('paidPoisha: $paidPoisha, ')
          ..write('isHoliday: $isHoliday, ')
          ..write('lastAllocationDate: $lastAllocationDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      createdAt,
      updatedAt,
      deviceId,
      localVersion,
      syncStatus,
      isDeleted,
      serverUpdatedAt,
      id,
      personId,
      scheduleId,
      date,
      expectedPoisha,
      paidPoisha,
      isHoliday,
      lastAllocationDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionObligation &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.localVersion == this.localVersion &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.scheduleId == this.scheduleId &&
          other.date == this.date &&
          other.expectedPoisha == this.expectedPoisha &&
          other.paidPoisha == this.paidPoisha &&
          other.isHoliday == this.isHoliday &&
          other.lastAllocationDate == this.lastAllocationDate);
}

class CollectionObligationsCompanion
    extends UpdateCompanion<CollectionObligation> {
  final Value<String> userId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String?> deviceId;
  final Value<int> localVersion;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<int?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> personId;
  final Value<String> scheduleId;
  final Value<String> date;
  final Value<int> expectedPoisha;
  final Value<int> paidPoisha;
  final Value<bool> isHoliday;
  final Value<String?> lastAllocationDate;
  final Value<int> rowid;
  const CollectionObligationsCompanion({
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.scheduleId = const Value.absent(),
    this.date = const Value.absent(),
    this.expectedPoisha = const Value.absent(),
    this.paidPoisha = const Value.absent(),
    this.isHoliday = const Value.absent(),
    this.lastAllocationDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectionObligationsCompanion.insert({
    required String userId,
    required int createdAt,
    required int updatedAt,
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String personId,
    required String scheduleId,
    required String date,
    required int expectedPoisha,
    this.paidPoisha = const Value.absent(),
    this.isHoliday = const Value.absent(),
    this.lastAllocationDate = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        id = Value(id),
        personId = Value(personId),
        scheduleId = Value(scheduleId),
        date = Value(date),
        expectedPoisha = Value(expectedPoisha);
  static Insertable<CollectionObligation> custom({
    Expression<String>? userId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? localVersion,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<int>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? personId,
    Expression<String>? scheduleId,
    Expression<String>? date,
    Expression<int>? expectedPoisha,
    Expression<int>? paidPoisha,
    Expression<bool>? isHoliday,
    Expression<String>? lastAllocationDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (localVersion != null) 'local_version': localVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (scheduleId != null) 'schedule_id': scheduleId,
      if (date != null) 'date': date,
      if (expectedPoisha != null) 'expected_poisha': expectedPoisha,
      if (paidPoisha != null) 'paid_poisha': paidPoisha,
      if (isHoliday != null) 'is_holiday': isHoliday,
      if (lastAllocationDate != null)
        'last_allocation_date': lastAllocationDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectionObligationsCompanion copyWith(
      {Value<String>? userId,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String?>? deviceId,
      Value<int>? localVersion,
      Value<String>? syncStatus,
      Value<bool>? isDeleted,
      Value<int?>? serverUpdatedAt,
      Value<String>? id,
      Value<String>? personId,
      Value<String>? scheduleId,
      Value<String>? date,
      Value<int>? expectedPoisha,
      Value<int>? paidPoisha,
      Value<bool>? isHoliday,
      Value<String?>? lastAllocationDate,
      Value<int>? rowid}) {
    return CollectionObligationsCompanion(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      localVersion: localVersion ?? this.localVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      personId: personId ?? this.personId,
      scheduleId: scheduleId ?? this.scheduleId,
      date: date ?? this.date,
      expectedPoisha: expectedPoisha ?? this.expectedPoisha,
      paidPoisha: paidPoisha ?? this.paidPoisha,
      isHoliday: isHoliday ?? this.isHoliday,
      lastAllocationDate: lastAllocationDate ?? this.lastAllocationDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (scheduleId.present) {
      map['schedule_id'] = Variable<String>(scheduleId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (expectedPoisha.present) {
      map['expected_poisha'] = Variable<int>(expectedPoisha.value);
    }
    if (paidPoisha.present) {
      map['paid_poisha'] = Variable<int>(paidPoisha.value);
    }
    if (isHoliday.present) {
      map['is_holiday'] = Variable<bool>(isHoliday.value);
    }
    if (lastAllocationDate.present) {
      map['last_allocation_date'] = Variable<String>(lastAllocationDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionObligationsCompanion(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('scheduleId: $scheduleId, ')
          ..write('date: $date, ')
          ..write('expectedPoisha: $expectedPoisha, ')
          ..write('paidPoisha: $paidPoisha, ')
          ..write('isHoliday: $isHoliday, ')
          ..write('lastAllocationDate: $lastAllocationDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments with TableInfo<$PaymentsTable, Payment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localVersionMeta =
      const VerificationMeta('localVersion');
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
      'local_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendingUpload'));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<int> serverUpdatedAt = GeneratedColumn<int>(
      'server_updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES persons (id)'));
  static const VerificationMeta _amountPoishaMeta =
      const VerificationMeta('amountPoisha');
  @override
  late final GeneratedColumn<int> amountPoisha = GeneratedColumn<int>(
      'amount_poisha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('cash'));
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isReversalMeta =
      const VerificationMeta('isReversal');
  @override
  late final GeneratedColumn<bool> isReversal = GeneratedColumn<bool>(
      'is_reversal', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_reversal" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reversesPaymentIdMeta =
      const VerificationMeta('reversesPaymentId');
  @override
  late final GeneratedColumn<String> reversesPaymentId =
      GeneratedColumn<String>('reverses_payment_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        createdAt,
        updatedAt,
        deviceId,
        localVersion,
        syncStatus,
        isDeleted,
        serverUpdatedAt,
        id,
        personId,
        amountPoisha,
        date,
        method,
        note,
        isReversal,
        reversesPaymentId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(Insertable<Payment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('local_version')) {
      context.handle(
          _localVersionMeta,
          localVersion.isAcceptableOrUnknown(
              data['local_version']!, _localVersionMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('amount_poisha')) {
      context.handle(
          _amountPoishaMeta,
          amountPoisha.isAcceptableOrUnknown(
              data['amount_poisha']!, _amountPoishaMeta));
    } else if (isInserting) {
      context.missing(_amountPoishaMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('is_reversal')) {
      context.handle(
          _isReversalMeta,
          isReversal.isAcceptableOrUnknown(
              data['is_reversal']!, _isReversalMeta));
    }
    if (data.containsKey('reverses_payment_id')) {
      context.handle(
          _reversesPaymentIdMeta,
          reversesPaymentId.isAcceptableOrUnknown(
              data['reverses_payment_id']!, _reversesPaymentIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Payment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payment(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      localVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_version'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      serverUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_updated_at']),
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
      amountPoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_poisha'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      isReversal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_reversal'])!,
      reversesPaymentId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reverses_payment_id']),
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class Payment extends DataClass implements Insertable<Payment> {
  final String userId;
  final int createdAt;
  final int updatedAt;
  final String? deviceId;
  final int localVersion;
  final String syncStatus;
  final bool isDeleted;
  final int? serverUpdatedAt;
  final String id;
  final String personId;
  final int amountPoisha;
  final String date;
  final String method;
  final String? note;
  final bool isReversal;
  final String? reversesPaymentId;
  const Payment(
      {required this.userId,
      required this.createdAt,
      required this.updatedAt,
      this.deviceId,
      required this.localVersion,
      required this.syncStatus,
      required this.isDeleted,
      this.serverUpdatedAt,
      required this.id,
      required this.personId,
      required this.amountPoisha,
      required this.date,
      required this.method,
      this.note,
      required this.isReversal,
      this.reversesPaymentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['local_version'] = Variable<int>(localVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['person_id'] = Variable<String>(personId);
    map['amount_poisha'] = Variable<int>(amountPoisha);
    map['date'] = Variable<String>(date);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_reversal'] = Variable<bool>(isReversal);
    if (!nullToAbsent || reversesPaymentId != null) {
      map['reverses_payment_id'] = Variable<String>(reversesPaymentId);
    }
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      userId: Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      localVersion: Value(localVersion),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      personId: Value(personId),
      amountPoisha: Value(amountPoisha),
      date: Value(date),
      method: Value(method),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isReversal: Value(isReversal),
      reversesPaymentId: reversesPaymentId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversesPaymentId),
    );
  }

  factory Payment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payment(
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      serverUpdatedAt: serializer.fromJson<int?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      personId: serializer.fromJson<String>(json['personId']),
      amountPoisha: serializer.fromJson<int>(json['amountPoisha']),
      date: serializer.fromJson<String>(json['date']),
      method: serializer.fromJson<String>(json['method']),
      note: serializer.fromJson<String?>(json['note']),
      isReversal: serializer.fromJson<bool>(json['isReversal']),
      reversesPaymentId:
          serializer.fromJson<String?>(json['reversesPaymentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'localVersion': serializer.toJson<int>(localVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'serverUpdatedAt': serializer.toJson<int?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'personId': serializer.toJson<String>(personId),
      'amountPoisha': serializer.toJson<int>(amountPoisha),
      'date': serializer.toJson<String>(date),
      'method': serializer.toJson<String>(method),
      'note': serializer.toJson<String?>(note),
      'isReversal': serializer.toJson<bool>(isReversal),
      'reversesPaymentId': serializer.toJson<String?>(reversesPaymentId),
    };
  }

  Payment copyWith(
          {String? userId,
          int? createdAt,
          int? updatedAt,
          Value<String?> deviceId = const Value.absent(),
          int? localVersion,
          String? syncStatus,
          bool? isDeleted,
          Value<int?> serverUpdatedAt = const Value.absent(),
          String? id,
          String? personId,
          int? amountPoisha,
          String? date,
          String? method,
          Value<String?> note = const Value.absent(),
          bool? isReversal,
          Value<String?> reversesPaymentId = const Value.absent()}) =>
      Payment(
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        localVersion: localVersion ?? this.localVersion,
        syncStatus: syncStatus ?? this.syncStatus,
        isDeleted: isDeleted ?? this.isDeleted,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        id: id ?? this.id,
        personId: personId ?? this.personId,
        amountPoisha: amountPoisha ?? this.amountPoisha,
        date: date ?? this.date,
        method: method ?? this.method,
        note: note.present ? note.value : this.note,
        isReversal: isReversal ?? this.isReversal,
        reversesPaymentId: reversesPaymentId.present
            ? reversesPaymentId.value
            : this.reversesPaymentId,
      );
  Payment copyWithCompanion(PaymentsCompanion data) {
    return Payment(
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      personId: data.personId.present ? data.personId.value : this.personId,
      amountPoisha: data.amountPoisha.present
          ? data.amountPoisha.value
          : this.amountPoisha,
      date: data.date.present ? data.date.value : this.date,
      method: data.method.present ? data.method.value : this.method,
      note: data.note.present ? data.note.value : this.note,
      isReversal:
          data.isReversal.present ? data.isReversal.value : this.isReversal,
      reversesPaymentId: data.reversesPaymentId.present
          ? data.reversesPaymentId.value
          : this.reversesPaymentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payment(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('amountPoisha: $amountPoisha, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('note: $note, ')
          ..write('isReversal: $isReversal, ')
          ..write('reversesPaymentId: $reversesPaymentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      createdAt,
      updatedAt,
      deviceId,
      localVersion,
      syncStatus,
      isDeleted,
      serverUpdatedAt,
      id,
      personId,
      amountPoisha,
      date,
      method,
      note,
      isReversal,
      reversesPaymentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payment &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.localVersion == this.localVersion &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.personId == this.personId &&
          other.amountPoisha == this.amountPoisha &&
          other.date == this.date &&
          other.method == this.method &&
          other.note == this.note &&
          other.isReversal == this.isReversal &&
          other.reversesPaymentId == this.reversesPaymentId);
}

class PaymentsCompanion extends UpdateCompanion<Payment> {
  final Value<String> userId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String?> deviceId;
  final Value<int> localVersion;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<int?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> personId;
  final Value<int> amountPoisha;
  final Value<String> date;
  final Value<String> method;
  final Value<String?> note;
  final Value<bool> isReversal;
  final Value<String?> reversesPaymentId;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.personId = const Value.absent(),
    this.amountPoisha = const Value.absent(),
    this.date = const Value.absent(),
    this.method = const Value.absent(),
    this.note = const Value.absent(),
    this.isReversal = const Value.absent(),
    this.reversesPaymentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String userId,
    required int createdAt,
    required int updatedAt,
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String personId,
    required int amountPoisha,
    required String date,
    this.method = const Value.absent(),
    this.note = const Value.absent(),
    this.isReversal = const Value.absent(),
    this.reversesPaymentId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        id = Value(id),
        personId = Value(personId),
        amountPoisha = Value(amountPoisha),
        date = Value(date);
  static Insertable<Payment> custom({
    Expression<String>? userId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? localVersion,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<int>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? personId,
    Expression<int>? amountPoisha,
    Expression<String>? date,
    Expression<String>? method,
    Expression<String>? note,
    Expression<bool>? isReversal,
    Expression<String>? reversesPaymentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (localVersion != null) 'local_version': localVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (personId != null) 'person_id': personId,
      if (amountPoisha != null) 'amount_poisha': amountPoisha,
      if (date != null) 'date': date,
      if (method != null) 'method': method,
      if (note != null) 'note': note,
      if (isReversal != null) 'is_reversal': isReversal,
      if (reversesPaymentId != null) 'reverses_payment_id': reversesPaymentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith(
      {Value<String>? userId,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String?>? deviceId,
      Value<int>? localVersion,
      Value<String>? syncStatus,
      Value<bool>? isDeleted,
      Value<int?>? serverUpdatedAt,
      Value<String>? id,
      Value<String>? personId,
      Value<int>? amountPoisha,
      Value<String>? date,
      Value<String>? method,
      Value<String?>? note,
      Value<bool>? isReversal,
      Value<String?>? reversesPaymentId,
      Value<int>? rowid}) {
    return PaymentsCompanion(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      localVersion: localVersion ?? this.localVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      personId: personId ?? this.personId,
      amountPoisha: amountPoisha ?? this.amountPoisha,
      date: date ?? this.date,
      method: method ?? this.method,
      note: note ?? this.note,
      isReversal: isReversal ?? this.isReversal,
      reversesPaymentId: reversesPaymentId ?? this.reversesPaymentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (amountPoisha.present) {
      map['amount_poisha'] = Variable<int>(amountPoisha.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isReversal.present) {
      map['is_reversal'] = Variable<bool>(isReversal.value);
    }
    if (reversesPaymentId.present) {
      map['reverses_payment_id'] = Variable<String>(reversesPaymentId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('personId: $personId, ')
          ..write('amountPoisha: $amountPoisha, ')
          ..write('date: $date, ')
          ..write('method: $method, ')
          ..write('note: $note, ')
          ..write('isReversal: $isReversal, ')
          ..write('reversesPaymentId: $reversesPaymentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentAllocationsTable extends PaymentAllocations
    with TableInfo<$PaymentAllocationsTable, PaymentAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localVersionMeta =
      const VerificationMeta('localVersion');
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
      'local_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendingUpload'));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<int> serverUpdatedAt = GeneratedColumn<int>(
      'server_updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paymentIdMeta =
      const VerificationMeta('paymentId');
  @override
  late final GeneratedColumn<String> paymentId = GeneratedColumn<String>(
      'payment_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES payments (id)'));
  static const VerificationMeta _obligationIdMeta =
      const VerificationMeta('obligationId');
  @override
  late final GeneratedColumn<String> obligationId = GeneratedColumn<String>(
      'obligation_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES collection_obligations (id)'));
  static const VerificationMeta _amountPoishaMeta =
      const VerificationMeta('amountPoisha');
  @override
  late final GeneratedColumn<int> amountPoisha = GeneratedColumn<int>(
      'amount_poisha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        createdAt,
        updatedAt,
        deviceId,
        localVersion,
        syncStatus,
        isDeleted,
        serverUpdatedAt,
        id,
        paymentId,
        obligationId,
        amountPoisha
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_allocations';
  @override
  VerificationContext validateIntegrity(Insertable<PaymentAllocation> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('local_version')) {
      context.handle(
          _localVersionMeta,
          localVersion.isAcceptableOrUnknown(
              data['local_version']!, _localVersionMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payment_id')) {
      context.handle(_paymentIdMeta,
          paymentId.isAcceptableOrUnknown(data['payment_id']!, _paymentIdMeta));
    } else if (isInserting) {
      context.missing(_paymentIdMeta);
    }
    if (data.containsKey('obligation_id')) {
      context.handle(
          _obligationIdMeta,
          obligationId.isAcceptableOrUnknown(
              data['obligation_id']!, _obligationIdMeta));
    } else if (isInserting) {
      context.missing(_obligationIdMeta);
    }
    if (data.containsKey('amount_poisha')) {
      context.handle(
          _amountPoishaMeta,
          amountPoisha.isAcceptableOrUnknown(
              data['amount_poisha']!, _amountPoishaMeta));
    } else if (isInserting) {
      context.missing(_amountPoishaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentAllocation(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      localVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_version'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      serverUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_updated_at']),
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      paymentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_id'])!,
      obligationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}obligation_id'])!,
      amountPoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_poisha'])!,
    );
  }

  @override
  $PaymentAllocationsTable createAlias(String alias) {
    return $PaymentAllocationsTable(attachedDatabase, alias);
  }
}

class PaymentAllocation extends DataClass
    implements Insertable<PaymentAllocation> {
  final String userId;
  final int createdAt;
  final int updatedAt;
  final String? deviceId;
  final int localVersion;
  final String syncStatus;
  final bool isDeleted;
  final int? serverUpdatedAt;
  final String id;
  final String paymentId;
  final String obligationId;
  final int amountPoisha;
  const PaymentAllocation(
      {required this.userId,
      required this.createdAt,
      required this.updatedAt,
      this.deviceId,
      required this.localVersion,
      required this.syncStatus,
      required this.isDeleted,
      this.serverUpdatedAt,
      required this.id,
      required this.paymentId,
      required this.obligationId,
      required this.amountPoisha});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['local_version'] = Variable<int>(localVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['payment_id'] = Variable<String>(paymentId);
    map['obligation_id'] = Variable<String>(obligationId);
    map['amount_poisha'] = Variable<int>(amountPoisha);
    return map;
  }

  PaymentAllocationsCompanion toCompanion(bool nullToAbsent) {
    return PaymentAllocationsCompanion(
      userId: Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      localVersion: Value(localVersion),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      paymentId: Value(paymentId),
      obligationId: Value(obligationId),
      amountPoisha: Value(amountPoisha),
    );
  }

  factory PaymentAllocation.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentAllocation(
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      serverUpdatedAt: serializer.fromJson<int?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      paymentId: serializer.fromJson<String>(json['paymentId']),
      obligationId: serializer.fromJson<String>(json['obligationId']),
      amountPoisha: serializer.fromJson<int>(json['amountPoisha']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'localVersion': serializer.toJson<int>(localVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'serverUpdatedAt': serializer.toJson<int?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'paymentId': serializer.toJson<String>(paymentId),
      'obligationId': serializer.toJson<String>(obligationId),
      'amountPoisha': serializer.toJson<int>(amountPoisha),
    };
  }

  PaymentAllocation copyWith(
          {String? userId,
          int? createdAt,
          int? updatedAt,
          Value<String?> deviceId = const Value.absent(),
          int? localVersion,
          String? syncStatus,
          bool? isDeleted,
          Value<int?> serverUpdatedAt = const Value.absent(),
          String? id,
          String? paymentId,
          String? obligationId,
          int? amountPoisha}) =>
      PaymentAllocation(
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        localVersion: localVersion ?? this.localVersion,
        syncStatus: syncStatus ?? this.syncStatus,
        isDeleted: isDeleted ?? this.isDeleted,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        id: id ?? this.id,
        paymentId: paymentId ?? this.paymentId,
        obligationId: obligationId ?? this.obligationId,
        amountPoisha: amountPoisha ?? this.amountPoisha,
      );
  PaymentAllocation copyWithCompanion(PaymentAllocationsCompanion data) {
    return PaymentAllocation(
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      paymentId: data.paymentId.present ? data.paymentId.value : this.paymentId,
      obligationId: data.obligationId.present
          ? data.obligationId.value
          : this.obligationId,
      amountPoisha: data.amountPoisha.present
          ? data.amountPoisha.value
          : this.amountPoisha,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocation(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('obligationId: $obligationId, ')
          ..write('amountPoisha: $amountPoisha')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      createdAt,
      updatedAt,
      deviceId,
      localVersion,
      syncStatus,
      isDeleted,
      serverUpdatedAt,
      id,
      paymentId,
      obligationId,
      amountPoisha);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentAllocation &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.localVersion == this.localVersion &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.paymentId == this.paymentId &&
          other.obligationId == this.obligationId &&
          other.amountPoisha == this.amountPoisha);
}

class PaymentAllocationsCompanion extends UpdateCompanion<PaymentAllocation> {
  final Value<String> userId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String?> deviceId;
  final Value<int> localVersion;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<int?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> paymentId;
  final Value<String> obligationId;
  final Value<int> amountPoisha;
  final Value<int> rowid;
  const PaymentAllocationsCompanion({
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.paymentId = const Value.absent(),
    this.obligationId = const Value.absent(),
    this.amountPoisha = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentAllocationsCompanion.insert({
    required String userId,
    required int createdAt,
    required int updatedAt,
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String paymentId,
    required String obligationId,
    required int amountPoisha,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        id = Value(id),
        paymentId = Value(paymentId),
        obligationId = Value(obligationId),
        amountPoisha = Value(amountPoisha);
  static Insertable<PaymentAllocation> custom({
    Expression<String>? userId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? localVersion,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<int>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? paymentId,
    Expression<String>? obligationId,
    Expression<int>? amountPoisha,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (localVersion != null) 'local_version': localVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (paymentId != null) 'payment_id': paymentId,
      if (obligationId != null) 'obligation_id': obligationId,
      if (amountPoisha != null) 'amount_poisha': amountPoisha,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentAllocationsCompanion copyWith(
      {Value<String>? userId,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String?>? deviceId,
      Value<int>? localVersion,
      Value<String>? syncStatus,
      Value<bool>? isDeleted,
      Value<int?>? serverUpdatedAt,
      Value<String>? id,
      Value<String>? paymentId,
      Value<String>? obligationId,
      Value<int>? amountPoisha,
      Value<int>? rowid}) {
    return PaymentAllocationsCompanion(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      localVersion: localVersion ?? this.localVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      paymentId: paymentId ?? this.paymentId,
      obligationId: obligationId ?? this.obligationId,
      amountPoisha: amountPoisha ?? this.amountPoisha,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (paymentId.present) {
      map['payment_id'] = Variable<String>(paymentId.value);
    }
    if (obligationId.present) {
      map['obligation_id'] = Variable<String>(obligationId.value);
    }
    if (amountPoisha.present) {
      map['amount_poisha'] = Variable<int>(amountPoisha.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentAllocationsCompanion(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('paymentId: $paymentId, ')
          ..write('obligationId: $obligationId, ')
          ..write('amountPoisha: $amountPoisha, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LedgerEntriesTable extends LedgerEntries
    with TableInfo<$LedgerEntriesTable, LedgerEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localVersionMeta =
      const VerificationMeta('localVersion');
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
      'local_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendingUpload'));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<int> serverUpdatedAt = GeneratedColumn<int>(
      'server_updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _directionMeta =
      const VerificationMeta('direction');
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
      'direction', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountPoishaMeta =
      const VerificationMeta('amountPoisha');
  @override
  late final GeneratedColumn<int> amountPoisha = GeneratedColumn<int>(
      'amount_poisha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _moduleMeta = const VerificationMeta('module');
  @override
  late final GeneratedColumn<String> module = GeneratedColumn<String>(
      'module', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isReversalMeta =
      const VerificationMeta('isReversal');
  @override
  late final GeneratedColumn<bool> isReversal = GeneratedColumn<bool>(
      'is_reversal', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_reversal" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reversesEntryIdMeta =
      const VerificationMeta('reversesEntryId');
  @override
  late final GeneratedColumn<String> reversesEntryId = GeneratedColumn<String>(
      'reverses_entry_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        createdAt,
        updatedAt,
        deviceId,
        localVersion,
        syncStatus,
        isDeleted,
        serverUpdatedAt,
        id,
        date,
        direction,
        amountPoisha,
        module,
        personId,
        accountId,
        category,
        note,
        isReversal,
        reversesEntryId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_entries';
  @override
  VerificationContext validateIntegrity(Insertable<LedgerEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('local_version')) {
      context.handle(
          _localVersionMeta,
          localVersion.isAcceptableOrUnknown(
              data['local_version']!, _localVersionMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(_directionMeta,
          direction.isAcceptableOrUnknown(data['direction']!, _directionMeta));
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('amount_poisha')) {
      context.handle(
          _amountPoishaMeta,
          amountPoisha.isAcceptableOrUnknown(
              data['amount_poisha']!, _amountPoishaMeta));
    } else if (isInserting) {
      context.missing(_amountPoishaMeta);
    }
    if (data.containsKey('module')) {
      context.handle(_moduleMeta,
          module.isAcceptableOrUnknown(data['module']!, _moduleMeta));
    } else if (isInserting) {
      context.missing(_moduleMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('is_reversal')) {
      context.handle(
          _isReversalMeta,
          isReversal.isAcceptableOrUnknown(
              data['is_reversal']!, _isReversalMeta));
    }
    if (data.containsKey('reverses_entry_id')) {
      context.handle(
          _reversesEntryIdMeta,
          reversesEntryId.isAcceptableOrUnknown(
              data['reverses_entry_id']!, _reversesEntryIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerEntry(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      localVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_version'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      serverUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_updated_at']),
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      direction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}direction'])!,
      amountPoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_poisha'])!,
      module: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}module'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id']),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      isReversal: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_reversal'])!,
      reversesEntryId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reverses_entry_id']),
    );
  }

  @override
  $LedgerEntriesTable createAlias(String alias) {
    return $LedgerEntriesTable(attachedDatabase, alias);
  }
}

class LedgerEntry extends DataClass implements Insertable<LedgerEntry> {
  final String userId;
  final int createdAt;
  final int updatedAt;
  final String? deviceId;
  final int localVersion;
  final String syncStatus;
  final bool isDeleted;
  final int? serverUpdatedAt;
  final String id;
  final String date;
  final String direction;
  final int amountPoisha;
  final String module;
  final String? personId;
  final String? accountId;
  final String? category;
  final String? note;
  final bool isReversal;
  final String? reversesEntryId;
  const LedgerEntry(
      {required this.userId,
      required this.createdAt,
      required this.updatedAt,
      this.deviceId,
      required this.localVersion,
      required this.syncStatus,
      required this.isDeleted,
      this.serverUpdatedAt,
      required this.id,
      required this.date,
      required this.direction,
      required this.amountPoisha,
      required this.module,
      this.personId,
      this.accountId,
      this.category,
      this.note,
      required this.isReversal,
      this.reversesEntryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['local_version'] = Variable<int>(localVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['direction'] = Variable<String>(direction);
    map['amount_poisha'] = Variable<int>(amountPoisha);
    map['module'] = Variable<String>(module);
    if (!nullToAbsent || personId != null) {
      map['person_id'] = Variable<String>(personId);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['is_reversal'] = Variable<bool>(isReversal);
    if (!nullToAbsent || reversesEntryId != null) {
      map['reverses_entry_id'] = Variable<String>(reversesEntryId);
    }
    return map;
  }

  LedgerEntriesCompanion toCompanion(bool nullToAbsent) {
    return LedgerEntriesCompanion(
      userId: Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      localVersion: Value(localVersion),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      date: Value(date),
      direction: Value(direction),
      amountPoisha: Value(amountPoisha),
      module: Value(module),
      personId: personId == null && nullToAbsent
          ? const Value.absent()
          : Value(personId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      isReversal: Value(isReversal),
      reversesEntryId: reversesEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversesEntryId),
    );
  }

  factory LedgerEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerEntry(
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      serverUpdatedAt: serializer.fromJson<int?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      direction: serializer.fromJson<String>(json['direction']),
      amountPoisha: serializer.fromJson<int>(json['amountPoisha']),
      module: serializer.fromJson<String>(json['module']),
      personId: serializer.fromJson<String?>(json['personId']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      category: serializer.fromJson<String?>(json['category']),
      note: serializer.fromJson<String?>(json['note']),
      isReversal: serializer.fromJson<bool>(json['isReversal']),
      reversesEntryId: serializer.fromJson<String?>(json['reversesEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'localVersion': serializer.toJson<int>(localVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'serverUpdatedAt': serializer.toJson<int?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'direction': serializer.toJson<String>(direction),
      'amountPoisha': serializer.toJson<int>(amountPoisha),
      'module': serializer.toJson<String>(module),
      'personId': serializer.toJson<String?>(personId),
      'accountId': serializer.toJson<String?>(accountId),
      'category': serializer.toJson<String?>(category),
      'note': serializer.toJson<String?>(note),
      'isReversal': serializer.toJson<bool>(isReversal),
      'reversesEntryId': serializer.toJson<String?>(reversesEntryId),
    };
  }

  LedgerEntry copyWith(
          {String? userId,
          int? createdAt,
          int? updatedAt,
          Value<String?> deviceId = const Value.absent(),
          int? localVersion,
          String? syncStatus,
          bool? isDeleted,
          Value<int?> serverUpdatedAt = const Value.absent(),
          String? id,
          String? date,
          String? direction,
          int? amountPoisha,
          String? module,
          Value<String?> personId = const Value.absent(),
          Value<String?> accountId = const Value.absent(),
          Value<String?> category = const Value.absent(),
          Value<String?> note = const Value.absent(),
          bool? isReversal,
          Value<String?> reversesEntryId = const Value.absent()}) =>
      LedgerEntry(
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        localVersion: localVersion ?? this.localVersion,
        syncStatus: syncStatus ?? this.syncStatus,
        isDeleted: isDeleted ?? this.isDeleted,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        id: id ?? this.id,
        date: date ?? this.date,
        direction: direction ?? this.direction,
        amountPoisha: amountPoisha ?? this.amountPoisha,
        module: module ?? this.module,
        personId: personId.present ? personId.value : this.personId,
        accountId: accountId.present ? accountId.value : this.accountId,
        category: category.present ? category.value : this.category,
        note: note.present ? note.value : this.note,
        isReversal: isReversal ?? this.isReversal,
        reversesEntryId: reversesEntryId.present
            ? reversesEntryId.value
            : this.reversesEntryId,
      );
  LedgerEntry copyWithCompanion(LedgerEntriesCompanion data) {
    return LedgerEntry(
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      direction: data.direction.present ? data.direction.value : this.direction,
      amountPoisha: data.amountPoisha.present
          ? data.amountPoisha.value
          : this.amountPoisha,
      module: data.module.present ? data.module.value : this.module,
      personId: data.personId.present ? data.personId.value : this.personId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      category: data.category.present ? data.category.value : this.category,
      note: data.note.present ? data.note.value : this.note,
      isReversal:
          data.isReversal.present ? data.isReversal.value : this.isReversal,
      reversesEntryId: data.reversesEntryId.present
          ? data.reversesEntryId.value
          : this.reversesEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEntry(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('direction: $direction, ')
          ..write('amountPoisha: $amountPoisha, ')
          ..write('module: $module, ')
          ..write('personId: $personId, ')
          ..write('accountId: $accountId, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('isReversal: $isReversal, ')
          ..write('reversesEntryId: $reversesEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      createdAt,
      updatedAt,
      deviceId,
      localVersion,
      syncStatus,
      isDeleted,
      serverUpdatedAt,
      id,
      date,
      direction,
      amountPoisha,
      module,
      personId,
      accountId,
      category,
      note,
      isReversal,
      reversesEntryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerEntry &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.localVersion == this.localVersion &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.date == this.date &&
          other.direction == this.direction &&
          other.amountPoisha == this.amountPoisha &&
          other.module == this.module &&
          other.personId == this.personId &&
          other.accountId == this.accountId &&
          other.category == this.category &&
          other.note == this.note &&
          other.isReversal == this.isReversal &&
          other.reversesEntryId == this.reversesEntryId);
}

class LedgerEntriesCompanion extends UpdateCompanion<LedgerEntry> {
  final Value<String> userId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String?> deviceId;
  final Value<int> localVersion;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<int?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> date;
  final Value<String> direction;
  final Value<int> amountPoisha;
  final Value<String> module;
  final Value<String?> personId;
  final Value<String?> accountId;
  final Value<String?> category;
  final Value<String?> note;
  final Value<bool> isReversal;
  final Value<String?> reversesEntryId;
  final Value<int> rowid;
  const LedgerEntriesCompanion({
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.direction = const Value.absent(),
    this.amountPoisha = const Value.absent(),
    this.module = const Value.absent(),
    this.personId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.category = const Value.absent(),
    this.note = const Value.absent(),
    this.isReversal = const Value.absent(),
    this.reversesEntryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LedgerEntriesCompanion.insert({
    required String userId,
    required int createdAt,
    required int updatedAt,
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String date,
    required String direction,
    required int amountPoisha,
    required String module,
    this.personId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.category = const Value.absent(),
    this.note = const Value.absent(),
    this.isReversal = const Value.absent(),
    this.reversesEntryId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        id = Value(id),
        date = Value(date),
        direction = Value(direction),
        amountPoisha = Value(amountPoisha),
        module = Value(module);
  static Insertable<LedgerEntry> custom({
    Expression<String>? userId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? localVersion,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<int>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? date,
    Expression<String>? direction,
    Expression<int>? amountPoisha,
    Expression<String>? module,
    Expression<String>? personId,
    Expression<String>? accountId,
    Expression<String>? category,
    Expression<String>? note,
    Expression<bool>? isReversal,
    Expression<String>? reversesEntryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (localVersion != null) 'local_version': localVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (direction != null) 'direction': direction,
      if (amountPoisha != null) 'amount_poisha': amountPoisha,
      if (module != null) 'module': module,
      if (personId != null) 'person_id': personId,
      if (accountId != null) 'account_id': accountId,
      if (category != null) 'category': category,
      if (note != null) 'note': note,
      if (isReversal != null) 'is_reversal': isReversal,
      if (reversesEntryId != null) 'reverses_entry_id': reversesEntryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LedgerEntriesCompanion copyWith(
      {Value<String>? userId,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String?>? deviceId,
      Value<int>? localVersion,
      Value<String>? syncStatus,
      Value<bool>? isDeleted,
      Value<int?>? serverUpdatedAt,
      Value<String>? id,
      Value<String>? date,
      Value<String>? direction,
      Value<int>? amountPoisha,
      Value<String>? module,
      Value<String?>? personId,
      Value<String?>? accountId,
      Value<String?>? category,
      Value<String?>? note,
      Value<bool>? isReversal,
      Value<String?>? reversesEntryId,
      Value<int>? rowid}) {
    return LedgerEntriesCompanion(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      localVersion: localVersion ?? this.localVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      date: date ?? this.date,
      direction: direction ?? this.direction,
      amountPoisha: amountPoisha ?? this.amountPoisha,
      module: module ?? this.module,
      personId: personId ?? this.personId,
      accountId: accountId ?? this.accountId,
      category: category ?? this.category,
      note: note ?? this.note,
      isReversal: isReversal ?? this.isReversal,
      reversesEntryId: reversesEntryId ?? this.reversesEntryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (amountPoisha.present) {
      map['amount_poisha'] = Variable<int>(amountPoisha.value);
    }
    if (module.present) {
      map['module'] = Variable<String>(module.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (isReversal.present) {
      map['is_reversal'] = Variable<bool>(isReversal.value);
    }
    if (reversesEntryId.present) {
      map['reverses_entry_id'] = Variable<String>(reversesEntryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEntriesCompanion(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('direction: $direction, ')
          ..write('amountPoisha: $amountPoisha, ')
          ..write('module: $module, ')
          ..write('personId: $personId, ')
          ..write('accountId: $accountId, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('isReversal: $isReversal, ')
          ..write('reversesEntryId: $reversesEntryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localVersionMeta =
      const VerificationMeta('localVersion');
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
      'local_version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendingUpload'));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _serverUpdatedAtMeta =
      const VerificationMeta('serverUpdatedAt');
  @override
  late final GeneratedColumn<int> serverUpdatedAt = GeneratedColumn<int>(
      'server_updated_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        userId,
        createdAt,
        updatedAt,
        deviceId,
        localVersion,
        syncStatus,
        isDeleted,
        serverUpdatedAt,
        id,
        kind,
        label,
        number
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    }
    if (data.containsKey('local_version')) {
      context.handle(
          _localVersionMeta,
          localVersion.isAcceptableOrUnknown(
              data['local_version']!, _localVersionMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('server_updated_at')) {
      context.handle(
          _serverUpdatedAtMeta,
          serverUpdatedAt.isAcceptableOrUnknown(
              data['server_updated_at']!, _serverUpdatedAtMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id']),
      localVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_version'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_status'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      serverUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_updated_at']),
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number']),
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final String userId;
  final int createdAt;
  final int updatedAt;
  final String? deviceId;
  final int localVersion;
  final String syncStatus;
  final bool isDeleted;
  final int? serverUpdatedAt;
  final String id;
  final String kind;
  final String label;
  final String? number;
  const Account(
      {required this.userId,
      required this.createdAt,
      required this.updatedAt,
      this.deviceId,
      required this.localVersion,
      required this.syncStatus,
      required this.isDeleted,
      this.serverUpdatedAt,
      required this.id,
      required this.kind,
      required this.label,
      this.number});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deviceId != null) {
      map['device_id'] = Variable<String>(deviceId);
    }
    map['local_version'] = Variable<int>(localVersion);
    map['sync_status'] = Variable<String>(syncStatus);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || serverUpdatedAt != null) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt);
    }
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || number != null) {
      map['number'] = Variable<String>(number);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      userId: Value(userId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deviceId: deviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(deviceId),
      localVersion: Value(localVersion),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
      serverUpdatedAt: serverUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(serverUpdatedAt),
      id: Value(id),
      kind: Value(kind),
      label: Value(label),
      number:
          number == null && nullToAbsent ? const Value.absent() : Value(number),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      userId: serializer.fromJson<String>(json['userId']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String?>(json['deviceId']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      serverUpdatedAt: serializer.fromJson<int?>(json['serverUpdatedAt']),
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      label: serializer.fromJson<String>(json['label']),
      number: serializer.fromJson<String?>(json['number']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String?>(deviceId),
      'localVersion': serializer.toJson<int>(localVersion),
      'syncStatus': serializer.toJson<String>(syncStatus),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'serverUpdatedAt': serializer.toJson<int?>(serverUpdatedAt),
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'label': serializer.toJson<String>(label),
      'number': serializer.toJson<String?>(number),
    };
  }

  Account copyWith(
          {String? userId,
          int? createdAt,
          int? updatedAt,
          Value<String?> deviceId = const Value.absent(),
          int? localVersion,
          String? syncStatus,
          bool? isDeleted,
          Value<int?> serverUpdatedAt = const Value.absent(),
          String? id,
          String? kind,
          String? label,
          Value<String?> number = const Value.absent()}) =>
      Account(
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deviceId: deviceId.present ? deviceId.value : this.deviceId,
        localVersion: localVersion ?? this.localVersion,
        syncStatus: syncStatus ?? this.syncStatus,
        isDeleted: isDeleted ?? this.isDeleted,
        serverUpdatedAt: serverUpdatedAt.present
            ? serverUpdatedAt.value
            : this.serverUpdatedAt,
        id: id ?? this.id,
        kind: kind ?? this.kind,
        label: label ?? this.label,
        number: number.present ? number.value : this.number,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      userId: data.userId.present ? data.userId.value : this.userId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      syncStatus:
          data.syncStatus.present ? data.syncStatus.value : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      serverUpdatedAt: data.serverUpdatedAt.present
          ? data.serverUpdatedAt.value
          : this.serverUpdatedAt,
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      label: data.label.present ? data.label.value : this.label,
      number: data.number.present ? data.number.value : this.number,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('label: $label, ')
          ..write('number: $number')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      userId,
      createdAt,
      updatedAt,
      deviceId,
      localVersion,
      syncStatus,
      isDeleted,
      serverUpdatedAt,
      id,
      kind,
      label,
      number);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.userId == this.userId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.localVersion == this.localVersion &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted &&
          other.serverUpdatedAt == this.serverUpdatedAt &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.label == this.label &&
          other.number == this.number);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> userId;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<String?> deviceId;
  final Value<int> localVersion;
  final Value<String> syncStatus;
  final Value<bool> isDeleted;
  final Value<int?> serverUpdatedAt;
  final Value<String> id;
  final Value<String> kind;
  final Value<String> label;
  final Value<String?> number;
  final Value<int> rowid;
  const AccountsCompanion({
    this.userId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.label = const Value.absent(),
    this.number = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String userId,
    required int createdAt,
    required int updatedAt,
    this.deviceId = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.serverUpdatedAt = const Value.absent(),
    required String id,
    required String kind,
    required String label,
    this.number = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt),
        id = Value(id),
        kind = Value(kind),
        label = Value(label);
  static Insertable<Account> custom({
    Expression<String>? userId,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? localVersion,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
    Expression<int>? serverUpdatedAt,
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? label,
    Expression<String>? number,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (localVersion != null) 'local_version': localVersion,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (serverUpdatedAt != null) 'server_updated_at': serverUpdatedAt,
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (label != null) 'label': label,
      if (number != null) 'number': number,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith(
      {Value<String>? userId,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<String?>? deviceId,
      Value<int>? localVersion,
      Value<String>? syncStatus,
      Value<bool>? isDeleted,
      Value<int?>? serverUpdatedAt,
      Value<String>? id,
      Value<String>? kind,
      Value<String>? label,
      Value<String?>? number,
      Value<int>? rowid}) {
    return AccountsCompanion(
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      localVersion: localVersion ?? this.localVersion,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
      serverUpdatedAt: serverUpdatedAt ?? this.serverUpdatedAt,
      id: id ?? this.id,
      kind: kind ?? this.kind,
      label: label ?? this.label,
      number: number ?? this.number,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (serverUpdatedAt.present) {
      map['server_updated_at'] = Variable<int>(serverUpdatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('userId: $userId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('localVersion: $localVersion, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('serverUpdatedAt: $serverUpdatedAt, ')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('label: $label, ')
          ..write('number: $number, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueEntriesTable extends SyncQueueEntries
    with TableInfo<$SyncQueueEntriesTable, SyncQueueEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _opIdMeta = const VerificationMeta('opId');
  @override
  late final GeneratedColumn<String> opId = GeneratedColumn<String>(
      'op_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
      'entity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localVersionMeta =
      const VerificationMeta('localVersion');
  @override
  late final GeneratedColumn<int> localVersion = GeneratedColumn<int>(
      'local_version', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pendingUpload'));
  static const VerificationMeta _attemptsMeta =
      const VerificationMeta('attempts');
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
      'attempts', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        opId,
        recordId,
        entity,
        localVersion,
        status,
        attempts,
        lastError,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('op_id')) {
      context.handle(
          _opIdMeta, opId.isAcceptableOrUnknown(data['op_id']!, _opIdMeta));
    } else if (isInserting) {
      context.missing(_opIdMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(_entityMeta,
          entity.isAcceptableOrUnknown(data['entity']!, _entityMeta));
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('local_version')) {
      context.handle(
          _localVersionMeta,
          localVersion.isAcceptableOrUnknown(
              data['local_version']!, _localVersionMeta));
    } else if (isInserting) {
      context.missing(_localVersionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('attempts')) {
      context.handle(_attemptsMeta,
          attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {opId};
  @override
  SyncQueueEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueEntry(
      opId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}op_id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      entity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity'])!,
      localVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_version'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      attempts: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SyncQueueEntriesTable createAlias(String alias) {
    return $SyncQueueEntriesTable(attachedDatabase, alias);
  }
}

class SyncQueueEntry extends DataClass implements Insertable<SyncQueueEntry> {
  final String opId;
  final String recordId;
  final String entity;
  final int localVersion;
  final String status;
  final int attempts;
  final String? lastError;
  final int createdAt;
  final int updatedAt;
  const SyncQueueEntry(
      {required this.opId,
      required this.recordId,
      required this.entity,
      required this.localVersion,
      required this.status,
      required this.attempts,
      this.lastError,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['op_id'] = Variable<String>(opId);
    map['record_id'] = Variable<String>(recordId);
    map['entity'] = Variable<String>(entity);
    map['local_version'] = Variable<int>(localVersion);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SyncQueueEntriesCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueEntriesCompanion(
      opId: Value(opId),
      recordId: Value(recordId),
      entity: Value(entity),
      localVersion: Value(localVersion),
      status: Value(status),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueEntry(
      opId: serializer.fromJson<String>(json['opId']),
      recordId: serializer.fromJson<String>(json['recordId']),
      entity: serializer.fromJson<String>(json['entity']),
      localVersion: serializer.fromJson<int>(json['localVersion']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'opId': serializer.toJson<String>(opId),
      'recordId': serializer.toJson<String>(recordId),
      'entity': serializer.toJson<String>(entity),
      'localVersion': serializer.toJson<int>(localVersion),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SyncQueueEntry copyWith(
          {String? opId,
          String? recordId,
          String? entity,
          int? localVersion,
          String? status,
          int? attempts,
          Value<String?> lastError = const Value.absent(),
          int? createdAt,
          int? updatedAt}) =>
      SyncQueueEntry(
        opId: opId ?? this.opId,
        recordId: recordId ?? this.recordId,
        entity: entity ?? this.entity,
        localVersion: localVersion ?? this.localVersion,
        status: status ?? this.status,
        attempts: attempts ?? this.attempts,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncQueueEntry copyWithCompanion(SyncQueueEntriesCompanion data) {
    return SyncQueueEntry(
      opId: data.opId.present ? data.opId.value : this.opId,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      entity: data.entity.present ? data.entity.value : this.entity,
      localVersion: data.localVersion.present
          ? data.localVersion.value
          : this.localVersion,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueEntry(')
          ..write('opId: $opId, ')
          ..write('recordId: $recordId, ')
          ..write('entity: $entity, ')
          ..write('localVersion: $localVersion, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(opId, recordId, entity, localVersion, status,
      attempts, lastError, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueEntry &&
          other.opId == this.opId &&
          other.recordId == this.recordId &&
          other.entity == this.entity &&
          other.localVersion == this.localVersion &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueEntriesCompanion extends UpdateCompanion<SyncQueueEntry> {
  final Value<String> opId;
  final Value<String> recordId;
  final Value<String> entity;
  final Value<int> localVersion;
  final Value<String> status;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SyncQueueEntriesCompanion({
    this.opId = const Value.absent(),
    this.recordId = const Value.absent(),
    this.entity = const Value.absent(),
    this.localVersion = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueEntriesCompanion.insert({
    required String opId,
    required String recordId,
    required String entity,
    required int localVersion,
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    required int createdAt,
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : opId = Value(opId),
        recordId = Value(recordId),
        entity = Value(entity),
        localVersion = Value(localVersion),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SyncQueueEntry> custom({
    Expression<String>? opId,
    Expression<String>? recordId,
    Expression<String>? entity,
    Expression<int>? localVersion,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (opId != null) 'op_id': opId,
      if (recordId != null) 'record_id': recordId,
      if (entity != null) 'entity': entity,
      if (localVersion != null) 'local_version': localVersion,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueEntriesCompanion copyWith(
      {Value<String>? opId,
      Value<String>? recordId,
      Value<String>? entity,
      Value<int>? localVersion,
      Value<String>? status,
      Value<int>? attempts,
      Value<String?>? lastError,
      Value<int>? createdAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return SyncQueueEntriesCompanion(
      opId: opId ?? this.opId,
      recordId: recordId ?? this.recordId,
      entity: entity ?? this.entity,
      localVersion: localVersion ?? this.localVersion,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (opId.present) {
      map['op_id'] = Variable<String>(opId.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (localVersion.present) {
      map['local_version'] = Variable<int>(localVersion.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueEntriesCompanion(')
          ..write('opId: $opId, ')
          ..write('recordId: $recordId, ')
          ..write('entity: $entity, ')
          ..write('localVersion: $localVersion, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailySummariesTable extends DailySummaries
    with TableInfo<$DailySummariesTable, DailySummary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailySummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _openingPoishaMeta =
      const VerificationMeta('openingPoisha');
  @override
  late final GeneratedColumn<int> openingPoisha = GeneratedColumn<int>(
      'opening_poisha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalInPoishaMeta =
      const VerificationMeta('totalInPoisha');
  @override
  late final GeneratedColumn<int> totalInPoisha = GeneratedColumn<int>(
      'total_in_poisha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _totalOutPoishaMeta =
      const VerificationMeta('totalOutPoisha');
  @override
  late final GeneratedColumn<int> totalOutPoisha = GeneratedColumn<int>(
      'total_out_poisha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _collectionPoishaMeta =
      const VerificationMeta('collectionPoisha');
  @override
  late final GeneratedColumn<int> collectionPoisha = GeneratedColumn<int>(
      'collection_poisha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _closingPoishaMeta =
      const VerificationMeta('closingPoisha');
  @override
  late final GeneratedColumn<int> closingPoisha = GeneratedColumn<int>(
      'closing_poisha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isClosedMeta =
      const VerificationMeta('isClosed');
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
      'is_closed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_closed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _closedByMeta =
      const VerificationMeta('closedBy');
  @override
  late final GeneratedColumn<String> closedBy = GeneratedColumn<String>(
      'closed_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _closedAtMeta =
      const VerificationMeta('closedAt');
  @override
  late final GeneratedColumn<int> closedAt = GeneratedColumn<int>(
      'closed_at', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        date,
        userId,
        openingPoisha,
        totalInPoisha,
        totalOutPoisha,
        collectionPoisha,
        closingPoisha,
        isClosed,
        closedBy,
        closedAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_summaries';
  @override
  VerificationContext validateIntegrity(Insertable<DailySummary> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('opening_poisha')) {
      context.handle(
          _openingPoishaMeta,
          openingPoisha.isAcceptableOrUnknown(
              data['opening_poisha']!, _openingPoishaMeta));
    } else if (isInserting) {
      context.missing(_openingPoishaMeta);
    }
    if (data.containsKey('total_in_poisha')) {
      context.handle(
          _totalInPoishaMeta,
          totalInPoisha.isAcceptableOrUnknown(
              data['total_in_poisha']!, _totalInPoishaMeta));
    } else if (isInserting) {
      context.missing(_totalInPoishaMeta);
    }
    if (data.containsKey('total_out_poisha')) {
      context.handle(
          _totalOutPoishaMeta,
          totalOutPoisha.isAcceptableOrUnknown(
              data['total_out_poisha']!, _totalOutPoishaMeta));
    } else if (isInserting) {
      context.missing(_totalOutPoishaMeta);
    }
    if (data.containsKey('collection_poisha')) {
      context.handle(
          _collectionPoishaMeta,
          collectionPoisha.isAcceptableOrUnknown(
              data['collection_poisha']!, _collectionPoishaMeta));
    } else if (isInserting) {
      context.missing(_collectionPoishaMeta);
    }
    if (data.containsKey('closing_poisha')) {
      context.handle(
          _closingPoishaMeta,
          closingPoisha.isAcceptableOrUnknown(
              data['closing_poisha']!, _closingPoishaMeta));
    } else if (isInserting) {
      context.missing(_closingPoishaMeta);
    }
    if (data.containsKey('is_closed')) {
      context.handle(_isClosedMeta,
          isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta));
    }
    if (data.containsKey('closed_by')) {
      context.handle(_closedByMeta,
          closedBy.isAcceptableOrUnknown(data['closed_by']!, _closedByMeta));
    }
    if (data.containsKey('closed_at')) {
      context.handle(_closedAtMeta,
          closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailySummary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySummary(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      openingPoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}opening_poisha'])!,
      totalInPoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_in_poisha'])!,
      totalOutPoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_out_poisha'])!,
      collectionPoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}collection_poisha'])!,
      closingPoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}closing_poisha'])!,
      isClosed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_closed'])!,
      closedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}closed_by']),
      closedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}closed_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $DailySummariesTable createAlias(String alias) {
    return $DailySummariesTable(attachedDatabase, alias);
  }
}

class DailySummary extends DataClass implements Insertable<DailySummary> {
  final String date;
  final String userId;
  final int openingPoisha;
  final int totalInPoisha;
  final int totalOutPoisha;
  final int collectionPoisha;
  final int closingPoisha;
  final bool isClosed;
  final String? closedBy;
  final int? closedAt;
  final int updatedAt;
  const DailySummary(
      {required this.date,
      required this.userId,
      required this.openingPoisha,
      required this.totalInPoisha,
      required this.totalOutPoisha,
      required this.collectionPoisha,
      required this.closingPoisha,
      required this.isClosed,
      this.closedBy,
      this.closedAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['user_id'] = Variable<String>(userId);
    map['opening_poisha'] = Variable<int>(openingPoisha);
    map['total_in_poisha'] = Variable<int>(totalInPoisha);
    map['total_out_poisha'] = Variable<int>(totalOutPoisha);
    map['collection_poisha'] = Variable<int>(collectionPoisha);
    map['closing_poisha'] = Variable<int>(closingPoisha);
    map['is_closed'] = Variable<bool>(isClosed);
    if (!nullToAbsent || closedBy != null) {
      map['closed_by'] = Variable<String>(closedBy);
    }
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<int>(closedAt);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DailySummariesCompanion toCompanion(bool nullToAbsent) {
    return DailySummariesCompanion(
      date: Value(date),
      userId: Value(userId),
      openingPoisha: Value(openingPoisha),
      totalInPoisha: Value(totalInPoisha),
      totalOutPoisha: Value(totalOutPoisha),
      collectionPoisha: Value(collectionPoisha),
      closingPoisha: Value(closingPoisha),
      isClosed: Value(isClosed),
      closedBy: closedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(closedBy),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailySummary.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySummary(
      date: serializer.fromJson<String>(json['date']),
      userId: serializer.fromJson<String>(json['userId']),
      openingPoisha: serializer.fromJson<int>(json['openingPoisha']),
      totalInPoisha: serializer.fromJson<int>(json['totalInPoisha']),
      totalOutPoisha: serializer.fromJson<int>(json['totalOutPoisha']),
      collectionPoisha: serializer.fromJson<int>(json['collectionPoisha']),
      closingPoisha: serializer.fromJson<int>(json['closingPoisha']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
      closedBy: serializer.fromJson<String?>(json['closedBy']),
      closedAt: serializer.fromJson<int?>(json['closedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'userId': serializer.toJson<String>(userId),
      'openingPoisha': serializer.toJson<int>(openingPoisha),
      'totalInPoisha': serializer.toJson<int>(totalInPoisha),
      'totalOutPoisha': serializer.toJson<int>(totalOutPoisha),
      'collectionPoisha': serializer.toJson<int>(collectionPoisha),
      'closingPoisha': serializer.toJson<int>(closingPoisha),
      'isClosed': serializer.toJson<bool>(isClosed),
      'closedBy': serializer.toJson<String?>(closedBy),
      'closedAt': serializer.toJson<int?>(closedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DailySummary copyWith(
          {String? date,
          String? userId,
          int? openingPoisha,
          int? totalInPoisha,
          int? totalOutPoisha,
          int? collectionPoisha,
          int? closingPoisha,
          bool? isClosed,
          Value<String?> closedBy = const Value.absent(),
          Value<int?> closedAt = const Value.absent(),
          int? updatedAt}) =>
      DailySummary(
        date: date ?? this.date,
        userId: userId ?? this.userId,
        openingPoisha: openingPoisha ?? this.openingPoisha,
        totalInPoisha: totalInPoisha ?? this.totalInPoisha,
        totalOutPoisha: totalOutPoisha ?? this.totalOutPoisha,
        collectionPoisha: collectionPoisha ?? this.collectionPoisha,
        closingPoisha: closingPoisha ?? this.closingPoisha,
        isClosed: isClosed ?? this.isClosed,
        closedBy: closedBy.present ? closedBy.value : this.closedBy,
        closedAt: closedAt.present ? closedAt.value : this.closedAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DailySummary copyWithCompanion(DailySummariesCompanion data) {
    return DailySummary(
      date: data.date.present ? data.date.value : this.date,
      userId: data.userId.present ? data.userId.value : this.userId,
      openingPoisha: data.openingPoisha.present
          ? data.openingPoisha.value
          : this.openingPoisha,
      totalInPoisha: data.totalInPoisha.present
          ? data.totalInPoisha.value
          : this.totalInPoisha,
      totalOutPoisha: data.totalOutPoisha.present
          ? data.totalOutPoisha.value
          : this.totalOutPoisha,
      collectionPoisha: data.collectionPoisha.present
          ? data.collectionPoisha.value
          : this.collectionPoisha,
      closingPoisha: data.closingPoisha.present
          ? data.closingPoisha.value
          : this.closingPoisha,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
      closedBy: data.closedBy.present ? data.closedBy.value : this.closedBy,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySummary(')
          ..write('date: $date, ')
          ..write('userId: $userId, ')
          ..write('openingPoisha: $openingPoisha, ')
          ..write('totalInPoisha: $totalInPoisha, ')
          ..write('totalOutPoisha: $totalOutPoisha, ')
          ..write('collectionPoisha: $collectionPoisha, ')
          ..write('closingPoisha: $closingPoisha, ')
          ..write('isClosed: $isClosed, ')
          ..write('closedBy: $closedBy, ')
          ..write('closedAt: $closedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      date,
      userId,
      openingPoisha,
      totalInPoisha,
      totalOutPoisha,
      collectionPoisha,
      closingPoisha,
      isClosed,
      closedBy,
      closedAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySummary &&
          other.date == this.date &&
          other.userId == this.userId &&
          other.openingPoisha == this.openingPoisha &&
          other.totalInPoisha == this.totalInPoisha &&
          other.totalOutPoisha == this.totalOutPoisha &&
          other.collectionPoisha == this.collectionPoisha &&
          other.closingPoisha == this.closingPoisha &&
          other.isClosed == this.isClosed &&
          other.closedBy == this.closedBy &&
          other.closedAt == this.closedAt &&
          other.updatedAt == this.updatedAt);
}

class DailySummariesCompanion extends UpdateCompanion<DailySummary> {
  final Value<String> date;
  final Value<String> userId;
  final Value<int> openingPoisha;
  final Value<int> totalInPoisha;
  final Value<int> totalOutPoisha;
  final Value<int> collectionPoisha;
  final Value<int> closingPoisha;
  final Value<bool> isClosed;
  final Value<String?> closedBy;
  final Value<int?> closedAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const DailySummariesCompanion({
    this.date = const Value.absent(),
    this.userId = const Value.absent(),
    this.openingPoisha = const Value.absent(),
    this.totalInPoisha = const Value.absent(),
    this.totalOutPoisha = const Value.absent(),
    this.collectionPoisha = const Value.absent(),
    this.closingPoisha = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.closedBy = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailySummariesCompanion.insert({
    required String date,
    required String userId,
    required int openingPoisha,
    required int totalInPoisha,
    required int totalOutPoisha,
    required int collectionPoisha,
    required int closingPoisha,
    this.isClosed = const Value.absent(),
    this.closedBy = const Value.absent(),
    this.closedAt = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  })  : date = Value(date),
        userId = Value(userId),
        openingPoisha = Value(openingPoisha),
        totalInPoisha = Value(totalInPoisha),
        totalOutPoisha = Value(totalOutPoisha),
        collectionPoisha = Value(collectionPoisha),
        closingPoisha = Value(closingPoisha),
        updatedAt = Value(updatedAt);
  static Insertable<DailySummary> custom({
    Expression<String>? date,
    Expression<String>? userId,
    Expression<int>? openingPoisha,
    Expression<int>? totalInPoisha,
    Expression<int>? totalOutPoisha,
    Expression<int>? collectionPoisha,
    Expression<int>? closingPoisha,
    Expression<bool>? isClosed,
    Expression<String>? closedBy,
    Expression<int>? closedAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (userId != null) 'user_id': userId,
      if (openingPoisha != null) 'opening_poisha': openingPoisha,
      if (totalInPoisha != null) 'total_in_poisha': totalInPoisha,
      if (totalOutPoisha != null) 'total_out_poisha': totalOutPoisha,
      if (collectionPoisha != null) 'collection_poisha': collectionPoisha,
      if (closingPoisha != null) 'closing_poisha': closingPoisha,
      if (isClosed != null) 'is_closed': isClosed,
      if (closedBy != null) 'closed_by': closedBy,
      if (closedAt != null) 'closed_at': closedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailySummariesCompanion copyWith(
      {Value<String>? date,
      Value<String>? userId,
      Value<int>? openingPoisha,
      Value<int>? totalInPoisha,
      Value<int>? totalOutPoisha,
      Value<int>? collectionPoisha,
      Value<int>? closingPoisha,
      Value<bool>? isClosed,
      Value<String?>? closedBy,
      Value<int?>? closedAt,
      Value<int>? updatedAt,
      Value<int>? rowid}) {
    return DailySummariesCompanion(
      date: date ?? this.date,
      userId: userId ?? this.userId,
      openingPoisha: openingPoisha ?? this.openingPoisha,
      totalInPoisha: totalInPoisha ?? this.totalInPoisha,
      totalOutPoisha: totalOutPoisha ?? this.totalOutPoisha,
      collectionPoisha: collectionPoisha ?? this.collectionPoisha,
      closingPoisha: closingPoisha ?? this.closingPoisha,
      isClosed: isClosed ?? this.isClosed,
      closedBy: closedBy ?? this.closedBy,
      closedAt: closedAt ?? this.closedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (openingPoisha.present) {
      map['opening_poisha'] = Variable<int>(openingPoisha.value);
    }
    if (totalInPoisha.present) {
      map['total_in_poisha'] = Variable<int>(totalInPoisha.value);
    }
    if (totalOutPoisha.present) {
      map['total_out_poisha'] = Variable<int>(totalOutPoisha.value);
    }
    if (collectionPoisha.present) {
      map['collection_poisha'] = Variable<int>(collectionPoisha.value);
    }
    if (closingPoisha.present) {
      map['closing_poisha'] = Variable<int>(closingPoisha.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    if (closedBy.present) {
      map['closed_by'] = Variable<String>(closedBy.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<int>(closedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySummariesCompanion(')
          ..write('date: $date, ')
          ..write('userId: $userId, ')
          ..write('openingPoisha: $openingPoisha, ')
          ..write('totalInPoisha: $totalInPoisha, ')
          ..write('totalOutPoisha: $totalOutPoisha, ')
          ..write('collectionPoisha: $collectionPoisha, ')
          ..write('closingPoisha: $closingPoisha, ')
          ..write('isClosed: $isClosed, ')
          ..write('closedBy: $closedBy, ')
          ..write('closedAt: $closedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityMeta = const VerificationMeta('entity');
  @override
  late final GeneratedColumn<String> entity = GeneratedColumn<String>(
      'entity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actorMeta = const VerificationMeta('actor');
  @override
  late final GeneratedColumn<String> actor = GeneratedColumn<String>(
      'actor', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, entity, entityId, action, actor, reason, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(Insertable<AuditLogData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('entity')) {
      context.handle(_entityMeta,
          entity.isAcceptableOrUnknown(data['entity']!, _entityMeta));
    } else if (isInserting) {
      context.missing(_entityMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('actor')) {
      context.handle(
          _actorMeta, actor.isAcceptableOrUnknown(data['actor']!, _actorMeta));
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      entity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      actor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}actor']),
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final String id;
  final String userId;
  final String entity;
  final String entityId;
  final String action;
  final String? actor;
  final String? reason;
  final int createdAt;
  const AuditLogData(
      {required this.id,
      required this.userId,
      required this.entity,
      required this.entityId,
      required this.action,
      this.actor,
      this.reason,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['entity'] = Variable<String>(entity);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || actor != null) {
      map['actor'] = Variable<String>(actor);
    }
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      userId: Value(userId),
      entity: Value(entity),
      entityId: Value(entityId),
      action: Value(action),
      actor:
          actor == null && nullToAbsent ? const Value.absent() : Value(actor),
      reason:
          reason == null && nullToAbsent ? const Value.absent() : Value(reason),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLogData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      entity: serializer.fromJson<String>(json['entity']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      actor: serializer.fromJson<String?>(json['actor']),
      reason: serializer.fromJson<String?>(json['reason']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'entity': serializer.toJson<String>(entity),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'actor': serializer.toJson<String?>(actor),
      'reason': serializer.toJson<String?>(reason),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  AuditLogData copyWith(
          {String? id,
          String? userId,
          String? entity,
          String? entityId,
          String? action,
          Value<String?> actor = const Value.absent(),
          Value<String?> reason = const Value.absent(),
          int? createdAt}) =>
      AuditLogData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        entity: entity ?? this.entity,
        entityId: entityId ?? this.entityId,
        action: action ?? this.action,
        actor: actor.present ? actor.value : this.actor,
        reason: reason.present ? reason.value : this.reason,
        createdAt: createdAt ?? this.createdAt,
      );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      entity: data.entity.present ? data.entity.value : this.entity,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      actor: data.actor.present ? data.actor.value : this.actor,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('actor: $actor, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, entity, entityId, action, actor, reason, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.entity == this.entity &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.actor == this.actor &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> entity;
  final Value<String> entityId;
  final Value<String> action;
  final Value<String?> actor;
  final Value<String?> reason;
  final Value<int> createdAt;
  final Value<int> rowid;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.entity = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.actor = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuditLogCompanion.insert({
    required String id,
    required String userId,
    required String entity,
    required String entityId,
    required String action,
    this.actor = const Value.absent(),
    this.reason = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        entity = Value(entity),
        entityId = Value(entityId),
        action = Value(action),
        createdAt = Value(createdAt);
  static Insertable<AuditLogData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? entity,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<String>? actor,
    Expression<String>? reason,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (entity != null) 'entity': entity,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (actor != null) 'actor': actor,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuditLogCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? entity,
      Value<String>? entityId,
      Value<String>? action,
      Value<String?>? actor,
      Value<String?>? reason,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return AuditLogCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      entity: entity ?? this.entity,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      actor: actor ?? this.actor,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
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
    if (entity.present) {
      map['entity'] = Variable<String>(entity.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (actor.present) {
      map['actor'] = Variable<String>(actor.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('entity: $entity, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('actor: $actor, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BackupsTable extends Backups with TableInfo<$BackupsTable, Backup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BackupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
      'kind', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pathOrRefMeta =
      const VerificationMeta('pathOrRef');
  @override
  late final GeneratedColumn<String> pathOrRef = GeneratedColumn<String>(
      'path_or_ref', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recordCountMeta =
      const VerificationMeta('recordCount');
  @override
  late final GeneratedColumn<int> recordCount = GeneratedColumn<int>(
      'record_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _integrityOkMeta =
      const VerificationMeta('integrityOk');
  @override
  late final GeneratedColumn<bool> integrityOk = GeneratedColumn<bool>(
      'integrity_ok', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("integrity_ok" IN (0, 1))'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, kind, pathOrRef, recordCount, integrityOk, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'backups';
  @override
  VerificationContext validateIntegrity(Insertable<Backup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
          _kindMeta, kind.isAcceptableOrUnknown(data['kind']!, _kindMeta));
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('path_or_ref')) {
      context.handle(
          _pathOrRefMeta,
          pathOrRef.isAcceptableOrUnknown(
              data['path_or_ref']!, _pathOrRefMeta));
    }
    if (data.containsKey('record_count')) {
      context.handle(
          _recordCountMeta,
          recordCount.isAcceptableOrUnknown(
              data['record_count']!, _recordCountMeta));
    }
    if (data.containsKey('integrity_ok')) {
      context.handle(
          _integrityOkMeta,
          integrityOk.isAcceptableOrUnknown(
              data['integrity_ok']!, _integrityOkMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Backup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Backup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      kind: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}kind'])!,
      pathOrRef: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path_or_ref']),
      recordCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}record_count']),
      integrityOk: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}integrity_ok']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $BackupsTable createAlias(String alias) {
    return $BackupsTable(attachedDatabase, alias);
  }
}

class Backup extends DataClass implements Insertable<Backup> {
  final String id;
  final String userId;
  final String kind;
  final String? pathOrRef;
  final int? recordCount;
  final bool? integrityOk;
  final int createdAt;
  const Backup(
      {required this.id,
      required this.userId,
      required this.kind,
      this.pathOrRef,
      this.recordCount,
      this.integrityOk,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || pathOrRef != null) {
      map['path_or_ref'] = Variable<String>(pathOrRef);
    }
    if (!nullToAbsent || recordCount != null) {
      map['record_count'] = Variable<int>(recordCount);
    }
    if (!nullToAbsent || integrityOk != null) {
      map['integrity_ok'] = Variable<bool>(integrityOk);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  BackupsCompanion toCompanion(bool nullToAbsent) {
    return BackupsCompanion(
      id: Value(id),
      userId: Value(userId),
      kind: Value(kind),
      pathOrRef: pathOrRef == null && nullToAbsent
          ? const Value.absent()
          : Value(pathOrRef),
      recordCount: recordCount == null && nullToAbsent
          ? const Value.absent()
          : Value(recordCount),
      integrityOk: integrityOk == null && nullToAbsent
          ? const Value.absent()
          : Value(integrityOk),
      createdAt: Value(createdAt),
    );
  }

  factory Backup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Backup(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      kind: serializer.fromJson<String>(json['kind']),
      pathOrRef: serializer.fromJson<String?>(json['pathOrRef']),
      recordCount: serializer.fromJson<int?>(json['recordCount']),
      integrityOk: serializer.fromJson<bool?>(json['integrityOk']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'kind': serializer.toJson<String>(kind),
      'pathOrRef': serializer.toJson<String?>(pathOrRef),
      'recordCount': serializer.toJson<int?>(recordCount),
      'integrityOk': serializer.toJson<bool?>(integrityOk),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Backup copyWith(
          {String? id,
          String? userId,
          String? kind,
          Value<String?> pathOrRef = const Value.absent(),
          Value<int?> recordCount = const Value.absent(),
          Value<bool?> integrityOk = const Value.absent(),
          int? createdAt}) =>
      Backup(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        kind: kind ?? this.kind,
        pathOrRef: pathOrRef.present ? pathOrRef.value : this.pathOrRef,
        recordCount: recordCount.present ? recordCount.value : this.recordCount,
        integrityOk: integrityOk.present ? integrityOk.value : this.integrityOk,
        createdAt: createdAt ?? this.createdAt,
      );
  Backup copyWithCompanion(BackupsCompanion data) {
    return Backup(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      kind: data.kind.present ? data.kind.value : this.kind,
      pathOrRef: data.pathOrRef.present ? data.pathOrRef.value : this.pathOrRef,
      recordCount:
          data.recordCount.present ? data.recordCount.value : this.recordCount,
      integrityOk:
          data.integrityOk.present ? data.integrityOk.value : this.integrityOk,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Backup(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('kind: $kind, ')
          ..write('pathOrRef: $pathOrRef, ')
          ..write('recordCount: $recordCount, ')
          ..write('integrityOk: $integrityOk, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, userId, kind, pathOrRef, recordCount, integrityOk, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Backup &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.kind == this.kind &&
          other.pathOrRef == this.pathOrRef &&
          other.recordCount == this.recordCount &&
          other.integrityOk == this.integrityOk &&
          other.createdAt == this.createdAt);
}

class BackupsCompanion extends UpdateCompanion<Backup> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> kind;
  final Value<String?> pathOrRef;
  final Value<int?> recordCount;
  final Value<bool?> integrityOk;
  final Value<int> createdAt;
  final Value<int> rowid;
  const BackupsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.kind = const Value.absent(),
    this.pathOrRef = const Value.absent(),
    this.recordCount = const Value.absent(),
    this.integrityOk = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BackupsCompanion.insert({
    required String id,
    required String userId,
    required String kind,
    this.pathOrRef = const Value.absent(),
    this.recordCount = const Value.absent(),
    this.integrityOk = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        kind = Value(kind),
        createdAt = Value(createdAt);
  static Insertable<Backup> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? kind,
    Expression<String>? pathOrRef,
    Expression<int>? recordCount,
    Expression<bool>? integrityOk,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (kind != null) 'kind': kind,
      if (pathOrRef != null) 'path_or_ref': pathOrRef,
      if (recordCount != null) 'record_count': recordCount,
      if (integrityOk != null) 'integrity_ok': integrityOk,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BackupsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? kind,
      Value<String?>? pathOrRef,
      Value<int?>? recordCount,
      Value<bool?>? integrityOk,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return BackupsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      kind: kind ?? this.kind,
      pathOrRef: pathOrRef ?? this.pathOrRef,
      recordCount: recordCount ?? this.recordCount,
      integrityOk: integrityOk ?? this.integrityOk,
      createdAt: createdAt ?? this.createdAt,
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
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (pathOrRef.present) {
      map['path_or_ref'] = Variable<String>(pathOrRef.value);
    }
    if (recordCount.present) {
      map['record_count'] = Variable<int>(recordCount.value);
    }
    if (integrityOk.present) {
      map['integrity_ok'] = Variable<bool>(integrityOk.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BackupsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('kind: $kind, ')
          ..write('pathOrRef: $pathOrRef, ')
          ..write('recordCount: $recordCount, ')
          ..write('integrityOk: $integrityOk, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OperatorBalancesTable extends OperatorBalances
    with TableInfo<$OperatorBalancesTable, OperatorBalance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OperatorBalancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _operatorMeta =
      const VerificationMeta('operator');
  @override
  late final GeneratedColumn<String> operator = GeneratedColumn<String>(
      'operator', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _balancePoishaMeta =
      const VerificationMeta('balancePoisha');
  @override
  late final GeneratedColumn<int> balancePoisha = GeneratedColumn<int>(
      'balance_poisha', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [operator, balancePoisha, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'operator_balances';
  @override
  VerificationContext validateIntegrity(Insertable<OperatorBalance> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('operator')) {
      context.handle(_operatorMeta,
          operator.isAcceptableOrUnknown(data['operator']!, _operatorMeta));
    } else if (isInserting) {
      context.missing(_operatorMeta);
    }
    if (data.containsKey('balance_poisha')) {
      context.handle(
          _balancePoishaMeta,
          balancePoisha.isAcceptableOrUnknown(
              data['balance_poisha']!, _balancePoishaMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {operator};
  @override
  OperatorBalance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OperatorBalance(
      operator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operator'])!,
      balancePoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}balance_poisha'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $OperatorBalancesTable createAlias(String alias) {
    return $OperatorBalancesTable(attachedDatabase, alias);
  }
}

class OperatorBalance extends DataClass implements Insertable<OperatorBalance> {
  final String operator;
  final int balancePoisha;
  final String updatedAt;
  const OperatorBalance(
      {required this.operator,
      required this.balancePoisha,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['operator'] = Variable<String>(operator);
    map['balance_poisha'] = Variable<int>(balancePoisha);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  OperatorBalancesCompanion toCompanion(bool nullToAbsent) {
    return OperatorBalancesCompanion(
      operator: Value(operator),
      balancePoisha: Value(balancePoisha),
      updatedAt: Value(updatedAt),
    );
  }

  factory OperatorBalance.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OperatorBalance(
      operator: serializer.fromJson<String>(json['operator']),
      balancePoisha: serializer.fromJson<int>(json['balancePoisha']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'operator': serializer.toJson<String>(operator),
      'balancePoisha': serializer.toJson<int>(balancePoisha),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  OperatorBalance copyWith(
          {String? operator, int? balancePoisha, String? updatedAt}) =>
      OperatorBalance(
        operator: operator ?? this.operator,
        balancePoisha: balancePoisha ?? this.balancePoisha,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  OperatorBalance copyWithCompanion(OperatorBalancesCompanion data) {
    return OperatorBalance(
      operator: data.operator.present ? data.operator.value : this.operator,
      balancePoisha: data.balancePoisha.present
          ? data.balancePoisha.value
          : this.balancePoisha,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OperatorBalance(')
          ..write('operator: $operator, ')
          ..write('balancePoisha: $balancePoisha, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(operator, balancePoisha, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OperatorBalance &&
          other.operator == this.operator &&
          other.balancePoisha == this.balancePoisha &&
          other.updatedAt == this.updatedAt);
}

class OperatorBalancesCompanion extends UpdateCompanion<OperatorBalance> {
  final Value<String> operator;
  final Value<int> balancePoisha;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const OperatorBalancesCompanion({
    this.operator = const Value.absent(),
    this.balancePoisha = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OperatorBalancesCompanion.insert({
    required String operator,
    this.balancePoisha = const Value.absent(),
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : operator = Value(operator),
        updatedAt = Value(updatedAt);
  static Insertable<OperatorBalance> custom({
    Expression<String>? operator,
    Expression<int>? balancePoisha,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (operator != null) 'operator': operator,
      if (balancePoisha != null) 'balance_poisha': balancePoisha,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OperatorBalancesCompanion copyWith(
      {Value<String>? operator,
      Value<int>? balancePoisha,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return OperatorBalancesCompanion(
      operator: operator ?? this.operator,
      balancePoisha: balancePoisha ?? this.balancePoisha,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (operator.present) {
      map['operator'] = Variable<String>(operator.value);
    }
    if (balancePoisha.present) {
      map['balance_poisha'] = Variable<int>(balancePoisha.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OperatorBalancesCompanion(')
          ..write('operator: $operator, ')
          ..write('balancePoisha: $balancePoisha, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TokriRentalsTable extends TokriRentals
    with TableInfo<$TokriRentalsTable, TokriRental> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TokriRentalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tokriCountMeta =
      const VerificationMeta('tokriCount');
  @override
  late final GeneratedColumn<int> tokriCount = GeneratedColumn<int>(
      'tokri_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dailyRatePoishaMeta =
      const VerificationMeta('dailyRatePoisha');
  @override
  late final GeneratedColumn<int> dailyRatePoisha = GeneratedColumn<int>(
      'daily_rate_poisha', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, personId, tokriCount, dailyRatePoisha, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tokri_rentals';
  @override
  VerificationContext validateIntegrity(Insertable<TokriRental> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('tokri_count')) {
      context.handle(
          _tokriCountMeta,
          tokriCount.isAcceptableOrUnknown(
              data['tokri_count']!, _tokriCountMeta));
    } else if (isInserting) {
      context.missing(_tokriCountMeta);
    }
    if (data.containsKey('daily_rate_poisha')) {
      context.handle(
          _dailyRatePoishaMeta,
          dailyRatePoisha.isAcceptableOrUnknown(
              data['daily_rate_poisha']!, _dailyRatePoishaMeta));
    } else if (isInserting) {
      context.missing(_dailyRatePoishaMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TokriRental map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TokriRental(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
      tokriCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tokri_count'])!,
      dailyRatePoisha: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}daily_rate_poisha'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TokriRentalsTable createAlias(String alias) {
    return $TokriRentalsTable(attachedDatabase, alias);
  }
}

class TokriRental extends DataClass implements Insertable<TokriRental> {
  final String id;
  final String userId;
  final String personId;
  final int tokriCount;
  final int dailyRatePoisha;
  final String createdAt;
  const TokriRental(
      {required this.id,
      required this.userId,
      required this.personId,
      required this.tokriCount,
      required this.dailyRatePoisha,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['person_id'] = Variable<String>(personId);
    map['tokri_count'] = Variable<int>(tokriCount);
    map['daily_rate_poisha'] = Variable<int>(dailyRatePoisha);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  TokriRentalsCompanion toCompanion(bool nullToAbsent) {
    return TokriRentalsCompanion(
      id: Value(id),
      userId: Value(userId),
      personId: Value(personId),
      tokriCount: Value(tokriCount),
      dailyRatePoisha: Value(dailyRatePoisha),
      createdAt: Value(createdAt),
    );
  }

  factory TokriRental.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TokriRental(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      personId: serializer.fromJson<String>(json['personId']),
      tokriCount: serializer.fromJson<int>(json['tokriCount']),
      dailyRatePoisha: serializer.fromJson<int>(json['dailyRatePoisha']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'personId': serializer.toJson<String>(personId),
      'tokriCount': serializer.toJson<int>(tokriCount),
      'dailyRatePoisha': serializer.toJson<int>(dailyRatePoisha),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  TokriRental copyWith(
          {String? id,
          String? userId,
          String? personId,
          int? tokriCount,
          int? dailyRatePoisha,
          String? createdAt}) =>
      TokriRental(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        personId: personId ?? this.personId,
        tokriCount: tokriCount ?? this.tokriCount,
        dailyRatePoisha: dailyRatePoisha ?? this.dailyRatePoisha,
        createdAt: createdAt ?? this.createdAt,
      );
  TokriRental copyWithCompanion(TokriRentalsCompanion data) {
    return TokriRental(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      personId: data.personId.present ? data.personId.value : this.personId,
      tokriCount:
          data.tokriCount.present ? data.tokriCount.value : this.tokriCount,
      dailyRatePoisha: data.dailyRatePoisha.present
          ? data.dailyRatePoisha.value
          : this.dailyRatePoisha,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TokriRental(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('personId: $personId, ')
          ..write('tokriCount: $tokriCount, ')
          ..write('dailyRatePoisha: $dailyRatePoisha, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, personId, tokriCount, dailyRatePoisha, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TokriRental &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.personId == this.personId &&
          other.tokriCount == this.tokriCount &&
          other.dailyRatePoisha == this.dailyRatePoisha &&
          other.createdAt == this.createdAt);
}

class TokriRentalsCompanion extends UpdateCompanion<TokriRental> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> personId;
  final Value<int> tokriCount;
  final Value<int> dailyRatePoisha;
  final Value<String> createdAt;
  final Value<int> rowid;
  const TokriRentalsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.personId = const Value.absent(),
    this.tokriCount = const Value.absent(),
    this.dailyRatePoisha = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TokriRentalsCompanion.insert({
    required String id,
    required String userId,
    required String personId,
    required int tokriCount,
    required int dailyRatePoisha,
    required String createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        personId = Value(personId),
        tokriCount = Value(tokriCount),
        dailyRatePoisha = Value(dailyRatePoisha),
        createdAt = Value(createdAt);
  static Insertable<TokriRental> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? personId,
    Expression<int>? tokriCount,
    Expression<int>? dailyRatePoisha,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (personId != null) 'person_id': personId,
      if (tokriCount != null) 'tokri_count': tokriCount,
      if (dailyRatePoisha != null) 'daily_rate_poisha': dailyRatePoisha,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TokriRentalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? personId,
      Value<int>? tokriCount,
      Value<int>? dailyRatePoisha,
      Value<String>? createdAt,
      Value<int>? rowid}) {
    return TokriRentalsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      personId: personId ?? this.personId,
      tokriCount: tokriCount ?? this.tokriCount,
      dailyRatePoisha: dailyRatePoisha ?? this.dailyRatePoisha,
      createdAt: createdAt ?? this.createdAt,
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
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (tokriCount.present) {
      map['tokri_count'] = Variable<int>(tokriCount.value);
    }
    if (dailyRatePoisha.present) {
      map['daily_rate_poisha'] = Variable<int>(dailyRatePoisha.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TokriRentalsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('personId: $personId, ')
          ..write('tokriCount: $tokriCount, ')
          ..write('dailyRatePoisha: $dailyRatePoisha, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TokriAttendanceTable extends TokriAttendance
    with TableInfo<$TokriAttendanceTable, TokriAttendanceData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TokriAttendanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rentalIdMeta =
      const VerificationMeta('rentalId');
  @override
  late final GeneratedColumn<String> rentalId = GeneratedColumn<String>(
      'rental_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _businessDateMeta =
      const VerificationMeta('businessDate');
  @override
  late final GeneratedColumn<String> businessDate = GeneratedColumn<String>(
      'business_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [userId, rentalId, businessDate, status];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tokri_attendance';
  @override
  VerificationContext validateIntegrity(
      Insertable<TokriAttendanceData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('rental_id')) {
      context.handle(_rentalIdMeta,
          rentalId.isAcceptableOrUnknown(data['rental_id']!, _rentalIdMeta));
    } else if (isInserting) {
      context.missing(_rentalIdMeta);
    }
    if (data.containsKey('business_date')) {
      context.handle(
          _businessDateMeta,
          businessDate.isAcceptableOrUnknown(
              data['business_date']!, _businessDateMeta));
    } else if (isInserting) {
      context.missing(_businessDateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rentalId, businessDate};
  @override
  TokriAttendanceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TokriAttendanceData(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      rentalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rental_id'])!,
      businessDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}business_date'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
    );
  }

  @override
  $TokriAttendanceTable createAlias(String alias) {
    return $TokriAttendanceTable(attachedDatabase, alias);
  }
}

class TokriAttendanceData extends DataClass
    implements Insertable<TokriAttendanceData> {
  final String userId;
  final String rentalId;
  final String businessDate;
  final String status;
  const TokriAttendanceData(
      {required this.userId,
      required this.rentalId,
      required this.businessDate,
      required this.status});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['rental_id'] = Variable<String>(rentalId);
    map['business_date'] = Variable<String>(businessDate);
    map['status'] = Variable<String>(status);
    return map;
  }

  TokriAttendanceCompanion toCompanion(bool nullToAbsent) {
    return TokriAttendanceCompanion(
      userId: Value(userId),
      rentalId: Value(rentalId),
      businessDate: Value(businessDate),
      status: Value(status),
    );
  }

  factory TokriAttendanceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TokriAttendanceData(
      userId: serializer.fromJson<String>(json['userId']),
      rentalId: serializer.fromJson<String>(json['rentalId']),
      businessDate: serializer.fromJson<String>(json['businessDate']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'rentalId': serializer.toJson<String>(rentalId),
      'businessDate': serializer.toJson<String>(businessDate),
      'status': serializer.toJson<String>(status),
    };
  }

  TokriAttendanceData copyWith(
          {String? userId,
          String? rentalId,
          String? businessDate,
          String? status}) =>
      TokriAttendanceData(
        userId: userId ?? this.userId,
        rentalId: rentalId ?? this.rentalId,
        businessDate: businessDate ?? this.businessDate,
        status: status ?? this.status,
      );
  TokriAttendanceData copyWithCompanion(TokriAttendanceCompanion data) {
    return TokriAttendanceData(
      userId: data.userId.present ? data.userId.value : this.userId,
      rentalId: data.rentalId.present ? data.rentalId.value : this.rentalId,
      businessDate: data.businessDate.present
          ? data.businessDate.value
          : this.businessDate,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TokriAttendanceData(')
          ..write('userId: $userId, ')
          ..write('rentalId: $rentalId, ')
          ..write('businessDate: $businessDate, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, rentalId, businessDate, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TokriAttendanceData &&
          other.userId == this.userId &&
          other.rentalId == this.rentalId &&
          other.businessDate == this.businessDate &&
          other.status == this.status);
}

class TokriAttendanceCompanion extends UpdateCompanion<TokriAttendanceData> {
  final Value<String> userId;
  final Value<String> rentalId;
  final Value<String> businessDate;
  final Value<String> status;
  final Value<int> rowid;
  const TokriAttendanceCompanion({
    this.userId = const Value.absent(),
    this.rentalId = const Value.absent(),
    this.businessDate = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TokriAttendanceCompanion.insert({
    required String userId,
    required String rentalId,
    required String businessDate,
    required String status,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        rentalId = Value(rentalId),
        businessDate = Value(businessDate),
        status = Value(status);
  static Insertable<TokriAttendanceData> custom({
    Expression<String>? userId,
    Expression<String>? rentalId,
    Expression<String>? businessDate,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (rentalId != null) 'rental_id': rentalId,
      if (businessDate != null) 'business_date': businessDate,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TokriAttendanceCompanion copyWith(
      {Value<String>? userId,
      Value<String>? rentalId,
      Value<String>? businessDate,
      Value<String>? status,
      Value<int>? rowid}) {
    return TokriAttendanceCompanion(
      userId: userId ?? this.userId,
      rentalId: rentalId ?? this.rentalId,
      businessDate: businessDate ?? this.businessDate,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (rentalId.present) {
      map['rental_id'] = Variable<String>(rentalId.value);
    }
    if (businessDate.present) {
      map['business_date'] = Variable<String>(businessDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TokriAttendanceCompanion(')
          ..write('userId: $userId, ')
          ..write('rentalId: $rentalId, ')
          ..write('businessDate: $businessDate, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SomityMembersTable extends SomityMembers
    with TableInfo<$SomityMembersTable, SomityMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SomityMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [userId, personId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'somity_members';
  @override
  VerificationContext validateIntegrity(Insertable<SomityMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, personId};
  @override
  SomityMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SomityMember(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
    );
  }

  @override
  $SomityMembersTable createAlias(String alias) {
    return $SomityMembersTable(attachedDatabase, alias);
  }
}

class SomityMember extends DataClass implements Insertable<SomityMember> {
  final String userId;
  final String personId;
  const SomityMember({required this.userId, required this.personId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['person_id'] = Variable<String>(personId);
    return map;
  }

  SomityMembersCompanion toCompanion(bool nullToAbsent) {
    return SomityMembersCompanion(
      userId: Value(userId),
      personId: Value(personId),
    );
  }

  factory SomityMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SomityMember(
      userId: serializer.fromJson<String>(json['userId']),
      personId: serializer.fromJson<String>(json['personId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'personId': serializer.toJson<String>(personId),
    };
  }

  SomityMember copyWith({String? userId, String? personId}) => SomityMember(
        userId: userId ?? this.userId,
        personId: personId ?? this.personId,
      );
  SomityMember copyWithCompanion(SomityMembersCompanion data) {
    return SomityMember(
      userId: data.userId.present ? data.userId.value : this.userId,
      personId: data.personId.present ? data.personId.value : this.personId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SomityMember(')
          ..write('userId: $userId, ')
          ..write('personId: $personId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, personId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SomityMember &&
          other.userId == this.userId &&
          other.personId == this.personId);
}

class SomityMembersCompanion extends UpdateCompanion<SomityMember> {
  final Value<String> userId;
  final Value<String> personId;
  final Value<int> rowid;
  const SomityMembersCompanion({
    this.userId = const Value.absent(),
    this.personId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SomityMembersCompanion.insert({
    required String userId,
    required String personId,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        personId = Value(personId);
  static Insertable<SomityMember> custom({
    Expression<String>? userId,
    Expression<String>? personId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (personId != null) 'person_id': personId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SomityMembersCompanion copyWith(
      {Value<String>? userId, Value<String>? personId, Value<int>? rowid}) {
    return SomityMembersCompanion(
      userId: userId ?? this.userId,
      personId: personId ?? this.personId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SomityMembersCompanion(')
          ..write('userId: $userId, ')
          ..write('personId: $personId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
      'json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [userId, json, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppSettingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
          _jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  AppSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsTableData(
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      json: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingsTableData extends DataClass
    implements Insertable<AppSettingsTableData> {
  final String userId;
  final String json;
  final String updatedAt;
  const AppSettingsTableData(
      {required this.userId, required this.json, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['json'] = Variable<String>(json);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      userId: Value(userId),
      json: Value(json),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsTableData(
      userId: serializer.fromJson<String>(json['userId']),
      json: serializer.fromJson<String>(json['json']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'json': serializer.toJson<String>(json),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  AppSettingsTableData copyWith(
          {String? userId, String? json, String? updatedAt}) =>
      AppSettingsTableData(
        userId: userId ?? this.userId,
        json: json ?? this.json,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSettingsTableData copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingsTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      json: data.json.present ? data.json.value : this.json,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableData(')
          ..write('userId: $userId, ')
          ..write('json: $json, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, json, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsTableData &&
          other.userId == this.userId &&
          other.json == this.json &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingsTableData> {
  final Value<String> userId;
  final Value<String> json;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.userId = const Value.absent(),
    this.json = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required String userId,
    required String json,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : userId = Value(userId),
        json = Value(json),
        updatedAt = Value(updatedAt);
  static Insertable<AppSettingsTableData> custom({
    Expression<String>? userId,
    Expression<String>? json,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (json != null) 'json': json,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith(
      {Value<String>? userId,
      Value<String>? json,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return AppSettingsTableCompanion(
      userId: userId ?? this.userId,
      json: json ?? this.json,
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
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('userId: $userId, ')
          ..write('json: $json, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FaceEnrollmentsTable extends FaceEnrollments
    with TableInfo<$FaceEnrollmentsTable, FaceEnrollment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FaceEnrollmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _personIdMeta =
      const VerificationMeta('personId');
  @override
  late final GeneratedColumn<String> personId = GeneratedColumn<String>(
      'person_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
      'json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [personId, json, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'face_enrollments';
  @override
  VerificationContext validateIntegrity(Insertable<FaceEnrollment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('person_id')) {
      context.handle(_personIdMeta,
          personId.isAcceptableOrUnknown(data['person_id']!, _personIdMeta));
    } else if (isInserting) {
      context.missing(_personIdMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
          _jsonMeta, json.isAcceptableOrUnknown(data['json']!, _jsonMeta));
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {personId};
  @override
  FaceEnrollment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FaceEnrollment(
      personId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}person_id'])!,
      json: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FaceEnrollmentsTable createAlias(String alias) {
    return $FaceEnrollmentsTable(attachedDatabase, alias);
  }
}

class FaceEnrollment extends DataClass implements Insertable<FaceEnrollment> {
  final String personId;
  final String json;
  final String updatedAt;
  const FaceEnrollment(
      {required this.personId, required this.json, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['person_id'] = Variable<String>(personId);
    map['json'] = Variable<String>(json);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  FaceEnrollmentsCompanion toCompanion(bool nullToAbsent) {
    return FaceEnrollmentsCompanion(
      personId: Value(personId),
      json: Value(json),
      updatedAt: Value(updatedAt),
    );
  }

  factory FaceEnrollment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FaceEnrollment(
      personId: serializer.fromJson<String>(json['personId']),
      json: serializer.fromJson<String>(json['json']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'personId': serializer.toJson<String>(personId),
      'json': serializer.toJson<String>(json),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  FaceEnrollment copyWith(
          {String? personId, String? json, String? updatedAt}) =>
      FaceEnrollment(
        personId: personId ?? this.personId,
        json: json ?? this.json,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FaceEnrollment copyWithCompanion(FaceEnrollmentsCompanion data) {
    return FaceEnrollment(
      personId: data.personId.present ? data.personId.value : this.personId,
      json: data.json.present ? data.json.value : this.json,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FaceEnrollment(')
          ..write('personId: $personId, ')
          ..write('json: $json, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(personId, json, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FaceEnrollment &&
          other.personId == this.personId &&
          other.json == this.json &&
          other.updatedAt == this.updatedAt);
}

class FaceEnrollmentsCompanion extends UpdateCompanion<FaceEnrollment> {
  final Value<String> personId;
  final Value<String> json;
  final Value<String> updatedAt;
  final Value<int> rowid;
  const FaceEnrollmentsCompanion({
    this.personId = const Value.absent(),
    this.json = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FaceEnrollmentsCompanion.insert({
    required String personId,
    required String json,
    required String updatedAt,
    this.rowid = const Value.absent(),
  })  : personId = Value(personId),
        json = Value(json),
        updatedAt = Value(updatedAt);
  static Insertable<FaceEnrollment> custom({
    Expression<String>? personId,
    Expression<String>? json,
    Expression<String>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (personId != null) 'person_id': personId,
      if (json != null) 'json': json,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FaceEnrollmentsCompanion copyWith(
      {Value<String>? personId,
      Value<String>? json,
      Value<String>? updatedAt,
      Value<int>? rowid}) {
    return FaceEnrollmentsCompanion(
      personId: personId ?? this.personId,
      json: json ?? this.json,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (personId.present) {
      map['person_id'] = Variable<String>(personId.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FaceEnrollmentsCompanion(')
          ..write('personId: $personId, ')
          ..write('json: $json, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PersonsTable persons = $PersonsTable(this);
  late final $CollectionSchedulesTable collectionSchedules =
      $CollectionSchedulesTable(this);
  late final $CollectionObligationsTable collectionObligations =
      $CollectionObligationsTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $PaymentAllocationsTable paymentAllocations =
      $PaymentAllocationsTable(this);
  late final $LedgerEntriesTable ledgerEntries = $LedgerEntriesTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $SyncQueueEntriesTable syncQueueEntries =
      $SyncQueueEntriesTable(this);
  late final $DailySummariesTable dailySummaries = $DailySummariesTable(this);
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  late final $BackupsTable backups = $BackupsTable(this);
  late final $OperatorBalancesTable operatorBalances =
      $OperatorBalancesTable(this);
  late final $TokriRentalsTable tokriRentals = $TokriRentalsTable(this);
  late final $TokriAttendanceTable tokriAttendance =
      $TokriAttendanceTable(this);
  late final $SomityMembersTable somityMembers = $SomityMembersTable(this);
  late final $AppSettingsTableTable appSettingsTable =
      $AppSettingsTableTable(this);
  late final $FaceEnrollmentsTable faceEnrollments =
      $FaceEnrollmentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        persons,
        collectionSchedules,
        collectionObligations,
        payments,
        paymentAllocations,
        ledgerEntries,
        accounts,
        syncQueueEntries,
        dailySummaries,
        auditLog,
        backups,
        operatorBalances,
        tokriRentals,
        tokriAttendance,
        somityMembers,
        appSettingsTable,
        faceEnrollments
      ];
}

typedef $$PersonsTableCreateCompanionBuilder = PersonsCompanion Function({
  required String userId,
  required int createdAt,
  required int updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  required String id,
  required String name,
  Value<String?> mobile,
  Value<String?> photoPath,
  Value<String?> address,
  Value<String> personType,
  Value<int> rowid,
});
typedef $$PersonsTableUpdateCompanionBuilder = PersonsCompanion Function({
  Value<String> userId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  Value<String> id,
  Value<String> name,
  Value<String?> mobile,
  Value<String?> photoPath,
  Value<String?> address,
  Value<String> personType,
  Value<int> rowid,
});

final class $$PersonsTableReferences
    extends BaseReferences<_$AppDatabase, $PersonsTable, Person> {
  $$PersonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CollectionSchedulesTable,
      List<CollectionSchedule>> _collectionSchedulesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.collectionSchedules,
          aliasName: $_aliasNameGenerator(
              db.persons.id, db.collectionSchedules.personId));

  $$CollectionSchedulesTableProcessedTableManager get collectionSchedulesRefs {
    final manager = $$CollectionSchedulesTableTableManager(
            $_db, $_db.collectionSchedules)
        .filter((f) => f.personId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_collectionSchedulesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$CollectionObligationsTable,
      List<CollectionObligation>> _collectionObligationsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.collectionObligations,
          aliasName: $_aliasNameGenerator(
              db.persons.id, db.collectionObligations.personId));

  $$CollectionObligationsTableProcessedTableManager
      get collectionObligationsRefs {
    final manager = $$CollectionObligationsTableTableManager(
            $_db, $_db.collectionObligations)
        .filter((f) => f.personId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_collectionObligationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PaymentsTable, List<Payment>> _paymentsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.payments,
          aliasName: $_aliasNameGenerator(db.persons.id, db.payments.personId));

  $$PaymentsTableProcessedTableManager get paymentsRefs {
    final manager = $$PaymentsTableTableManager($_db, $_db.payments)
        .filter((f) => f.personId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PersonsTableFilterComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personType => $composableBuilder(
      column: $table.personType, builder: (column) => ColumnFilters(column));

  Expression<bool> collectionSchedulesRefs(
      Expression<bool> Function($$CollectionSchedulesTableFilterComposer f) f) {
    final $$CollectionSchedulesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.collectionSchedules,
        getReferencedColumn: (t) => t.personId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CollectionSchedulesTableFilterComposer(
              $db: $db,
              $table: $db.collectionSchedules,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> collectionObligationsRefs(
      Expression<bool> Function($$CollectionObligationsTableFilterComposer f)
          f) {
    final $$CollectionObligationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.collectionObligations,
            getReferencedColumn: (t) => t.personId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CollectionObligationsTableFilterComposer(
                  $db: $db,
                  $table: $db.collectionObligations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<bool> paymentsRefs(
      Expression<bool> Function($$PaymentsTableFilterComposer f) f) {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.personId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableFilterComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PersonsTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localVersion => $composableBuilder(
      column: $table.localVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoPath => $composableBuilder(
      column: $table.photoPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personType => $composableBuilder(
      column: $table.personType, builder: (column) => ColumnOrderings(column));
}

class $$PersonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonsTable> {
  $$PersonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get personType => $composableBuilder(
      column: $table.personType, builder: (column) => column);

  Expression<T> collectionSchedulesRefs<T extends Object>(
      Expression<T> Function($$CollectionSchedulesTableAnnotationComposer a)
          f) {
    final $$CollectionSchedulesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.collectionSchedules,
            getReferencedColumn: (t) => t.personId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CollectionSchedulesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.collectionSchedules,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> collectionObligationsRefs<T extends Object>(
      Expression<T> Function($$CollectionObligationsTableAnnotationComposer a)
          f) {
    final $$CollectionObligationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.collectionObligations,
            getReferencedColumn: (t) => t.personId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CollectionObligationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.collectionObligations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> paymentsRefs<T extends Object>(
      Expression<T> Function($$PaymentsTableAnnotationComposer a) f) {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.personId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PersonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PersonsTable,
    Person,
    $$PersonsTableFilterComposer,
    $$PersonsTableOrderingComposer,
    $$PersonsTableAnnotationComposer,
    $$PersonsTableCreateCompanionBuilder,
    $$PersonsTableUpdateCompanionBuilder,
    (Person, $$PersonsTableReferences),
    Person,
    PrefetchHooks Function(
        {bool collectionSchedulesRefs,
        bool collectionObligationsRefs,
        bool paymentsRefs})> {
  $$PersonsTableTableManager(_$AppDatabase db, $PersonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> mobile = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String> personType = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsCompanion(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            name: name,
            mobile: mobile,
            photoPath: photoPath,
            address: address,
            personType: personType,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required int createdAt,
            required int updatedAt,
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            required String id,
            required String name,
            Value<String?> mobile = const Value.absent(),
            Value<String?> photoPath = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String> personType = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PersonsCompanion.insert(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            name: name,
            mobile: mobile,
            photoPath: photoPath,
            address: address,
            personType: personType,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PersonsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {collectionSchedulesRefs = false,
              collectionObligationsRefs = false,
              paymentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (collectionSchedulesRefs) db.collectionSchedules,
                if (collectionObligationsRefs) db.collectionObligations,
                if (paymentsRefs) db.payments
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (collectionSchedulesRefs)
                    await $_getPrefetchedData<Person, $PersonsTable,
                            CollectionSchedule>(
                        currentTable: table,
                        referencedTable: $$PersonsTableReferences
                            ._collectionSchedulesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonsTableReferences(db, table, p0)
                                .collectionSchedulesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.personId == item.id),
                        typedResults: items),
                  if (collectionObligationsRefs)
                    await $_getPrefetchedData<Person, $PersonsTable,
                            CollectionObligation>(
                        currentTable: table,
                        referencedTable: $$PersonsTableReferences
                            ._collectionObligationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonsTableReferences(db, table, p0)
                                .collectionObligationsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.personId == item.id),
                        typedResults: items),
                  if (paymentsRefs)
                    await $_getPrefetchedData<Person, $PersonsTable, Payment>(
                        currentTable: table,
                        referencedTable:
                            $$PersonsTableReferences._paymentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PersonsTableReferences(db, table, p0)
                                .paymentsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.personId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PersonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PersonsTable,
    Person,
    $$PersonsTableFilterComposer,
    $$PersonsTableOrderingComposer,
    $$PersonsTableAnnotationComposer,
    $$PersonsTableCreateCompanionBuilder,
    $$PersonsTableUpdateCompanionBuilder,
    (Person, $$PersonsTableReferences),
    Person,
    PrefetchHooks Function(
        {bool collectionSchedulesRefs,
        bool collectionObligationsRefs,
        bool paymentsRefs})>;
typedef $$CollectionSchedulesTableCreateCompanionBuilder
    = CollectionSchedulesCompanion Function({
  required String userId,
  required int createdAt,
  required int updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  required String id,
  required String personId,
  required int expectedPoisha,
  required String scheduleType,
  required String startDate,
  Value<String?> endDate,
  Value<String?> weekdays,
  Value<int?> dayOfMonth,
  Value<int> graceDays,
  Value<bool> allowAdvance,
  Value<bool> paused,
  required String effectiveFrom,
  Value<int> rowid,
});
typedef $$CollectionSchedulesTableUpdateCompanionBuilder
    = CollectionSchedulesCompanion Function({
  Value<String> userId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  Value<String> id,
  Value<String> personId,
  Value<int> expectedPoisha,
  Value<String> scheduleType,
  Value<String> startDate,
  Value<String?> endDate,
  Value<String?> weekdays,
  Value<int?> dayOfMonth,
  Value<int> graceDays,
  Value<bool> allowAdvance,
  Value<bool> paused,
  Value<String> effectiveFrom,
  Value<int> rowid,
});

final class $$CollectionSchedulesTableReferences extends BaseReferences<
    _$AppDatabase, $CollectionSchedulesTable, CollectionSchedule> {
  $$CollectionSchedulesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PersonsTable _personIdTable(_$AppDatabase db) =>
      db.persons.createAlias(
          $_aliasNameGenerator(db.collectionSchedules.personId, db.persons.id));

  $$PersonsTableProcessedTableManager get personId {
    final $_column = $_itemColumn<String>('person_id')!;

    final manager = $$PersonsTableTableManager($_db, $_db.persons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$CollectionSchedulesTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionSchedulesTable> {
  $$CollectionSchedulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedPoisha => $composableBuilder(
      column: $table.expectedPoisha,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get weekdays => $composableBuilder(
      column: $table.weekdays, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get graceDays => $composableBuilder(
      column: $table.graceDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get allowAdvance => $composableBuilder(
      column: $table.allowAdvance, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get paused => $composableBuilder(
      column: $table.paused, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom, builder: (column) => ColumnFilters(column));

  $$PersonsTableFilterComposer get personId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableFilterComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CollectionSchedulesTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionSchedulesTable> {
  $$CollectionSchedulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localVersion => $composableBuilder(
      column: $table.localVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedPoisha => $composableBuilder(
      column: $table.expectedPoisha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get weekdays => $composableBuilder(
      column: $table.weekdays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get graceDays => $composableBuilder(
      column: $table.graceDays, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get allowAdvance => $composableBuilder(
      column: $table.allowAdvance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get paused => $composableBuilder(
      column: $table.paused, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom,
      builder: (column) => ColumnOrderings(column));

  $$PersonsTableOrderingComposer get personId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableOrderingComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CollectionSchedulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionSchedulesTable> {
  $$CollectionSchedulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get expectedPoisha => $composableBuilder(
      column: $table.expectedPoisha, builder: (column) => column);

  GeneratedColumn<String> get scheduleType => $composableBuilder(
      column: $table.scheduleType, builder: (column) => column);

  GeneratedColumn<String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
      column: $table.dayOfMonth, builder: (column) => column);

  GeneratedColumn<int> get graceDays =>
      $composableBuilder(column: $table.graceDays, builder: (column) => column);

  GeneratedColumn<bool> get allowAdvance => $composableBuilder(
      column: $table.allowAdvance, builder: (column) => column);

  GeneratedColumn<bool> get paused =>
      $composableBuilder(column: $table.paused, builder: (column) => column);

  GeneratedColumn<String> get effectiveFrom => $composableBuilder(
      column: $table.effectiveFrom, builder: (column) => column);

  $$PersonsTableAnnotationComposer get personId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableAnnotationComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CollectionSchedulesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CollectionSchedulesTable,
    CollectionSchedule,
    $$CollectionSchedulesTableFilterComposer,
    $$CollectionSchedulesTableOrderingComposer,
    $$CollectionSchedulesTableAnnotationComposer,
    $$CollectionSchedulesTableCreateCompanionBuilder,
    $$CollectionSchedulesTableUpdateCompanionBuilder,
    (CollectionSchedule, $$CollectionSchedulesTableReferences),
    CollectionSchedule,
    PrefetchHooks Function({bool personId})> {
  $$CollectionSchedulesTableTableManager(
      _$AppDatabase db, $CollectionSchedulesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionSchedulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionSchedulesTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionSchedulesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> personId = const Value.absent(),
            Value<int> expectedPoisha = const Value.absent(),
            Value<String> scheduleType = const Value.absent(),
            Value<String> startDate = const Value.absent(),
            Value<String?> endDate = const Value.absent(),
            Value<String?> weekdays = const Value.absent(),
            Value<int?> dayOfMonth = const Value.absent(),
            Value<int> graceDays = const Value.absent(),
            Value<bool> allowAdvance = const Value.absent(),
            Value<bool> paused = const Value.absent(),
            Value<String> effectiveFrom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectionSchedulesCompanion(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            personId: personId,
            expectedPoisha: expectedPoisha,
            scheduleType: scheduleType,
            startDate: startDate,
            endDate: endDate,
            weekdays: weekdays,
            dayOfMonth: dayOfMonth,
            graceDays: graceDays,
            allowAdvance: allowAdvance,
            paused: paused,
            effectiveFrom: effectiveFrom,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required int createdAt,
            required int updatedAt,
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            required String id,
            required String personId,
            required int expectedPoisha,
            required String scheduleType,
            required String startDate,
            Value<String?> endDate = const Value.absent(),
            Value<String?> weekdays = const Value.absent(),
            Value<int?> dayOfMonth = const Value.absent(),
            Value<int> graceDays = const Value.absent(),
            Value<bool> allowAdvance = const Value.absent(),
            Value<bool> paused = const Value.absent(),
            required String effectiveFrom,
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectionSchedulesCompanion.insert(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            personId: personId,
            expectedPoisha: expectedPoisha,
            scheduleType: scheduleType,
            startDate: startDate,
            endDate: endDate,
            weekdays: weekdays,
            dayOfMonth: dayOfMonth,
            graceDays: graceDays,
            allowAdvance: allowAdvance,
            paused: paused,
            effectiveFrom: effectiveFrom,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CollectionSchedulesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({personId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (personId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personId,
                    referencedTable:
                        $$CollectionSchedulesTableReferences._personIdTable(db),
                    referencedColumn: $$CollectionSchedulesTableReferences
                        ._personIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$CollectionSchedulesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CollectionSchedulesTable,
    CollectionSchedule,
    $$CollectionSchedulesTableFilterComposer,
    $$CollectionSchedulesTableOrderingComposer,
    $$CollectionSchedulesTableAnnotationComposer,
    $$CollectionSchedulesTableCreateCompanionBuilder,
    $$CollectionSchedulesTableUpdateCompanionBuilder,
    (CollectionSchedule, $$CollectionSchedulesTableReferences),
    CollectionSchedule,
    PrefetchHooks Function({bool personId})>;
typedef $$CollectionObligationsTableCreateCompanionBuilder
    = CollectionObligationsCompanion Function({
  required String userId,
  required int createdAt,
  required int updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  required String id,
  required String personId,
  required String scheduleId,
  required String date,
  required int expectedPoisha,
  Value<int> paidPoisha,
  Value<bool> isHoliday,
  Value<String?> lastAllocationDate,
  Value<int> rowid,
});
typedef $$CollectionObligationsTableUpdateCompanionBuilder
    = CollectionObligationsCompanion Function({
  Value<String> userId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  Value<String> id,
  Value<String> personId,
  Value<String> scheduleId,
  Value<String> date,
  Value<int> expectedPoisha,
  Value<int> paidPoisha,
  Value<bool> isHoliday,
  Value<String?> lastAllocationDate,
  Value<int> rowid,
});

final class $$CollectionObligationsTableReferences extends BaseReferences<
    _$AppDatabase, $CollectionObligationsTable, CollectionObligation> {
  $$CollectionObligationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PersonsTable _personIdTable(_$AppDatabase db) =>
      db.persons.createAlias($_aliasNameGenerator(
          db.collectionObligations.personId, db.persons.id));

  $$PersonsTableProcessedTableManager get personId {
    final $_column = $_itemColumn<String>('person_id')!;

    final manager = $$PersonsTableTableManager($_db, $_db.persons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PaymentAllocationsTable, List<PaymentAllocation>>
      _paymentAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.paymentAllocations,
              aliasName: $_aliasNameGenerator(db.collectionObligations.id,
                  db.paymentAllocations.obligationId));

  $$PaymentAllocationsTableProcessedTableManager get paymentAllocationsRefs {
    final manager = $$PaymentAllocationsTableTableManager(
            $_db, $_db.paymentAllocations)
        .filter(
            (f) => f.obligationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_paymentAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CollectionObligationsTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionObligationsTable> {
  $$CollectionObligationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedPoisha => $composableBuilder(
      column: $table.expectedPoisha,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get paidPoisha => $composableBuilder(
      column: $table.paidPoisha, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHoliday => $composableBuilder(
      column: $table.isHoliday, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastAllocationDate => $composableBuilder(
      column: $table.lastAllocationDate,
      builder: (column) => ColumnFilters(column));

  $$PersonsTableFilterComposer get personId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableFilterComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> paymentAllocationsRefs(
      Expression<bool> Function($$PaymentAllocationsTableFilterComposer f) f) {
    final $$PaymentAllocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.paymentAllocations,
        getReferencedColumn: (t) => t.obligationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentAllocationsTableFilterComposer(
              $db: $db,
              $table: $db.paymentAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CollectionObligationsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionObligationsTable> {
  $$CollectionObligationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localVersion => $composableBuilder(
      column: $table.localVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedPoisha => $composableBuilder(
      column: $table.expectedPoisha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get paidPoisha => $composableBuilder(
      column: $table.paidPoisha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHoliday => $composableBuilder(
      column: $table.isHoliday, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastAllocationDate => $composableBuilder(
      column: $table.lastAllocationDate,
      builder: (column) => ColumnOrderings(column));

  $$PersonsTableOrderingComposer get personId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableOrderingComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CollectionObligationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionObligationsTable> {
  $$CollectionObligationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scheduleId => $composableBuilder(
      column: $table.scheduleId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get expectedPoisha => $composableBuilder(
      column: $table.expectedPoisha, builder: (column) => column);

  GeneratedColumn<int> get paidPoisha => $composableBuilder(
      column: $table.paidPoisha, builder: (column) => column);

  GeneratedColumn<bool> get isHoliday =>
      $composableBuilder(column: $table.isHoliday, builder: (column) => column);

  GeneratedColumn<String> get lastAllocationDate => $composableBuilder(
      column: $table.lastAllocationDate, builder: (column) => column);

  $$PersonsTableAnnotationComposer get personId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableAnnotationComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> paymentAllocationsRefs<T extends Object>(
      Expression<T> Function($$PaymentAllocationsTableAnnotationComposer a) f) {
    final $$PaymentAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.paymentAllocations,
            getReferencedColumn: (t) => t.obligationId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PaymentAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.paymentAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$CollectionObligationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CollectionObligationsTable,
    CollectionObligation,
    $$CollectionObligationsTableFilterComposer,
    $$CollectionObligationsTableOrderingComposer,
    $$CollectionObligationsTableAnnotationComposer,
    $$CollectionObligationsTableCreateCompanionBuilder,
    $$CollectionObligationsTableUpdateCompanionBuilder,
    (CollectionObligation, $$CollectionObligationsTableReferences),
    CollectionObligation,
    PrefetchHooks Function({bool personId, bool paymentAllocationsRefs})> {
  $$CollectionObligationsTableTableManager(
      _$AppDatabase db, $CollectionObligationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionObligationsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionObligationsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionObligationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> personId = const Value.absent(),
            Value<String> scheduleId = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<int> expectedPoisha = const Value.absent(),
            Value<int> paidPoisha = const Value.absent(),
            Value<bool> isHoliday = const Value.absent(),
            Value<String?> lastAllocationDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectionObligationsCompanion(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            personId: personId,
            scheduleId: scheduleId,
            date: date,
            expectedPoisha: expectedPoisha,
            paidPoisha: paidPoisha,
            isHoliday: isHoliday,
            lastAllocationDate: lastAllocationDate,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required int createdAt,
            required int updatedAt,
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            required String id,
            required String personId,
            required String scheduleId,
            required String date,
            required int expectedPoisha,
            Value<int> paidPoisha = const Value.absent(),
            Value<bool> isHoliday = const Value.absent(),
            Value<String?> lastAllocationDate = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CollectionObligationsCompanion.insert(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            personId: personId,
            scheduleId: scheduleId,
            date: date,
            expectedPoisha: expectedPoisha,
            paidPoisha: paidPoisha,
            isHoliday: isHoliday,
            lastAllocationDate: lastAllocationDate,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CollectionObligationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {personId = false, paymentAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (paymentAllocationsRefs) db.paymentAllocations
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (personId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personId,
                    referencedTable: $$CollectionObligationsTableReferences
                        ._personIdTable(db),
                    referencedColumn: $$CollectionObligationsTableReferences
                        ._personIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paymentAllocationsRefs)
                    await $_getPrefetchedData<CollectionObligation,
                            $CollectionObligationsTable, PaymentAllocation>(
                        currentTable: table,
                        referencedTable: $$CollectionObligationsTableReferences
                            ._paymentAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CollectionObligationsTableReferences(
                                    db, table, p0)
                                .paymentAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.obligationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CollectionObligationsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CollectionObligationsTable,
        CollectionObligation,
        $$CollectionObligationsTableFilterComposer,
        $$CollectionObligationsTableOrderingComposer,
        $$CollectionObligationsTableAnnotationComposer,
        $$CollectionObligationsTableCreateCompanionBuilder,
        $$CollectionObligationsTableUpdateCompanionBuilder,
        (CollectionObligation, $$CollectionObligationsTableReferences),
        CollectionObligation,
        PrefetchHooks Function({bool personId, bool paymentAllocationsRefs})>;
typedef $$PaymentsTableCreateCompanionBuilder = PaymentsCompanion Function({
  required String userId,
  required int createdAt,
  required int updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  required String id,
  required String personId,
  required int amountPoisha,
  required String date,
  Value<String> method,
  Value<String?> note,
  Value<bool> isReversal,
  Value<String?> reversesPaymentId,
  Value<int> rowid,
});
typedef $$PaymentsTableUpdateCompanionBuilder = PaymentsCompanion Function({
  Value<String> userId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  Value<String> id,
  Value<String> personId,
  Value<int> amountPoisha,
  Value<String> date,
  Value<String> method,
  Value<String?> note,
  Value<bool> isReversal,
  Value<String?> reversesPaymentId,
  Value<int> rowid,
});

final class $$PaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentsTable, Payment> {
  $$PaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonsTable _personIdTable(_$AppDatabase db) => db.persons
      .createAlias($_aliasNameGenerator(db.payments.personId, db.persons.id));

  $$PersonsTableProcessedTableManager get personId {
    final $_column = $_itemColumn<String>('person_id')!;

    final manager = $$PersonsTableTableManager($_db, $_db.persons)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$PaymentAllocationsTable, List<PaymentAllocation>>
      _paymentAllocationsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.paymentAllocations,
              aliasName: $_aliasNameGenerator(
                  db.payments.id, db.paymentAllocations.paymentId));

  $$PaymentAllocationsTableProcessedTableManager get paymentAllocationsRefs {
    final manager = $$PaymentAllocationsTableTableManager(
            $_db, $_db.paymentAllocations)
        .filter((f) => f.paymentId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_paymentAllocationsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPoisha => $composableBuilder(
      column: $table.amountPoisha, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isReversal => $composableBuilder(
      column: $table.isReversal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reversesPaymentId => $composableBuilder(
      column: $table.reversesPaymentId,
      builder: (column) => ColumnFilters(column));

  $$PersonsTableFilterComposer get personId {
    final $$PersonsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableFilterComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> paymentAllocationsRefs(
      Expression<bool> Function($$PaymentAllocationsTableFilterComposer f) f) {
    final $$PaymentAllocationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.paymentAllocations,
        getReferencedColumn: (t) => t.paymentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentAllocationsTableFilterComposer(
              $db: $db,
              $table: $db.paymentAllocations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localVersion => $composableBuilder(
      column: $table.localVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPoisha => $composableBuilder(
      column: $table.amountPoisha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isReversal => $composableBuilder(
      column: $table.isReversal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reversesPaymentId => $composableBuilder(
      column: $table.reversesPaymentId,
      builder: (column) => ColumnOrderings(column));

  $$PersonsTableOrderingComposer get personId {
    final $$PersonsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableOrderingComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPoisha => $composableBuilder(
      column: $table.amountPoisha, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isReversal => $composableBuilder(
      column: $table.isReversal, builder: (column) => column);

  GeneratedColumn<String> get reversesPaymentId => $composableBuilder(
      column: $table.reversesPaymentId, builder: (column) => column);

  $$PersonsTableAnnotationComposer get personId {
    final $$PersonsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.personId,
        referencedTable: $db.persons,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PersonsTableAnnotationComposer(
              $db: $db,
              $table: $db.persons,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> paymentAllocationsRefs<T extends Object>(
      Expression<T> Function($$PaymentAllocationsTableAnnotationComposer a) f) {
    final $$PaymentAllocationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.paymentAllocations,
            getReferencedColumn: (t) => t.paymentId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$PaymentAllocationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.paymentAllocations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$PaymentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool personId, bool paymentAllocationsRefs})> {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> personId = const Value.absent(),
            Value<int> amountPoisha = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isReversal = const Value.absent(),
            Value<String?> reversesPaymentId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            personId: personId,
            amountPoisha: amountPoisha,
            date: date,
            method: method,
            note: note,
            isReversal: isReversal,
            reversesPaymentId: reversesPaymentId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required int createdAt,
            required int updatedAt,
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            required String id,
            required String personId,
            required int amountPoisha,
            required String date,
            Value<String> method = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isReversal = const Value.absent(),
            Value<String?> reversesPaymentId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentsCompanion.insert(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            personId: personId,
            amountPoisha: amountPoisha,
            date: date,
            method: method,
            note: note,
            isReversal: isReversal,
            reversesPaymentId: reversesPaymentId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PaymentsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {personId = false, paymentAllocationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (paymentAllocationsRefs) db.paymentAllocations
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (personId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.personId,
                    referencedTable:
                        $$PaymentsTableReferences._personIdTable(db),
                    referencedColumn:
                        $$PaymentsTableReferences._personIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (paymentAllocationsRefs)
                    await $_getPrefetchedData<Payment, $PaymentsTable,
                            PaymentAllocation>(
                        currentTable: table,
                        referencedTable: $$PaymentsTableReferences
                            ._paymentAllocationsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PaymentsTableReferences(db, table, p0)
                                .paymentAllocationsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.paymentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PaymentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentsTable,
    Payment,
    $$PaymentsTableFilterComposer,
    $$PaymentsTableOrderingComposer,
    $$PaymentsTableAnnotationComposer,
    $$PaymentsTableCreateCompanionBuilder,
    $$PaymentsTableUpdateCompanionBuilder,
    (Payment, $$PaymentsTableReferences),
    Payment,
    PrefetchHooks Function({bool personId, bool paymentAllocationsRefs})>;
typedef $$PaymentAllocationsTableCreateCompanionBuilder
    = PaymentAllocationsCompanion Function({
  required String userId,
  required int createdAt,
  required int updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  required String id,
  required String paymentId,
  required String obligationId,
  required int amountPoisha,
  Value<int> rowid,
});
typedef $$PaymentAllocationsTableUpdateCompanionBuilder
    = PaymentAllocationsCompanion Function({
  Value<String> userId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  Value<String> id,
  Value<String> paymentId,
  Value<String> obligationId,
  Value<int> amountPoisha,
  Value<int> rowid,
});

final class $$PaymentAllocationsTableReferences extends BaseReferences<
    _$AppDatabase, $PaymentAllocationsTable, PaymentAllocation> {
  $$PaymentAllocationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $PaymentsTable _paymentIdTable(_$AppDatabase db) =>
      db.payments.createAlias($_aliasNameGenerator(
          db.paymentAllocations.paymentId, db.payments.id));

  $$PaymentsTableProcessedTableManager get paymentId {
    final $_column = $_itemColumn<String>('payment_id')!;

    final manager = $$PaymentsTableTableManager($_db, $_db.payments)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CollectionObligationsTable _obligationIdTable(_$AppDatabase db) =>
      db.collectionObligations.createAlias($_aliasNameGenerator(
          db.paymentAllocations.obligationId, db.collectionObligations.id));

  $$CollectionObligationsTableProcessedTableManager get obligationId {
    final $_column = $_itemColumn<String>('obligation_id')!;

    final manager = $$CollectionObligationsTableTableManager(
            $_db, $_db.collectionObligations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_obligationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PaymentAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPoisha => $composableBuilder(
      column: $table.amountPoisha, builder: (column) => ColumnFilters(column));

  $$PaymentsTableFilterComposer get paymentId {
    final $$PaymentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentId,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableFilterComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CollectionObligationsTableFilterComposer get obligationId {
    final $$CollectionObligationsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.obligationId,
            referencedTable: $db.collectionObligations,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CollectionObligationsTableFilterComposer(
                  $db: $db,
                  $table: $db.collectionObligations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$PaymentAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localVersion => $composableBuilder(
      column: $table.localVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPoisha => $composableBuilder(
      column: $table.amountPoisha,
      builder: (column) => ColumnOrderings(column));

  $$PaymentsTableOrderingComposer get paymentId {
    final $$PaymentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentId,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableOrderingComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CollectionObligationsTableOrderingComposer get obligationId {
    final $$CollectionObligationsTableOrderingComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.obligationId,
            referencedTable: $db.collectionObligations,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CollectionObligationsTableOrderingComposer(
                  $db: $db,
                  $table: $db.collectionObligations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$PaymentAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentAllocationsTable> {
  $$PaymentAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountPoisha => $composableBuilder(
      column: $table.amountPoisha, builder: (column) => column);

  $$PaymentsTableAnnotationComposer get paymentId {
    final $$PaymentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.paymentId,
        referencedTable: $db.payments,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PaymentsTableAnnotationComposer(
              $db: $db,
              $table: $db.payments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CollectionObligationsTableAnnotationComposer get obligationId {
    final $$CollectionObligationsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.obligationId,
            referencedTable: $db.collectionObligations,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$CollectionObligationsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.collectionObligations,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$PaymentAllocationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PaymentAllocationsTable,
    PaymentAllocation,
    $$PaymentAllocationsTableFilterComposer,
    $$PaymentAllocationsTableOrderingComposer,
    $$PaymentAllocationsTableAnnotationComposer,
    $$PaymentAllocationsTableCreateCompanionBuilder,
    $$PaymentAllocationsTableUpdateCompanionBuilder,
    (PaymentAllocation, $$PaymentAllocationsTableReferences),
    PaymentAllocation,
    PrefetchHooks Function({bool paymentId, bool obligationId})> {
  $$PaymentAllocationsTableTableManager(
      _$AppDatabase db, $PaymentAllocationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentAllocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentAllocationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> paymentId = const Value.absent(),
            Value<String> obligationId = const Value.absent(),
            Value<int> amountPoisha = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentAllocationsCompanion(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            paymentId: paymentId,
            obligationId: obligationId,
            amountPoisha: amountPoisha,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required int createdAt,
            required int updatedAt,
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            required String id,
            required String paymentId,
            required String obligationId,
            required int amountPoisha,
            Value<int> rowid = const Value.absent(),
          }) =>
              PaymentAllocationsCompanion.insert(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            paymentId: paymentId,
            obligationId: obligationId,
            amountPoisha: amountPoisha,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PaymentAllocationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({paymentId = false, obligationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (paymentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.paymentId,
                    referencedTable:
                        $$PaymentAllocationsTableReferences._paymentIdTable(db),
                    referencedColumn: $$PaymentAllocationsTableReferences
                        ._paymentIdTable(db)
                        .id,
                  ) as T;
                }
                if (obligationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.obligationId,
                    referencedTable: $$PaymentAllocationsTableReferences
                        ._obligationIdTable(db),
                    referencedColumn: $$PaymentAllocationsTableReferences
                        ._obligationIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PaymentAllocationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PaymentAllocationsTable,
    PaymentAllocation,
    $$PaymentAllocationsTableFilterComposer,
    $$PaymentAllocationsTableOrderingComposer,
    $$PaymentAllocationsTableAnnotationComposer,
    $$PaymentAllocationsTableCreateCompanionBuilder,
    $$PaymentAllocationsTableUpdateCompanionBuilder,
    (PaymentAllocation, $$PaymentAllocationsTableReferences),
    PaymentAllocation,
    PrefetchHooks Function({bool paymentId, bool obligationId})>;
typedef $$LedgerEntriesTableCreateCompanionBuilder = LedgerEntriesCompanion
    Function({
  required String userId,
  required int createdAt,
  required int updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  required String id,
  required String date,
  required String direction,
  required int amountPoisha,
  required String module,
  Value<String?> personId,
  Value<String?> accountId,
  Value<String?> category,
  Value<String?> note,
  Value<bool> isReversal,
  Value<String?> reversesEntryId,
  Value<int> rowid,
});
typedef $$LedgerEntriesTableUpdateCompanionBuilder = LedgerEntriesCompanion
    Function({
  Value<String> userId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  Value<String> id,
  Value<String> date,
  Value<String> direction,
  Value<int> amountPoisha,
  Value<String> module,
  Value<String?> personId,
  Value<String?> accountId,
  Value<String?> category,
  Value<String?> note,
  Value<bool> isReversal,
  Value<String?> reversesEntryId,
  Value<int> rowid,
});

class $$LedgerEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountPoisha => $composableBuilder(
      column: $table.amountPoisha, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get module => $composableBuilder(
      column: $table.module, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isReversal => $composableBuilder(
      column: $table.isReversal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reversesEntryId => $composableBuilder(
      column: $table.reversesEntryId,
      builder: (column) => ColumnFilters(column));
}

class $$LedgerEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localVersion => $composableBuilder(
      column: $table.localVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get direction => $composableBuilder(
      column: $table.direction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountPoisha => $composableBuilder(
      column: $table.amountPoisha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get module => $composableBuilder(
      column: $table.module, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId => $composableBuilder(
      column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isReversal => $composableBuilder(
      column: $table.isReversal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reversesEntryId => $composableBuilder(
      column: $table.reversesEntryId,
      builder: (column) => ColumnOrderings(column));
}

class $$LedgerEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<int> get amountPoisha => $composableBuilder(
      column: $table.amountPoisha, builder: (column) => column);

  GeneratedColumn<String> get module =>
      $composableBuilder(column: $table.module, builder: (column) => column);

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get isReversal => $composableBuilder(
      column: $table.isReversal, builder: (column) => column);

  GeneratedColumn<String> get reversesEntryId => $composableBuilder(
      column: $table.reversesEntryId, builder: (column) => column);
}

class $$LedgerEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LedgerEntriesTable,
    LedgerEntry,
    $$LedgerEntriesTableFilterComposer,
    $$LedgerEntriesTableOrderingComposer,
    $$LedgerEntriesTableAnnotationComposer,
    $$LedgerEntriesTableCreateCompanionBuilder,
    $$LedgerEntriesTableUpdateCompanionBuilder,
    (
      LedgerEntry,
      BaseReferences<_$AppDatabase, $LedgerEntriesTable, LedgerEntry>
    ),
    LedgerEntry,
    PrefetchHooks Function()> {
  $$LedgerEntriesTableTableManager(_$AppDatabase db, $LedgerEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> direction = const Value.absent(),
            Value<int> amountPoisha = const Value.absent(),
            Value<String> module = const Value.absent(),
            Value<String?> personId = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isReversal = const Value.absent(),
            Value<String?> reversesEntryId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LedgerEntriesCompanion(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            date: date,
            direction: direction,
            amountPoisha: amountPoisha,
            module: module,
            personId: personId,
            accountId: accountId,
            category: category,
            note: note,
            isReversal: isReversal,
            reversesEntryId: reversesEntryId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required int createdAt,
            required int updatedAt,
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            required String id,
            required String date,
            required String direction,
            required int amountPoisha,
            required String module,
            Value<String?> personId = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<bool> isReversal = const Value.absent(),
            Value<String?> reversesEntryId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LedgerEntriesCompanion.insert(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            date: date,
            direction: direction,
            amountPoisha: amountPoisha,
            module: module,
            personId: personId,
            accountId: accountId,
            category: category,
            note: note,
            isReversal: isReversal,
            reversesEntryId: reversesEntryId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LedgerEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LedgerEntriesTable,
    LedgerEntry,
    $$LedgerEntriesTableFilterComposer,
    $$LedgerEntriesTableOrderingComposer,
    $$LedgerEntriesTableAnnotationComposer,
    $$LedgerEntriesTableCreateCompanionBuilder,
    $$LedgerEntriesTableUpdateCompanionBuilder,
    (
      LedgerEntry,
      BaseReferences<_$AppDatabase, $LedgerEntriesTable, LedgerEntry>
    ),
    LedgerEntry,
    PrefetchHooks Function()>;
typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  required String userId,
  required int createdAt,
  required int updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  required String id,
  required String kind,
  required String label,
  Value<String?> number,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> userId,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<String?> deviceId,
  Value<int> localVersion,
  Value<String> syncStatus,
  Value<bool> isDeleted,
  Value<int?> serverUpdatedAt,
  Value<String> id,
  Value<String> kind,
  Value<String> label,
  Value<String?> number,
  Value<int> rowid,
});

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localVersion => $composableBuilder(
      column: $table.localVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
      column: $table.syncStatus, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get serverUpdatedAt => $composableBuilder(
      column: $table.serverUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
    Account,
    PrefetchHooks Function()> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            Value<String> id = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String> label = const Value.absent(),
            Value<String?> number = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            kind: kind,
            label: label,
            number: number,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required int createdAt,
            required int updatedAt,
            Value<String?> deviceId = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> syncStatus = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int?> serverUpdatedAt = const Value.absent(),
            required String id,
            required String kind,
            required String label,
            Value<String?> number = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            userId: userId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deviceId: deviceId,
            localVersion: localVersion,
            syncStatus: syncStatus,
            isDeleted: isDeleted,
            serverUpdatedAt: serverUpdatedAt,
            id: id,
            kind: kind,
            label: label,
            number: number,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
    Account,
    PrefetchHooks Function()>;
typedef $$SyncQueueEntriesTableCreateCompanionBuilder
    = SyncQueueEntriesCompanion Function({
  required String opId,
  required String recordId,
  required String entity,
  required int localVersion,
  Value<String> status,
  Value<int> attempts,
  Value<String?> lastError,
  required int createdAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$SyncQueueEntriesTableUpdateCompanionBuilder
    = SyncQueueEntriesCompanion Function({
  Value<String> opId,
  Value<String> recordId,
  Value<String> entity,
  Value<int> localVersion,
  Value<String> status,
  Value<int> attempts,
  Value<String?> lastError,
  Value<int> createdAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$SyncQueueEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueEntriesTable> {
  $$SyncQueueEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get opId => $composableBuilder(
      column: $table.opId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueEntriesTable> {
  $$SyncQueueEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get opId => $composableBuilder(
      column: $table.opId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localVersion => $composableBuilder(
      column: $table.localVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attempts => $composableBuilder(
      column: $table.attempts, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueEntriesTable> {
  $$SyncQueueEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get opId =>
      $composableBuilder(column: $table.opId, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<int> get localVersion => $composableBuilder(
      column: $table.localVersion, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueEntriesTable,
    SyncQueueEntry,
    $$SyncQueueEntriesTableFilterComposer,
    $$SyncQueueEntriesTableOrderingComposer,
    $$SyncQueueEntriesTableAnnotationComposer,
    $$SyncQueueEntriesTableCreateCompanionBuilder,
    $$SyncQueueEntriesTableUpdateCompanionBuilder,
    (
      SyncQueueEntry,
      BaseReferences<_$AppDatabase, $SyncQueueEntriesTable, SyncQueueEntry>
    ),
    SyncQueueEntry,
    PrefetchHooks Function()> {
  $$SyncQueueEntriesTableTableManager(
      _$AppDatabase db, $SyncQueueEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> opId = const Value.absent(),
            Value<String> recordId = const Value.absent(),
            Value<String> entity = const Value.absent(),
            Value<int> localVersion = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueEntriesCompanion(
            opId: opId,
            recordId: recordId,
            entity: entity,
            localVersion: localVersion,
            status: status,
            attempts: attempts,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String opId,
            required String recordId,
            required String entity,
            required int localVersion,
            Value<String> status = const Value.absent(),
            Value<int> attempts = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            required int createdAt,
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueEntriesCompanion.insert(
            opId: opId,
            recordId: recordId,
            entity: entity,
            localVersion: localVersion,
            status: status,
            attempts: attempts,
            lastError: lastError,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueEntriesTable,
    SyncQueueEntry,
    $$SyncQueueEntriesTableFilterComposer,
    $$SyncQueueEntriesTableOrderingComposer,
    $$SyncQueueEntriesTableAnnotationComposer,
    $$SyncQueueEntriesTableCreateCompanionBuilder,
    $$SyncQueueEntriesTableUpdateCompanionBuilder,
    (
      SyncQueueEntry,
      BaseReferences<_$AppDatabase, $SyncQueueEntriesTable, SyncQueueEntry>
    ),
    SyncQueueEntry,
    PrefetchHooks Function()>;
typedef $$DailySummariesTableCreateCompanionBuilder = DailySummariesCompanion
    Function({
  required String date,
  required String userId,
  required int openingPoisha,
  required int totalInPoisha,
  required int totalOutPoisha,
  required int collectionPoisha,
  required int closingPoisha,
  Value<bool> isClosed,
  Value<String?> closedBy,
  Value<int?> closedAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$DailySummariesTableUpdateCompanionBuilder = DailySummariesCompanion
    Function({
  Value<String> date,
  Value<String> userId,
  Value<int> openingPoisha,
  Value<int> totalInPoisha,
  Value<int> totalOutPoisha,
  Value<int> collectionPoisha,
  Value<int> closingPoisha,
  Value<bool> isClosed,
  Value<String?> closedBy,
  Value<int?> closedAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$DailySummariesTableFilterComposer
    extends Composer<_$AppDatabase, $DailySummariesTable> {
  $$DailySummariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get openingPoisha => $composableBuilder(
      column: $table.openingPoisha, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalInPoisha => $composableBuilder(
      column: $table.totalInPoisha, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalOutPoisha => $composableBuilder(
      column: $table.totalOutPoisha,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get collectionPoisha => $composableBuilder(
      column: $table.collectionPoisha,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get closingPoisha => $composableBuilder(
      column: $table.closingPoisha, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isClosed => $composableBuilder(
      column: $table.isClosed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get closedBy => $composableBuilder(
      column: $table.closedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$DailySummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $DailySummariesTable> {
  $$DailySummariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get openingPoisha => $composableBuilder(
      column: $table.openingPoisha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalInPoisha => $composableBuilder(
      column: $table.totalInPoisha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalOutPoisha => $composableBuilder(
      column: $table.totalOutPoisha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get collectionPoisha => $composableBuilder(
      column: $table.collectionPoisha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get closingPoisha => $composableBuilder(
      column: $table.closingPoisha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isClosed => $composableBuilder(
      column: $table.isClosed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get closedBy => $composableBuilder(
      column: $table.closedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get closedAt => $composableBuilder(
      column: $table.closedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$DailySummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailySummariesTable> {
  $$DailySummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get openingPoisha => $composableBuilder(
      column: $table.openingPoisha, builder: (column) => column);

  GeneratedColumn<int> get totalInPoisha => $composableBuilder(
      column: $table.totalInPoisha, builder: (column) => column);

  GeneratedColumn<int> get totalOutPoisha => $composableBuilder(
      column: $table.totalOutPoisha, builder: (column) => column);

  GeneratedColumn<int> get collectionPoisha => $composableBuilder(
      column: $table.collectionPoisha, builder: (column) => column);

  GeneratedColumn<int> get closingPoisha => $composableBuilder(
      column: $table.closingPoisha, builder: (column) => column);

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);

  GeneratedColumn<String> get closedBy =>
      $composableBuilder(column: $table.closedBy, builder: (column) => column);

  GeneratedColumn<int> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailySummariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailySummariesTable,
    DailySummary,
    $$DailySummariesTableFilterComposer,
    $$DailySummariesTableOrderingComposer,
    $$DailySummariesTableAnnotationComposer,
    $$DailySummariesTableCreateCompanionBuilder,
    $$DailySummariesTableUpdateCompanionBuilder,
    (
      DailySummary,
      BaseReferences<_$AppDatabase, $DailySummariesTable, DailySummary>
    ),
    DailySummary,
    PrefetchHooks Function()> {
  $$DailySummariesTableTableManager(
      _$AppDatabase db, $DailySummariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailySummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailySummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailySummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> date = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> openingPoisha = const Value.absent(),
            Value<int> totalInPoisha = const Value.absent(),
            Value<int> totalOutPoisha = const Value.absent(),
            Value<int> collectionPoisha = const Value.absent(),
            Value<int> closingPoisha = const Value.absent(),
            Value<bool> isClosed = const Value.absent(),
            Value<String?> closedBy = const Value.absent(),
            Value<int?> closedAt = const Value.absent(),
            Value<int> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailySummariesCompanion(
            date: date,
            userId: userId,
            openingPoisha: openingPoisha,
            totalInPoisha: totalInPoisha,
            totalOutPoisha: totalOutPoisha,
            collectionPoisha: collectionPoisha,
            closingPoisha: closingPoisha,
            isClosed: isClosed,
            closedBy: closedBy,
            closedAt: closedAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String date,
            required String userId,
            required int openingPoisha,
            required int totalInPoisha,
            required int totalOutPoisha,
            required int collectionPoisha,
            required int closingPoisha,
            Value<bool> isClosed = const Value.absent(),
            Value<String?> closedBy = const Value.absent(),
            Value<int?> closedAt = const Value.absent(),
            required int updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DailySummariesCompanion.insert(
            date: date,
            userId: userId,
            openingPoisha: openingPoisha,
            totalInPoisha: totalInPoisha,
            totalOutPoisha: totalOutPoisha,
            collectionPoisha: collectionPoisha,
            closingPoisha: closingPoisha,
            isClosed: isClosed,
            closedBy: closedBy,
            closedAt: closedAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailySummariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailySummariesTable,
    DailySummary,
    $$DailySummariesTableFilterComposer,
    $$DailySummariesTableOrderingComposer,
    $$DailySummariesTableAnnotationComposer,
    $$DailySummariesTableCreateCompanionBuilder,
    $$DailySummariesTableUpdateCompanionBuilder,
    (
      DailySummary,
      BaseReferences<_$AppDatabase, $DailySummariesTable, DailySummary>
    ),
    DailySummary,
    PrefetchHooks Function()>;
typedef $$AuditLogTableCreateCompanionBuilder = AuditLogCompanion Function({
  required String id,
  required String userId,
  required String entity,
  required String entityId,
  required String action,
  Value<String?> actor,
  Value<String?> reason,
  required int createdAt,
  Value<int> rowid,
});
typedef $$AuditLogTableUpdateCompanionBuilder = AuditLogCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> entity,
  Value<String> entityId,
  Value<String> action,
  Value<String?> actor,
  Value<String?> reason,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get actor => $composableBuilder(
      column: $table.actor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entity => $composableBuilder(
      column: $table.entity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get action => $composableBuilder(
      column: $table.action, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get actor => $composableBuilder(
      column: $table.actor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
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

  GeneratedColumn<String> get entity =>
      $composableBuilder(column: $table.entity, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get actor =>
      $composableBuilder(column: $table.actor, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuditLogTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuditLogTable,
    AuditLogData,
    $$AuditLogTableFilterComposer,
    $$AuditLogTableOrderingComposer,
    $$AuditLogTableAnnotationComposer,
    $$AuditLogTableCreateCompanionBuilder,
    $$AuditLogTableUpdateCompanionBuilder,
    (AuditLogData, BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>),
    AuditLogData,
    PrefetchHooks Function()> {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> entity = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String?> actor = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogCompanion(
            id: id,
            userId: userId,
            entity: entity,
            entityId: entityId,
            action: action,
            actor: actor,
            reason: reason,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String entity,
            required String entityId,
            required String action,
            Value<String?> actor = const Value.absent(),
            Value<String?> reason = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AuditLogCompanion.insert(
            id: id,
            userId: userId,
            entity: entity,
            entityId: entityId,
            action: action,
            actor: actor,
            reason: reason,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuditLogTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuditLogTable,
    AuditLogData,
    $$AuditLogTableFilterComposer,
    $$AuditLogTableOrderingComposer,
    $$AuditLogTableAnnotationComposer,
    $$AuditLogTableCreateCompanionBuilder,
    $$AuditLogTableUpdateCompanionBuilder,
    (AuditLogData, BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>),
    AuditLogData,
    PrefetchHooks Function()>;
typedef $$BackupsTableCreateCompanionBuilder = BackupsCompanion Function({
  required String id,
  required String userId,
  required String kind,
  Value<String?> pathOrRef,
  Value<int?> recordCount,
  Value<bool?> integrityOk,
  required int createdAt,
  Value<int> rowid,
});
typedef $$BackupsTableUpdateCompanionBuilder = BackupsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> kind,
  Value<String?> pathOrRef,
  Value<int?> recordCount,
  Value<bool?> integrityOk,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$BackupsTableFilterComposer
    extends Composer<_$AppDatabase, $BackupsTable> {
  $$BackupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pathOrRef => $composableBuilder(
      column: $table.pathOrRef, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get integrityOk => $composableBuilder(
      column: $table.integrityOk, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$BackupsTableOrderingComposer
    extends Composer<_$AppDatabase, $BackupsTable> {
  $$BackupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get kind => $composableBuilder(
      column: $table.kind, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pathOrRef => $composableBuilder(
      column: $table.pathOrRef, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get integrityOk => $composableBuilder(
      column: $table.integrityOk, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$BackupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BackupsTable> {
  $$BackupsTableAnnotationComposer({
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

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get pathOrRef =>
      $composableBuilder(column: $table.pathOrRef, builder: (column) => column);

  GeneratedColumn<int> get recordCount => $composableBuilder(
      column: $table.recordCount, builder: (column) => column);

  GeneratedColumn<bool> get integrityOk => $composableBuilder(
      column: $table.integrityOk, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BackupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BackupsTable,
    Backup,
    $$BackupsTableFilterComposer,
    $$BackupsTableOrderingComposer,
    $$BackupsTableAnnotationComposer,
    $$BackupsTableCreateCompanionBuilder,
    $$BackupsTableUpdateCompanionBuilder,
    (Backup, BaseReferences<_$AppDatabase, $BackupsTable, Backup>),
    Backup,
    PrefetchHooks Function()> {
  $$BackupsTableTableManager(_$AppDatabase db, $BackupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BackupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BackupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BackupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> kind = const Value.absent(),
            Value<String?> pathOrRef = const Value.absent(),
            Value<int?> recordCount = const Value.absent(),
            Value<bool?> integrityOk = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupsCompanion(
            id: id,
            userId: userId,
            kind: kind,
            pathOrRef: pathOrRef,
            recordCount: recordCount,
            integrityOk: integrityOk,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String kind,
            Value<String?> pathOrRef = const Value.absent(),
            Value<int?> recordCount = const Value.absent(),
            Value<bool?> integrityOk = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BackupsCompanion.insert(
            id: id,
            userId: userId,
            kind: kind,
            pathOrRef: pathOrRef,
            recordCount: recordCount,
            integrityOk: integrityOk,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BackupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BackupsTable,
    Backup,
    $$BackupsTableFilterComposer,
    $$BackupsTableOrderingComposer,
    $$BackupsTableAnnotationComposer,
    $$BackupsTableCreateCompanionBuilder,
    $$BackupsTableUpdateCompanionBuilder,
    (Backup, BaseReferences<_$AppDatabase, $BackupsTable, Backup>),
    Backup,
    PrefetchHooks Function()>;
typedef $$OperatorBalancesTableCreateCompanionBuilder
    = OperatorBalancesCompanion Function({
  required String operator,
  Value<int> balancePoisha,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$OperatorBalancesTableUpdateCompanionBuilder
    = OperatorBalancesCompanion Function({
  Value<String> operator,
  Value<int> balancePoisha,
  Value<String> updatedAt,
  Value<int> rowid,
});

class $$OperatorBalancesTableFilterComposer
    extends Composer<_$AppDatabase, $OperatorBalancesTable> {
  $$OperatorBalancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get operator => $composableBuilder(
      column: $table.operator, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balancePoisha => $composableBuilder(
      column: $table.balancePoisha, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$OperatorBalancesTableOrderingComposer
    extends Composer<_$AppDatabase, $OperatorBalancesTable> {
  $$OperatorBalancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get operator => $composableBuilder(
      column: $table.operator, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balancePoisha => $composableBuilder(
      column: $table.balancePoisha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$OperatorBalancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OperatorBalancesTable> {
  $$OperatorBalancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get operator =>
      $composableBuilder(column: $table.operator, builder: (column) => column);

  GeneratedColumn<int> get balancePoisha => $composableBuilder(
      column: $table.balancePoisha, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OperatorBalancesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OperatorBalancesTable,
    OperatorBalance,
    $$OperatorBalancesTableFilterComposer,
    $$OperatorBalancesTableOrderingComposer,
    $$OperatorBalancesTableAnnotationComposer,
    $$OperatorBalancesTableCreateCompanionBuilder,
    $$OperatorBalancesTableUpdateCompanionBuilder,
    (
      OperatorBalance,
      BaseReferences<_$AppDatabase, $OperatorBalancesTable, OperatorBalance>
    ),
    OperatorBalance,
    PrefetchHooks Function()> {
  $$OperatorBalancesTableTableManager(
      _$AppDatabase db, $OperatorBalancesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OperatorBalancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OperatorBalancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OperatorBalancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> operator = const Value.absent(),
            Value<int> balancePoisha = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OperatorBalancesCompanion(
            operator: operator,
            balancePoisha: balancePoisha,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String operator,
            Value<int> balancePoisha = const Value.absent(),
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              OperatorBalancesCompanion.insert(
            operator: operator,
            balancePoisha: balancePoisha,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OperatorBalancesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OperatorBalancesTable,
    OperatorBalance,
    $$OperatorBalancesTableFilterComposer,
    $$OperatorBalancesTableOrderingComposer,
    $$OperatorBalancesTableAnnotationComposer,
    $$OperatorBalancesTableCreateCompanionBuilder,
    $$OperatorBalancesTableUpdateCompanionBuilder,
    (
      OperatorBalance,
      BaseReferences<_$AppDatabase, $OperatorBalancesTable, OperatorBalance>
    ),
    OperatorBalance,
    PrefetchHooks Function()>;
typedef $$TokriRentalsTableCreateCompanionBuilder = TokriRentalsCompanion
    Function({
  required String id,
  required String userId,
  required String personId,
  required int tokriCount,
  required int dailyRatePoisha,
  required String createdAt,
  Value<int> rowid,
});
typedef $$TokriRentalsTableUpdateCompanionBuilder = TokriRentalsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> personId,
  Value<int> tokriCount,
  Value<int> dailyRatePoisha,
  Value<String> createdAt,
  Value<int> rowid,
});

class $$TokriRentalsTableFilterComposer
    extends Composer<_$AppDatabase, $TokriRentalsTable> {
  $$TokriRentalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tokriCount => $composableBuilder(
      column: $table.tokriCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dailyRatePoisha => $composableBuilder(
      column: $table.dailyRatePoisha,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$TokriRentalsTableOrderingComposer
    extends Composer<_$AppDatabase, $TokriRentalsTable> {
  $$TokriRentalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tokriCount => $composableBuilder(
      column: $table.tokriCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dailyRatePoisha => $composableBuilder(
      column: $table.dailyRatePoisha,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$TokriRentalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TokriRentalsTable> {
  $$TokriRentalsTableAnnotationComposer({
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

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<int> get tokriCount => $composableBuilder(
      column: $table.tokriCount, builder: (column) => column);

  GeneratedColumn<int> get dailyRatePoisha => $composableBuilder(
      column: $table.dailyRatePoisha, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TokriRentalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TokriRentalsTable,
    TokriRental,
    $$TokriRentalsTableFilterComposer,
    $$TokriRentalsTableOrderingComposer,
    $$TokriRentalsTableAnnotationComposer,
    $$TokriRentalsTableCreateCompanionBuilder,
    $$TokriRentalsTableUpdateCompanionBuilder,
    (
      TokriRental,
      BaseReferences<_$AppDatabase, $TokriRentalsTable, TokriRental>
    ),
    TokriRental,
    PrefetchHooks Function()> {
  $$TokriRentalsTableTableManager(_$AppDatabase db, $TokriRentalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TokriRentalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TokriRentalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TokriRentalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> personId = const Value.absent(),
            Value<int> tokriCount = const Value.absent(),
            Value<int> dailyRatePoisha = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TokriRentalsCompanion(
            id: id,
            userId: userId,
            personId: personId,
            tokriCount: tokriCount,
            dailyRatePoisha: dailyRatePoisha,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String personId,
            required int tokriCount,
            required int dailyRatePoisha,
            required String createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TokriRentalsCompanion.insert(
            id: id,
            userId: userId,
            personId: personId,
            tokriCount: tokriCount,
            dailyRatePoisha: dailyRatePoisha,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TokriRentalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TokriRentalsTable,
    TokriRental,
    $$TokriRentalsTableFilterComposer,
    $$TokriRentalsTableOrderingComposer,
    $$TokriRentalsTableAnnotationComposer,
    $$TokriRentalsTableCreateCompanionBuilder,
    $$TokriRentalsTableUpdateCompanionBuilder,
    (
      TokriRental,
      BaseReferences<_$AppDatabase, $TokriRentalsTable, TokriRental>
    ),
    TokriRental,
    PrefetchHooks Function()>;
typedef $$TokriAttendanceTableCreateCompanionBuilder = TokriAttendanceCompanion
    Function({
  required String userId,
  required String rentalId,
  required String businessDate,
  required String status,
  Value<int> rowid,
});
typedef $$TokriAttendanceTableUpdateCompanionBuilder = TokriAttendanceCompanion
    Function({
  Value<String> userId,
  Value<String> rentalId,
  Value<String> businessDate,
  Value<String> status,
  Value<int> rowid,
});

class $$TokriAttendanceTableFilterComposer
    extends Composer<_$AppDatabase, $TokriAttendanceTable> {
  $$TokriAttendanceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rentalId => $composableBuilder(
      column: $table.rentalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get businessDate => $composableBuilder(
      column: $table.businessDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));
}

class $$TokriAttendanceTableOrderingComposer
    extends Composer<_$AppDatabase, $TokriAttendanceTable> {
  $$TokriAttendanceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rentalId => $composableBuilder(
      column: $table.rentalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get businessDate => $composableBuilder(
      column: $table.businessDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));
}

class $$TokriAttendanceTableAnnotationComposer
    extends Composer<_$AppDatabase, $TokriAttendanceTable> {
  $$TokriAttendanceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get rentalId =>
      $composableBuilder(column: $table.rentalId, builder: (column) => column);

  GeneratedColumn<String> get businessDate => $composableBuilder(
      column: $table.businessDate, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$TokriAttendanceTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TokriAttendanceTable,
    TokriAttendanceData,
    $$TokriAttendanceTableFilterComposer,
    $$TokriAttendanceTableOrderingComposer,
    $$TokriAttendanceTableAnnotationComposer,
    $$TokriAttendanceTableCreateCompanionBuilder,
    $$TokriAttendanceTableUpdateCompanionBuilder,
    (
      TokriAttendanceData,
      BaseReferences<_$AppDatabase, $TokriAttendanceTable, TokriAttendanceData>
    ),
    TokriAttendanceData,
    PrefetchHooks Function()> {
  $$TokriAttendanceTableTableManager(
      _$AppDatabase db, $TokriAttendanceTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TokriAttendanceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TokriAttendanceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TokriAttendanceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String> rentalId = const Value.absent(),
            Value<String> businessDate = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TokriAttendanceCompanion(
            userId: userId,
            rentalId: rentalId,
            businessDate: businessDate,
            status: status,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required String rentalId,
            required String businessDate,
            required String status,
            Value<int> rowid = const Value.absent(),
          }) =>
              TokriAttendanceCompanion.insert(
            userId: userId,
            rentalId: rentalId,
            businessDate: businessDate,
            status: status,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TokriAttendanceTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TokriAttendanceTable,
    TokriAttendanceData,
    $$TokriAttendanceTableFilterComposer,
    $$TokriAttendanceTableOrderingComposer,
    $$TokriAttendanceTableAnnotationComposer,
    $$TokriAttendanceTableCreateCompanionBuilder,
    $$TokriAttendanceTableUpdateCompanionBuilder,
    (
      TokriAttendanceData,
      BaseReferences<_$AppDatabase, $TokriAttendanceTable, TokriAttendanceData>
    ),
    TokriAttendanceData,
    PrefetchHooks Function()>;
typedef $$SomityMembersTableCreateCompanionBuilder = SomityMembersCompanion
    Function({
  required String userId,
  required String personId,
  Value<int> rowid,
});
typedef $$SomityMembersTableUpdateCompanionBuilder = SomityMembersCompanion
    Function({
  Value<String> userId,
  Value<String> personId,
  Value<int> rowid,
});

class $$SomityMembersTableFilterComposer
    extends Composer<_$AppDatabase, $SomityMembersTable> {
  $$SomityMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));
}

class $$SomityMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $SomityMembersTable> {
  $$SomityMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));
}

class $$SomityMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SomityMembersTable> {
  $$SomityMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);
}

class $$SomityMembersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SomityMembersTable,
    SomityMember,
    $$SomityMembersTableFilterComposer,
    $$SomityMembersTableOrderingComposer,
    $$SomityMembersTableAnnotationComposer,
    $$SomityMembersTableCreateCompanionBuilder,
    $$SomityMembersTableUpdateCompanionBuilder,
    (
      SomityMember,
      BaseReferences<_$AppDatabase, $SomityMembersTable, SomityMember>
    ),
    SomityMember,
    PrefetchHooks Function()> {
  $$SomityMembersTableTableManager(_$AppDatabase db, $SomityMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SomityMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SomityMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SomityMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String> personId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SomityMembersCompanion(
            userId: userId,
            personId: personId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required String personId,
            Value<int> rowid = const Value.absent(),
          }) =>
              SomityMembersCompanion.insert(
            userId: userId,
            personId: personId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SomityMembersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SomityMembersTable,
    SomityMember,
    $$SomityMembersTableFilterComposer,
    $$SomityMembersTableOrderingComposer,
    $$SomityMembersTableAnnotationComposer,
    $$SomityMembersTableCreateCompanionBuilder,
    $$SomityMembersTableUpdateCompanionBuilder,
    (
      SomityMember,
      BaseReferences<_$AppDatabase, $SomityMembersTable, SomityMember>
    ),
    SomityMember,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableTableCreateCompanionBuilder
    = AppSettingsTableCompanion Function({
  required String userId,
  required String json,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$AppSettingsTableTableUpdateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<String> userId,
  Value<String> json,
  Value<String> updatedAt,
  Value<int> rowid,
});

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableTableManager(
      _$AppDatabase db, $AppSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String> json = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsTableCompanion(
            userId: userId,
            json: json,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String userId,
            required String json,
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppSettingsTableCompanion.insert(
            userId: userId,
            json: json,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    AppSettingsTableData,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      AppSettingsTableData,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable,
          AppSettingsTableData>
    ),
    AppSettingsTableData,
    PrefetchHooks Function()>;
typedef $$FaceEnrollmentsTableCreateCompanionBuilder = FaceEnrollmentsCompanion
    Function({
  required String personId,
  required String json,
  required String updatedAt,
  Value<int> rowid,
});
typedef $$FaceEnrollmentsTableUpdateCompanionBuilder = FaceEnrollmentsCompanion
    Function({
  Value<String> personId,
  Value<String> json,
  Value<String> updatedAt,
  Value<int> rowid,
});

class $$FaceEnrollmentsTableFilterComposer
    extends Composer<_$AppDatabase, $FaceEnrollmentsTable> {
  $$FaceEnrollmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FaceEnrollmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $FaceEnrollmentsTable> {
  $$FaceEnrollmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get personId => $composableBuilder(
      column: $table.personId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get json => $composableBuilder(
      column: $table.json, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FaceEnrollmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FaceEnrollmentsTable> {
  $$FaceEnrollmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get personId =>
      $composableBuilder(column: $table.personId, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FaceEnrollmentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FaceEnrollmentsTable,
    FaceEnrollment,
    $$FaceEnrollmentsTableFilterComposer,
    $$FaceEnrollmentsTableOrderingComposer,
    $$FaceEnrollmentsTableAnnotationComposer,
    $$FaceEnrollmentsTableCreateCompanionBuilder,
    $$FaceEnrollmentsTableUpdateCompanionBuilder,
    (
      FaceEnrollment,
      BaseReferences<_$AppDatabase, $FaceEnrollmentsTable, FaceEnrollment>
    ),
    FaceEnrollment,
    PrefetchHooks Function()> {
  $$FaceEnrollmentsTableTableManager(
      _$AppDatabase db, $FaceEnrollmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FaceEnrollmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FaceEnrollmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FaceEnrollmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> personId = const Value.absent(),
            Value<String> json = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FaceEnrollmentsCompanion(
            personId: personId,
            json: json,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String personId,
            required String json,
            required String updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FaceEnrollmentsCompanion.insert(
            personId: personId,
            json: json,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FaceEnrollmentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FaceEnrollmentsTable,
    FaceEnrollment,
    $$FaceEnrollmentsTableFilterComposer,
    $$FaceEnrollmentsTableOrderingComposer,
    $$FaceEnrollmentsTableAnnotationComposer,
    $$FaceEnrollmentsTableCreateCompanionBuilder,
    $$FaceEnrollmentsTableUpdateCompanionBuilder,
    (
      FaceEnrollment,
      BaseReferences<_$AppDatabase, $FaceEnrollmentsTable, FaceEnrollment>
    ),
    FaceEnrollment,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PersonsTableTableManager get persons =>
      $$PersonsTableTableManager(_db, _db.persons);
  $$CollectionSchedulesTableTableManager get collectionSchedules =>
      $$CollectionSchedulesTableTableManager(_db, _db.collectionSchedules);
  $$CollectionObligationsTableTableManager get collectionObligations =>
      $$CollectionObligationsTableTableManager(_db, _db.collectionObligations);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$PaymentAllocationsTableTableManager get paymentAllocations =>
      $$PaymentAllocationsTableTableManager(_db, _db.paymentAllocations);
  $$LedgerEntriesTableTableManager get ledgerEntries =>
      $$LedgerEntriesTableTableManager(_db, _db.ledgerEntries);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$SyncQueueEntriesTableTableManager get syncQueueEntries =>
      $$SyncQueueEntriesTableTableManager(_db, _db.syncQueueEntries);
  $$DailySummariesTableTableManager get dailySummaries =>
      $$DailySummariesTableTableManager(_db, _db.dailySummaries);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
  $$BackupsTableTableManager get backups =>
      $$BackupsTableTableManager(_db, _db.backups);
  $$OperatorBalancesTableTableManager get operatorBalances =>
      $$OperatorBalancesTableTableManager(_db, _db.operatorBalances);
  $$TokriRentalsTableTableManager get tokriRentals =>
      $$TokriRentalsTableTableManager(_db, _db.tokriRentals);
  $$TokriAttendanceTableTableManager get tokriAttendance =>
      $$TokriAttendanceTableTableManager(_db, _db.tokriAttendance);
  $$SomityMembersTableTableManager get somityMembers =>
      $$SomityMembersTableTableManager(_db, _db.somityMembers);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$FaceEnrollmentsTableTableManager get faceEnrollments =>
      $$FaceEnrollmentsTableTableManager(_db, _db.faceEnrollments);
}
