import 'package:isar_community/isar.dart';
import 'package:sun_shine/core.dart';

part 'workspace_entity.g.dart';

/// Cached workspaces, one row per (account, workspace) pair so the drawer can
/// list every signed-in account without hitting the network.
@Collection()
class WorkspaceEntity {
  WorkspaceEntity({
    required this.accountUserId,
    required this.workspaceId,
    required this.name,
    this.unreadCount = 0,
    this.position = 0,
  });

  factory WorkspaceEntity.fromDomain(
    Workspace workspace, {
    required String accountUserId,
    required int position,
  }) {
    return WorkspaceEntity(
      accountUserId: accountUserId,
      workspaceId: workspace.id,
      name: workspace.name,
      unreadCount: workspace.unreadCount,
      position: position,
    );
  }

  Id id = Isar.autoIncrement;

  @Index(
    unique: true,
    replace: true,
    composite: [CompositeIndex('workspaceId')],
  )
  String accountUserId;

  String workspaceId;
  String name;
  int unreadCount;
  int position;

  Workspace toDomain() =>
      Workspace(id: workspaceId, name: name, unreadCount: unreadCount);
}
