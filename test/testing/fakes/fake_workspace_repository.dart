import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

class FakeWorkspaceRepository implements WorkspaceRepository {
  FakeWorkspaceRepository({List<Workspace>? workspaces, this.failure})
    : workspaces = workspaces ?? defaultWorkspaces;

  static const defaultWorkspaces = [
    Workspace(id: 'ws_1', name: 'Sun Shine', unreadCount: 3),
    Workspace(id: 'ws_2', name: 'Design Team'),
  ];

  List<Workspace> workspaces;
  Exception? failure;

  final _byAccount = BehaviorSubject<Map<String, List<Workspace>>>.seeded(
    const {},
  );

  int refreshCallCount = 0;
  final List<String> refreshedAccounts = [];
  final List<String?> refreshedTokens = [];
  final List<String> removedAccounts = [];
  int restoreCount = 0;
  int clearCount = 0;

  void dispose() => _byAccount.close();

  void seed(String accountUserId, List<Workspace> workspaces) {
    _byAccount.add({..._byAccount.value, accountUserId: workspaces});
  }

  @override
  Stream<Map<String, List<Workspace>>> get workspacesByAccount =>
      _byAccount.stream;

  @override
  Stream<List<Workspace>> watchWorkspacesOf(String accountUserId) => _byAccount
      .stream
      .map((byAccount) => byAccount[accountUserId] ?? const <Workspace>[]);

  @override
  List<Workspace> workspacesOf(String accountUserId) =>
      _byAccount.value[accountUserId] ?? const [];

  @override
  Future<void> restore() async => restoreCount++;

  @override
  Future<Result<List<Workspace>>> refresh(
    String accountUserId, {
    String? token,
  }) async {
    refreshCallCount++;
    refreshedAccounts.add(accountUserId);
    refreshedTokens.add(token);

    final failure = this.failure;
    if (failure != null) return Result.error(failure);

    seed(accountUserId, workspaces);
    return Result.ok(workspaces);
  }

  @override
  Future<void> removeAccount(String accountUserId) async {
    removedAccounts.add(accountUserId);
    _byAccount.add({..._byAccount.value}..remove(accountUserId));
  }

  final List<Set<String>> pruneCalls = [];

  @override
  Future<void> pruneExcept(Set<String> accountUserIds) async {
    pruneCalls.add(accountUserIds);
    final next = {..._byAccount.value}
      ..removeWhere(
        (accountUserId, _) => !accountUserIds.contains(accountUserId),
      );
    _byAccount.add(next);
  }

  @override
  Future<void> clear() async {
    clearCount++;
    _byAccount.add(const {});
  }
}
