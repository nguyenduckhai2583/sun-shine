import 'package:sun_shine/core.dart';

abstract class WorkspaceRepository {
  Stream<Map<String, List<Workspace>>> get workspacesByAccount;

  Stream<List<Workspace>> watchWorkspacesOf(String accountUserId);

  List<Workspace> workspacesOf(String accountUserId);

  Future<void> restore();

  /// Fetches [accountUserId]'s workspaces and caches them. Pass [token] to
  /// refresh an account that is not the active one.
  Future<Result<List<Workspace>>> refresh(
    String accountUserId, {
    String? token,
  });

  Future<void> removeAccount(String accountUserId);

  /// Drops the cache of every account outside [accountUserIds].
  Future<void> pruneExcept(Set<String> accountUserIds);

  Future<void> clear();
}
