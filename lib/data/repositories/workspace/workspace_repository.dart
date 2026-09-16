import 'package:sun_shine/core.dart';

abstract class WorkspaceRepository {
  Future<Result<List<Workspace>>> getWorkspaces();

  void invalidateCache();
}
