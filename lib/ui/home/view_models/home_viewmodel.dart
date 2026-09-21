import 'dart:async';

import 'package:collection/collection.dart';
import 'package:sun_shine/core.dart';

typedef WorkspaceSelection = ({String accountUserId, String workspaceId});

class HomeViewModel extends BaseViewModel {
  HomeViewModel({
    required WatchAccountsUseCase watchAccountsUseCase,
    required SelectWorkspaceUseCase selectWorkspaceUseCase,
    required RefreshAccountWorkspacesUseCase refreshAccountWorkspacesUseCase,
    required SignOutUseCase signOutUseCase,
    required SignInFlowUseCase signInFlowUseCase,
  }) : _selectWorkspaceUseCase = selectWorkspaceUseCase,
       _refreshAccountWorkspacesUseCase = refreshAccountWorkspacesUseCase,
       _signOutUseCase = signOutUseCase,
       _signInFlowUseCase = signInFlowUseCase {
    _accounts = watchAccountsUseCase.current();
    _subscription = watchAccountsUseCase.execute().listen(_onAccounts);
    load = Command0(_load)..execute();
    selectWorkspace = Command1(_selectWorkspace);
  }

  final SelectWorkspaceUseCase _selectWorkspaceUseCase;
  final RefreshAccountWorkspacesUseCase _refreshAccountWorkspacesUseCase;
  final SignOutUseCase _signOutUseCase;
  final SignInFlowUseCase _signInFlowUseCase;

  late final StreamSubscription<List<AccountGroup>> _subscription;

  late final Command0<List<Workspace>> load;

  late final Command1<Session, WorkspaceSelection> selectWorkspace;

  List<AccountGroup> _accounts = const [];

  List<AccountGroup> get accounts => List.unmodifiable(_accounts);

  bool get hasMultipleAccounts => _accounts.length > 1;

  AccountGroup? get activeAccount =>
      _accounts.firstWhereOrNull((account) => account.isActive);

  String? get activeUserId => activeAccount?.session.userId;

  List<Workspace> get workspaces => activeAccount?.workspaces ?? const [];

  String? get selectedWorkspaceId => activeAccount?.session.workspaceId;

  Workspace? get selectedWorkspace => workspaces.firstWhereOrNull(
    (workspace) => workspace.id == selectedWorkspaceId,
  );

  void addAccount() => _signInFlowUseCase.beginAddAccount();

  Future<void> signOutActive() => _signOutUseCase.signOutActive();

  Future<void> signOutAccount(String userId) =>
      _signOutUseCase.signOutAccount(userId);

  Future<void> signOutAll() => _signOutUseCase.signOutAll();

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }

  void _onAccounts(List<AccountGroup> accounts) {
    _accounts = accounts;
    notifyListeners();
  }

  Future<Result<List<Workspace>>> _load() =>
      _refreshAccountWorkspacesUseCase.execute();

  Future<Result<Session>> _selectWorkspace(WorkspaceSelection selection) {
    return _selectWorkspaceUseCase.execute(
      accountUserId: selection.accountUserId,
      workspaceId: selection.workspaceId,
    );
  }
}
