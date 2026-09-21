// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWorkspaceEntityCollection on Isar {
  IsarCollection<WorkspaceEntity> get workspaceEntitys => this.collection();
}

const WorkspaceEntitySchema = CollectionSchema(
  name: r'WorkspaceEntity',
  id: 5717724121204380916,
  properties: {
    r'accountUserId': PropertySchema(
      id: 0,
      name: r'accountUserId',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 1, name: r'name', type: IsarType.string),
    r'position': PropertySchema(id: 2, name: r'position', type: IsarType.long),
    r'unreadCount': PropertySchema(
      id: 3,
      name: r'unreadCount',
      type: IsarType.long,
    ),
    r'workspaceId': PropertySchema(
      id: 4,
      name: r'workspaceId',
      type: IsarType.string,
    ),
  },

  estimateSize: _workspaceEntityEstimateSize,
  serialize: _workspaceEntitySerialize,
  deserialize: _workspaceEntityDeserialize,
  deserializeProp: _workspaceEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'accountUserId_workspaceId': IndexSchema(
      id: 4794874671639149280,
      name: r'accountUserId_workspaceId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'accountUserId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'workspaceId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _workspaceEntityGetId,
  getLinks: _workspaceEntityGetLinks,
  attach: _workspaceEntityAttach,
  version: '3.3.2',
);

int _workspaceEntityEstimateSize(
  WorkspaceEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountUserId.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.workspaceId.length * 3;
  return bytesCount;
}

void _workspaceEntitySerialize(
  WorkspaceEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountUserId);
  writer.writeString(offsets[1], object.name);
  writer.writeLong(offsets[2], object.position);
  writer.writeLong(offsets[3], object.unreadCount);
  writer.writeString(offsets[4], object.workspaceId);
}

WorkspaceEntity _workspaceEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkspaceEntity(
    accountUserId: reader.readString(offsets[0]),
    name: reader.readString(offsets[1]),
    position: reader.readLongOrNull(offsets[2]) ?? 0,
    unreadCount: reader.readLongOrNull(offsets[3]) ?? 0,
    workspaceId: reader.readString(offsets[4]),
  );
  object.id = id;
  return object;
}

P _workspaceEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _workspaceEntityGetId(WorkspaceEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _workspaceEntityGetLinks(WorkspaceEntity object) {
  return [];
}

void _workspaceEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  WorkspaceEntity object,
) {
  object.id = id;
}

extension WorkspaceEntityByIndex on IsarCollection<WorkspaceEntity> {
  Future<WorkspaceEntity?> getByAccountUserIdWorkspaceId(
    String accountUserId,
    String workspaceId,
  ) {
    return getByIndex(r'accountUserId_workspaceId', [
      accountUserId,
      workspaceId,
    ]);
  }

  WorkspaceEntity? getByAccountUserIdWorkspaceIdSync(
    String accountUserId,
    String workspaceId,
  ) {
    return getByIndexSync(r'accountUserId_workspaceId', [
      accountUserId,
      workspaceId,
    ]);
  }

  Future<bool> deleteByAccountUserIdWorkspaceId(
    String accountUserId,
    String workspaceId,
  ) {
    return deleteByIndex(r'accountUserId_workspaceId', [
      accountUserId,
      workspaceId,
    ]);
  }

  bool deleteByAccountUserIdWorkspaceIdSync(
    String accountUserId,
    String workspaceId,
  ) {
    return deleteByIndexSync(r'accountUserId_workspaceId', [
      accountUserId,
      workspaceId,
    ]);
  }

  Future<List<WorkspaceEntity?>> getAllByAccountUserIdWorkspaceId(
    List<String> accountUserIdValues,
    List<String> workspaceIdValues,
  ) {
    final len = accountUserIdValues.length;
    assert(
      workspaceIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountUserIdValues[i], workspaceIdValues[i]]);
    }

    return getAllByIndex(r'accountUserId_workspaceId', values);
  }

  List<WorkspaceEntity?> getAllByAccountUserIdWorkspaceIdSync(
    List<String> accountUserIdValues,
    List<String> workspaceIdValues,
  ) {
    final len = accountUserIdValues.length;
    assert(
      workspaceIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountUserIdValues[i], workspaceIdValues[i]]);
    }

    return getAllByIndexSync(r'accountUserId_workspaceId', values);
  }

  Future<int> deleteAllByAccountUserIdWorkspaceId(
    List<String> accountUserIdValues,
    List<String> workspaceIdValues,
  ) {
    final len = accountUserIdValues.length;
    assert(
      workspaceIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountUserIdValues[i], workspaceIdValues[i]]);
    }

    return deleteAllByIndex(r'accountUserId_workspaceId', values);
  }

  int deleteAllByAccountUserIdWorkspaceIdSync(
    List<String> accountUserIdValues,
    List<String> workspaceIdValues,
  ) {
    final len = accountUserIdValues.length;
    assert(
      workspaceIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([accountUserIdValues[i], workspaceIdValues[i]]);
    }

    return deleteAllByIndexSync(r'accountUserId_workspaceId', values);
  }

  Future<Id> putByAccountUserIdWorkspaceId(WorkspaceEntity object) {
    return putByIndex(r'accountUserId_workspaceId', object);
  }

  Id putByAccountUserIdWorkspaceIdSync(
    WorkspaceEntity object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(
      r'accountUserId_workspaceId',
      object,
      saveLinks: saveLinks,
    );
  }

  Future<List<Id>> putAllByAccountUserIdWorkspaceId(
    List<WorkspaceEntity> objects,
  ) {
    return putAllByIndex(r'accountUserId_workspaceId', objects);
  }

  List<Id> putAllByAccountUserIdWorkspaceIdSync(
    List<WorkspaceEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(
      r'accountUserId_workspaceId',
      objects,
      saveLinks: saveLinks,
    );
  }
}

extension WorkspaceEntityQueryWhereSort
    on QueryBuilder<WorkspaceEntity, WorkspaceEntity, QWhere> {
  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WorkspaceEntityQueryWhere
    on QueryBuilder<WorkspaceEntity, WorkspaceEntity, QWhereClause> {
  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterWhereClause>
  accountUserIdEqualToAnyWorkspaceId(String accountUserId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'accountUserId_workspaceId',
          value: [accountUserId],
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterWhereClause>
  accountUserIdNotEqualToAnyWorkspaceId(String accountUserId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId_workspaceId',
                lower: [],
                upper: [accountUserId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId_workspaceId',
                lower: [accountUserId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId_workspaceId',
                lower: [accountUserId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId_workspaceId',
                lower: [],
                upper: [accountUserId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterWhereClause>
  accountUserIdWorkspaceIdEqualTo(String accountUserId, String workspaceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'accountUserId_workspaceId',
          value: [accountUserId, workspaceId],
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterWhereClause>
  accountUserIdEqualToWorkspaceIdNotEqualTo(
    String accountUserId,
    String workspaceId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId_workspaceId',
                lower: [accountUserId],
                upper: [accountUserId, workspaceId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId_workspaceId',
                lower: [accountUserId, workspaceId],
                includeLower: false,
                upper: [accountUserId],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId_workspaceId',
                lower: [accountUserId, workspaceId],
                includeLower: false,
                upper: [accountUserId],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'accountUserId_workspaceId',
                lower: [accountUserId],
                upper: [accountUserId, workspaceId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension WorkspaceEntityQueryFilter
    on QueryBuilder<WorkspaceEntity, WorkspaceEntity, QFilterCondition> {
  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  accountUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountUserId', value: ''),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  accountUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'accountUserId', value: ''),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  positionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'position', value: value),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  positionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'position',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  positionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'position',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  positionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'position',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  unreadCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unreadCount', value: value),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  unreadCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unreadCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  unreadCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unreadCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  unreadCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unreadCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  workspaceIdEqualTo(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  workspaceIdGreaterThan(
    String value, {
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  workspaceIdLessThan(
    String value, {
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  workspaceIdBetween(
    String lower,
    String upper, {
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
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

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  workspaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workspaceId', value: ''),
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterFilterCondition>
  workspaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'workspaceId', value: ''),
      );
    });
  }
}

extension WorkspaceEntityQueryObject
    on QueryBuilder<WorkspaceEntity, WorkspaceEntity, QFilterCondition> {}

extension WorkspaceEntityQueryLinks
    on QueryBuilder<WorkspaceEntity, WorkspaceEntity, QFilterCondition> {}

extension WorkspaceEntityQuerySortBy
    on QueryBuilder<WorkspaceEntity, WorkspaceEntity, QSortBy> {
  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  sortByAccountUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountUserId', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  sortByAccountUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountUserId', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  sortByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  sortByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  sortByUnreadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadCount', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  sortByUnreadCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadCount', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  sortByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  sortByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension WorkspaceEntityQuerySortThenBy
    on QueryBuilder<WorkspaceEntity, WorkspaceEntity, QSortThenBy> {
  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  thenByAccountUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountUserId', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  thenByAccountUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountUserId', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  thenByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  thenByPositionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'position', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  thenByUnreadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadCount', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  thenByUnreadCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadCount', Sort.desc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  thenByWorkspaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.asc);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QAfterSortBy>
  thenByWorkspaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workspaceId', Sort.desc);
    });
  }
}

extension WorkspaceEntityQueryWhereDistinct
    on QueryBuilder<WorkspaceEntity, WorkspaceEntity, QDistinct> {
  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QDistinct>
  distinctByAccountUserId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'accountUserId',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QDistinct>
  distinctByPosition() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'position');
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QDistinct>
  distinctByUnreadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unreadCount');
    });
  }

  QueryBuilder<WorkspaceEntity, WorkspaceEntity, QDistinct>
  distinctByWorkspaceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workspaceId', caseSensitive: caseSensitive);
    });
  }
}

extension WorkspaceEntityQueryProperty
    on QueryBuilder<WorkspaceEntity, WorkspaceEntity, QQueryProperty> {
  QueryBuilder<WorkspaceEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WorkspaceEntity, String, QQueryOperations>
  accountUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountUserId');
    });
  }

  QueryBuilder<WorkspaceEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<WorkspaceEntity, int, QQueryOperations> positionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'position');
    });
  }

  QueryBuilder<WorkspaceEntity, int, QQueryOperations> unreadCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unreadCount');
    });
  }

  QueryBuilder<WorkspaceEntity, String, QQueryOperations>
  workspaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workspaceId');
    });
  }
}
