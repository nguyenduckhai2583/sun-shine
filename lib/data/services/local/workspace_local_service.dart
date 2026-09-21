import 'package:collection/collection.dart';
import 'package:isar_community/isar.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

class WorkspaceLocalService extends BaseIsarService<WorkspaceEntity> {
  WorkspaceLocalService({super.isar});

  static const _equality = DeepCollectionEquality();

  final _workspaces = BehaviorSubject<Map<String, List<Workspace>>>.seeded(
    const {},
  );

  Stream<Map<String, List<Workspace>>> get workspacesByAccount =>
      _workspaces.stream.distinct(_equality.equals);

  Map<String, List<Workspace>> get value => _workspaces.value;

  List<Workspace> workspacesOf(String accountUserId) =>
      _workspaces.value[accountUserId] ?? const [];

  Stream<List<Workspace>> watchWorkspacesOf(String accountUserId) => _workspaces
      .stream
      .map((byAccount) => byAccount[accountUserId] ?? const <Workspace>[])
      .distinct(_equality.equals);

  Future<void> restore() async {
    final collection = this.collection;
    if (collection == null) return;

    final rows = await collection.where().findAll();
    _workspaces.add(_group(rows));
  }

  Future<void> setWorkspaces(
    String accountUserId,
    List<Workspace> workspaces,
  ) async {
    final next = Map<String, List<Workspace>>.from(_workspaces.value)
      ..[accountUserId] = List.unmodifiable(workspaces);
    if (!_equality.equals(next, _workspaces.value)) _workspaces.add(next);

    await write((collection) async {
      final stale = await collection
          .filter()
          .accountUserIdEqualTo(accountUserId)
          .idProperty()
          .findAll();
      await collection.deleteAll(stale);
      await collection.putAll([
        for (final (index, workspace) in workspaces.indexed)
          WorkspaceEntity.fromDomain(
            workspace,
            accountUserId: accountUserId,
            position: index,
          ),
      ]);
    });
  }

  Future<void> removeAccount(String accountUserId) async {
    if (!_workspaces.value.containsKey(accountUserId)) return;
    _workspaces.add(
      Map<String, List<Workspace>>.from(_workspaces.value)
        ..remove(accountUserId),
    );

    await write((collection) async {
      final ids = await collection
          .filter()
          .accountUserIdEqualTo(accountUserId)
          .idProperty()
          .findAll();
      await collection.deleteAll(ids);
    });
  }

  /// Drops cached workspaces belonging to accounts that are no longer signed
  /// in. Needed because an account can be dropped without going through
  /// [SignOutUseCase] — a failed token refresh evicts it straight from the
  /// session repository.
  Future<void> pruneExcept(Set<String> accountUserIds) async {
    final orphans = _workspaces.value.keys
        .where((accountUserId) => !accountUserIds.contains(accountUserId))
        .toList();
    if (orphans.isEmpty) return;

    final next = Map<String, List<Workspace>>.from(_workspaces.value);
    for (final orphan in orphans) {
      next.remove(orphan);
    }
    _workspaces.add(next);

    await write((collection) async {
      final ids = await collection
          .filter()
          .anyOf(orphans, (q, orphan) => q.accountUserIdEqualTo(orphan))
          .idProperty()
          .findAll();
      await collection.deleteAll(ids);
    });
  }

  Future<void> clear() async {
    if (_workspaces.value.isNotEmpty) _workspaces.add(const {});
    await clearCollection();
  }

  bool get isDisposed => _workspaces.isClosed;

  @override
  void dispose() {
    _workspaces.close();
    super.dispose();
  }

  Map<String, List<Workspace>> _group(List<WorkspaceEntity> rows) {
    final grouped = <String, List<WorkspaceEntity>>{};
    for (final row in rows) {
      grouped.putIfAbsent(row.accountUserId, () => []).add(row);
    }
    return {
      for (final entry in grouped.entries)
        entry.key: List.unmodifiable(
          (entry.value..sort((a, b) => a.position.compareTo(b.position))).map(
            (row) => row.toDomain(),
          ),
        ),
    };
  }
}
