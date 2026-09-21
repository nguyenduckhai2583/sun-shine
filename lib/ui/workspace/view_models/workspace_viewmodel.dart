import 'dart:async';

import 'package:collection/collection.dart';
import 'package:sun_shine/core.dart';

class WorkspaceViewModel extends BaseViewModel {
  WorkspaceViewModel({
    required WatchAccountsUseCase watchAccountsUseCase,
    required RefreshAccountWorkspacesUseCase refreshAccountWorkspacesUseCase,
    required SelectWorkspaceUseCase selectWorkspaceUseCase,
    required SignOutUseCase signOutUseCase,
  }) : _refreshAccountWorkspacesUseCase = refreshAccountWorkspacesUseCase,
       _selectWorkspaceUseCase = selectWorkspaceUseCase,
       _signOutUseCase = signOutUseCase {
    _onAccounts(watchAccountsUseCase.current());
    _subscription = watchAccountsUseCase.execute().listen(_onAccounts);
    load = Command0(_load)..execute();
    submit = Command0(_submit);
  }

  final RefreshAccountWorkspacesUseCase _refreshAccountWorkspacesUseCase;
  final SelectWorkspaceUseCase _selectWorkspaceUseCase;
  final SignOutUseCase _signOutUseCase;

  late final StreamSubscription<List<AccountGroup>> _subscription;

  late final Command0<List<Workspace>> load;

  late final Command0<Session> submit;

  AccountGroup? _account;

  String? _selectedWorkspaceId;

  List<Workspace> get workspaces => _account?.workspaces ?? const [];

  String? get accountUserId => _account?.session.userId;

  String? get selectedWorkspaceId => _selectedWorkspaceId;

  Workspace? get selectedWorkspace => workspaces.firstWhereOrNull(
    (workspace) => workspace.id == _selectedWorkspaceId,
  );

  bool get canSubmit => selectedWorkspace != null;

  bool get isEmpty => workspaces.isEmpty;

  void select(String workspaceId) {
    if (_selectedWorkspaceId == workspaceId) return;
    _selectedWorkspaceId = workspaceId;
    notifyListeners();
  }

  Future<void> signOut() => _signOutUseCase.signOutActive();

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }

  void _onAccounts(List<AccountGroup> accounts) {
    _account = accounts.firstWhereOrNull((account) => account.isActive);
    // Whatever the session already points at wins, so coming back here from
    // the drawer shows the workspace the account is actually in.
    _selectedWorkspaceId ??= _account?.session.workspaceId;
    notifyListeners();
  }

  Future<Result<List<Workspace>>> _load() =>
      _refreshAccountWorkspacesUseCase.execute();

  Future<Result<Session>> _submit() async {
    final accountUserId = this.accountUserId;
    final workspaceId = _selectedWorkspaceId;
    if (accountUserId == null || workspaceId == null) {
      return const Result.error(ApiException(error: ApiErrorEnum.unknown));
    }
    return _selectWorkspaceUseCase.execute(
      accountUserId: accountUserId,
      workspaceId: workspaceId,
    );
  }
}
