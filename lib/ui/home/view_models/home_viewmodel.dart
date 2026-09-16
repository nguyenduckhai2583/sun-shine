import 'package:flutter/foundation.dart';
import 'package:sun_shine/core.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required WorkspaceRepository workspaceRepository})
    : _workspaceRepository = workspaceRepository {
    load = Command0(_load)..execute();
  }

  final WorkspaceRepository _workspaceRepository;

  late final Command0<List<Workspace>> load;

  List<Workspace> _workspaces = const [];

  List<Workspace> get workspaces => List.unmodifiable(_workspaces);

  Workspace? _selectedWorkspace;

  Workspace? get selectedWorkspace => _selectedWorkspace;

  void selectWorkspace(String workspaceId) {
    if (_selectedWorkspace?.id == workspaceId) return;
    final matches = _workspaces.where((w) => w.id == workspaceId);
    if (matches.isEmpty) return;
    _selectedWorkspace = matches.first;
    notifyListeners();
  }

  Future<Result<List<Workspace>>> _load() async {
    final result = await _workspaceRepository.getWorkspaces();
    switch (result) {
      case Ok<List<Workspace>>():
        _workspaces = result.value;
        if (_selectedWorkspace == null && _workspaces.isNotEmpty) {
          _selectedWorkspace = _workspaces.first;
        }
        notifyListeners();
      case Error<List<Workspace>>():
        break;
    }
    return result;
  }
}
