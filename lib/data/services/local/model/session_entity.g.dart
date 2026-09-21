// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSessionEntityCollection on Isar {
  IsarCollection<SessionEntity> get sessionEntitys => this.collection();
}

const SessionEntitySchema = CollectionSchema(
  name: r'SessionEntity',
  id: 7472964409236372477,
  properties: {
    r'accountUserId': PropertySchema(
      id: 0,
      name: r'accountUserId',
      type: IsarType.string,
    ),
    r'encryptedPrivateKey': PropertySchema(
      id: 1,
      name: r'encryptedPrivateKey',
      type: IsarType.string,
    ),
    r'expireAt': PropertySchema(id: 2, name: r'expireAt', type: IsarType.long),
    r'isActive': PropertySchema(id: 3, name: r'isActive', type: IsarType.bool),
    r'isTmpToken': PropertySchema(
      id: 4,
      name: r'isTmpToken',
      type: IsarType.bool,
    ),
    r'localEncryptedPrivateKey': PropertySchema(
      id: 5,
      name: r'localEncryptedPrivateKey',
      type: IsarType.string,
    ),
    r'md5Password': PropertySchema(
      id: 6,
      name: r'md5Password',
      type: IsarType.string,
    ),
    r'refreshToken': PropertySchema(
      id: 7,
      name: r'refreshToken',
      type: IsarType.string,
    ),
    r'token': PropertySchema(id: 8, name: r'token', type: IsarType.string),
    r'userAvatar': PropertySchema(
      id: 9,
      name: r'userAvatar',
      type: IsarType.string,
    ),
    r'userEmail': PropertySchema(
      id: 10,
      name: r'userEmail',
      type: IsarType.string,
    ),
    r'userFullName': PropertySchema(
      id: 11,
      name: r'userFullName',
      type: IsarType.string,
    ),
    r'workspaceId': PropertySchema(
      id: 12,
      name: r'workspaceId',
      type: IsarType.string,
    ),
  },

  estimateSize: _sessionEntityEstimateSize,
  serialize: _sessionEntitySerialize,
  deserialize: _sessionEntityDeserialize,
  deserializeProp: _sessionEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'accountUserId': IndexSchema(
      id: -3442707446326505347,
      name: r'accountUserId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'accountUserId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _sessionEntityGetId,
  getLinks: _sessionEntityGetLinks,
  attach: _sessionEntityAttach,
  version: '3.3.2',
);

int _sessionEntityEstimateSize(
  SessionEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountUserId.length * 3;
  {
    final value = object.encryptedPrivateKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.localEncryptedPrivateKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.md5Password;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.refreshToken;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.token.length * 3;
  {
    final value = object.userAvatar;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userFullName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.workspaceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _sessionEntitySerialize(
  SessionEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountUserId);
  writer.writeString(offsets[1], object.encryptedPrivateKey);
  writer.writeLong(offsets[2], object.expireAt);
  writer.writeBool(offsets[3], object.isActive);
  writer.writeBool(offsets[4], object.isTmpToken);
  writer.writeString(offsets[5], object.localEncryptedPrivateKey);
  writer.writeString(offsets[6], object.md5Password);
  writer.writeString(offsets[7], object.refreshToken);
  writer.writeString(offsets[8], object.token);
  writer.writeString(offsets[9], object.userAvatar);
  writer.writeString(offsets[10], object.userEmail);
  writer.writeString(offsets[11], object.userFullName);
  writer.writeString(offsets[12], object.workspaceId);
}

SessionEntity _sessionEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SessionEntity(
    accountUserId: reader.readString(offsets[0]),
    encryptedPrivateKey: reader.readStringOrNull(offsets[1]),
    expireAt: reader.readLongOrNull(offsets[2]),
    isActive: reader.readBool(offsets[3]),
    isTmpToken: reader.readBoolOrNull(offsets[4]) ?? false,
    localEncryptedPrivateKey: reader.readStringOrNull(offsets[5]),
    md5Password: reader.readStringOrNull(offsets[6]),
    refreshToken: reader.readStringOrNull(offsets[7]),
    token: reader.readString(offsets[8]),
    userAvatar: reader.readStringOrNull(offsets[9]),
    userEmail: reader.readStringOrNull(offsets[10]),
    userFullName: reader.readStringOrNull(offsets[11]),
    workspaceId: reader.readStringOrNull(offsets[12]),
  );
  object.id = id;
  return object;
}

P _sessionEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBoolOrNull(offset) ?? false) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sessionEntityGetId(SessionEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sessionEntityGetLinks(SessionEntity object) {
  return [];
}

void _sessionEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  SessionEntity object,
) {
  object.id = id;
}

extension SessionEntityByIndex on IsarCollection<SessionEntity> {
  Future<SessionEntity?> getByAccountUserId(String accountUserId) {
    return getByIndex(r'accountUserId', [accountUserId]);
  }

  SessionEntity? getByAccountUserIdSync(String accountUserId) {
    return getByIndexSync(r'accountUserId', [accountUserId]);
  }

  Future<bool> deleteByAccountUserId(String accountUserId) {
    return deleteByIndex(r'accountUserId', [accountUserId]);
  }

  bool deleteByAccountUserIdSync(String accountUserId) {
    return deleteByIndexSync(r'accountUserId', [accountUserId]);
  }

  Future<List<SessionEntity?>> getAllByAccountUserId(
    List<String> accountUserIdValues,
  ) {
    final values = accountUserIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'accountUserId', values);
  }

  List<SessionEntity?> getAllByAccountUserIdSync(
    List<String> accountUserIdValues,
  ) {
    final values = accountUserIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'accountUserId', values);
  }

  Future<int> deleteAllByAccountUserId(List<String> accountUserIdValues) {
    final values = accountUserIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'accountUserId', values);
  }

  int deleteAllByAccountUserIdSync(List<String> accountUserIdValues) {
    final values = accountUserIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'accountUserId', values);
  }

  Future<Id> putByAccountUserId(SessionEntity object) {
    return putByIndex(r'accountUserId', object);
  }

  Id putByAccountUserIdSync(SessionEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'accountUserId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByAccountUserId(List<SessionEntity> objects) {
    return putAllByIndex(r'accountUserId', objects);
  }

  List<Id> putAllByAccountUserIdSync(
    List<SessionEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'accountUserId', objects, saveLinks: saveLinks);
  }
}

extension SessionEntityQueryWhereSort
    on QueryBuilder<SessionEntity, SessionEntity, QWhere> {
  QueryBuilder<SessionEntity, SessionEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SessionEntityQueryWhere
    on QueryBuilder<SessionEntity, SessionEntity, QWhereClause> {
  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause>
  accountUserIdEqualTo(String accountUserId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'accountUserId',
          value: [accountUserId],
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterWhereClause>
  accountUserIdNotEqualTo(String accountUserId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId',
                lower: [],
                upper: [accountUserId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId',
                lower: [accountUserId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId',
                lower: [accountUserId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId',
                lower: [],
                upper: [accountUserId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension SessionEntityQueryFilter
    on QueryBuilder<SessionEntity, SessionEntity, QFilterCondition> {
  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  accountUserIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'accountUserId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  accountUserIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountUserId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  accountUserIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountUserId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  accountUserIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountUserId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  accountUserIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'accountUserId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  accountUserIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'accountUserId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  accountUserIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'accountUserId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  accountUserIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'accountUserId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  accountUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountUserId', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  accountUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accountUserId', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'encryptedPrivateKey'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'encryptedPrivateKey'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'encryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'encryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'encryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'encryptedPrivateKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'encryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'encryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'encryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'encryptedPrivateKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'encryptedPrivateKey', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  encryptedPrivateKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'encryptedPrivateKey',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  expireAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'expireAt'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  expireAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'expireAt'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  expireAtEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'expireAt', value: value),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  expireAtGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'expireAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  expireAtLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'expireAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  expireAtBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'expireAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  isTmpTokenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isTmpToken', value: value),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'localEncryptedPrivateKey'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'localEncryptedPrivateKey'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localEncryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localEncryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localEncryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localEncryptedPrivateKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'localEncryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'localEncryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'localEncryptedPrivateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'localEncryptedPrivateKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localEncryptedPrivateKey',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  localEncryptedPrivateKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'localEncryptedPrivateKey',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'md5Password'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'md5Password'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'md5Password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'md5Password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'md5Password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'md5Password',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'md5Password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'md5Password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'md5Password',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'md5Password',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'md5Password', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  md5PasswordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'md5Password', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'refreshToken'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'refreshToken'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'refreshToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'refreshToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'refreshToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'refreshToken',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'refreshToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'refreshToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'refreshToken',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'refreshToken',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'refreshToken', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  refreshTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'refreshToken', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  tokenEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'token',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  tokenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'token',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  tokenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'token',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  tokenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'token',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  tokenStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'token',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  tokenEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'token',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  tokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'token',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  tokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'token',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  tokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'token', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  tokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'token', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'userAvatar'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'userAvatar'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userAvatar',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userAvatar',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userAvatar', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userAvatarIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userAvatar', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'userEmail'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'userEmail'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userEmail',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userEmail',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userEmail',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userEmail', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userEmail', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'userFullName'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'userFullName'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'userFullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'userFullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'userFullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'userFullName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'userFullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'userFullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'userFullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'userFullName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'userFullName', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  userFullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'userFullName', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'workspaceId'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'workspaceId'),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'workspaceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'workspaceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'workspaceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'workspaceId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'workspaceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'workspaceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'workspaceId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'workspaceId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workspaceId', value: ''),
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterFilterCondition>
  workspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'workspaceId', value: ''),
      );
    });
  }
}

extension SessionEntityQueryObject
    on QueryBuilder<SessionEntity, SessionEntity, QFilterCondition> {}

extension SessionEntityQueryLinks
    on QueryBuilder<SessionEntity, SessionEntity, QFilterCondition> {}

extension SessionEntityQuerySortBy
    on QueryBuilder<SessionEntity, SessionEntity, QSortBy> {
  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByAccountUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountUserId', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByAccountUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountUserId', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByEncryptedPrivateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivateKey', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByEncryptedPrivateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivateKey', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> sortByExpireAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expireAt', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByExpireAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expireAt', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> sortByIsTmpToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTmpToken', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByIsTmpTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTmpToken', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByLocalEncryptedPrivateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localEncryptedPrivateKey', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByLocalEncryptedPrivateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localEncryptedPrivateKey', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> sortByMd5Password() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'md5Password', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByMd5PasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'md5Password', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByRefreshToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshToken', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByRefreshTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshToken', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> sortByToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> sortByTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> sortByUserAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAvatar', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByUserAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAvatar', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> sortByUserEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userEmail', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByUserEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userEmail', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByUserFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userFullName', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByUserFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userFullName', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> sortByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  sortByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension SessionEntityQuerySortThenBy
    on QueryBuilder<SessionEntity, SessionEntity, QSortThenBy> {
  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByAccountUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountUserId', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByAccountUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountUserId', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByEncryptedPrivateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivateKey', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByEncryptedPrivateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'encryptedPrivateKey', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenByExpireAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expireAt', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByExpireAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expireAt', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenByIsTmpToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTmpToken', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByIsTmpTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTmpToken', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByLocalEncryptedPrivateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localEncryptedPrivateKey', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByLocalEncryptedPrivateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localEncryptedPrivateKey', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenByMd5Password() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'md5Password', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByMd5PasswordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'md5Password', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByRefreshToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshToken', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByRefreshTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'refreshToken', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenByToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenByTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'token', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenByUserAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAvatar', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByUserAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userAvatar', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenByUserEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userEmail', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByUserEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userEmail', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByUserFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userFullName', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByUserFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userFullName', Sort.desc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy> thenByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QAfterSortBy>
  thenByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension SessionEntityQueryWhereDistinct
    on QueryBuilder<SessionEntity, SessionEntity, QDistinct> {
  QueryBuilder<SessionEntity, SessionEntity, QDistinct>
  distinctByAccountUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'accountUserId',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct>
  distinctByEncryptedPrivateKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'encryptedPrivateKey',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct> distinctByExpireAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expireAt');
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct> distinctByIsTmpToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTmpToken');
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct>
  distinctByLocalEncryptedPrivateKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'localEncryptedPrivateKey',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct> distinctByMd5Password({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'md5Password', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct> distinctByRefreshToken({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'refreshToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct> distinctByToken({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'token', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct> distinctByUserAvatar({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userAvatar', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct> distinctByUserEmail({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userEmail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct> distinctByUserFullName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userFullName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SessionEntity, SessionEntity, QDistinct> distinctByWorkspaceId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workspaceId', caseSensitive: caseSensitive);
    });
  }
}

extension SessionEntityQueryProperty
    on QueryBuilder<SessionEntity, SessionEntity, QQueryProperty> {
  QueryBuilder<SessionEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SessionEntity, String, QQueryOperations>
  accountUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountUserId');
    });
  }

  QueryBuilder<SessionEntity, String?, QQueryOperations>
  encryptedPrivateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'encryptedPrivateKey');
    });
  }

  QueryBuilder<SessionEntity, int?, QQueryOperations> expireAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expireAt');
    });
  }

  QueryBuilder<SessionEntity, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<SessionEntity, bool, QQueryOperations> isTmpTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTmpToken');
    });
  }

  QueryBuilder<SessionEntity, String?, QQueryOperations>
  localEncryptedPrivateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localEncryptedPrivateKey');
    });
  }

  QueryBuilder<SessionEntity, String?, QQueryOperations> md5PasswordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'md5Password');
    });
  }

  QueryBuilder<SessionEntity, String?, QQueryOperations>
  refreshTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'refreshToken');
    });
  }

  QueryBuilder<SessionEntity, String, QQueryOperations> tokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'token');
    });
  }

  QueryBuilder<SessionEntity, String?, QQueryOperations> userAvatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userAvatar');
    });
  }

  QueryBuilder<SessionEntity, String?, QQueryOperations> userEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userEmail');
    });
  }

  QueryBuilder<SessionEntity, String?, QQueryOperations>
  userFullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userFullName');
    });
  }

  QueryBuilder<SessionEntity, String?, QQueryOperations> workspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workspaceId');
    });
  }
}
