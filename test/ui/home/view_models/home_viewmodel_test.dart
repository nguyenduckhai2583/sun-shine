import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/fakes/fake_workspace_repository.dart';

void main() {
  group('HomeViewModel', () {
    late FakeWorkspaceRepository repository;
    setUp(() => repository = FakeWorkspaceRepository());
    test('loads workspaces on construction and selects the first', () async {
      final viewModel = HomeViewModel(workspaceRepository: repository);
      addTearDown(viewModel.dispose);
      await viewModel.load.execute();
      expect(viewModel.load.completed, isTrue);
      expect(viewModel.workspaces, FakeWorkspaceRepository.defaultWorkspaces);
      expect(viewModel.selectedWorkspace?.id, 'ws_1');
    });
    test('exposes the failure through the load command', () async {
      repository.failure = Exception('boom');
      final viewModel = HomeViewModel(workspaceRepository: repository);
      addTearDown(viewModel.dispose);
      await viewModel.load.execute();
      expect(viewModel.load.error, isTrue);
      expect(viewModel.workspaces, isEmpty);
      expect(viewModel.selectedWorkspace, isNull);
    });
    test('selectWorkspace switches the selection and notifies', () async {
      final viewModel = HomeViewModel(workspaceRepository: repository);
      addTearDown(viewModel.dispose);
      await viewModel.load.execute();
      var notifications = 0;
      viewModel.addListener(() => notifications++);
      viewModel.selectWorkspace('ws_2');
      expect(viewModel.selectedWorkspace?.name, 'Design Team');
      expect(notifications, 1);
    });
    test('selectWorkspace ignores the already-selected id', () async {
      final viewModel = HomeViewModel(workspaceRepository: repository);
      addTearDown(viewModel.dispose);
      await viewModel.load.execute();
      var notifications = 0;
      viewModel.addListener(() => notifications++);
      viewModel.selectWorkspace('ws_1');
      expect(notifications, 0);
    });
    test('selectWorkspace ignores an unknown id', () async {
      final viewModel = HomeViewModel(workspaceRepository: repository);
      addTearDown(viewModel.dispose);
      await viewModel.load.execute();
      viewModel.selectWorkspace('does_not_exist');
      expect(viewModel.selectedWorkspace?.id, 'ws_1');
    });
    test('workspaces getter is unmodifiable', () async {
      final viewModel = HomeViewModel(workspaceRepository: repository);
      addTearDown(viewModel.dispose);
      await viewModel.load.execute();
      expect(
        () => viewModel.workspaces.add(const Workspace(id: 'x', name: 'X')),
        throwsUnsupportedError,
      );
    });
  });
}
