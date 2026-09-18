import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class ChannelDetailScreen extends StatelessWidget {
  const ChannelDetailScreen({super.key, required this.channelId});

  final String channelId;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: channelDetailProviders(channelId),
      child: const _ChannelDetailView(),
    );
  }
}

class _ChannelDetailView extends StatefulWidget {
  const _ChannelDetailView();

  @override
  State<_ChannelDetailView> createState() => _ChannelDetailViewState();
}

class _ChannelDetailViewState extends State<_ChannelDetailView> {
  late final ChannelDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ChannelDetailViewModel>();
    _viewModel.rename.addListener(_onRenameResult);
  }

  @override
  void dispose() {
    _viewModel.rename.removeListener(_onRenameResult);
    super.dispose();
  }

  void _onRenameResult() {
    if (!_viewModel.rename.error) return;
    _viewModel.rename.clearResult();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not rename the channel')),
    );
  }

  Future<void> _onRenamePressed() async {
    final channel = _viewModel.channel;
    if (channel == null) return;

    final name = await showDialog<String>(
      context: context,
      builder: (context) => RenameDialog(
        title: 'Rename channel',
        label: 'Name',
        prefixText: '#',
        allowSpaces: false,
        initialValue: channel.name,
      ),
    );
    if (name == null) return;

    await _viewModel.rename.execute(name);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChannelDetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          viewModel.channel?.displayName ?? '#${viewModel.channelId}',
        ),
        actions: [
          if (viewModel.channel != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Rename channel',
              onPressed: viewModel.rename.running ? null : _onRenamePressed,
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: viewModel.load,
        builder: (context, _) {
          if (viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.load.error) {
            return ErrorIndicator(
              title: 'Could not load #${viewModel.channelId}',
              onRetry: viewModel.load.execute,
            );
          }
          return _ChannelBody(channel: viewModel.channel!);
        },
      ),
    );
  }
}

class _ChannelBody extends StatelessWidget {
  const _ChannelBody({required this.channel});

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tag, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(channel.displayName, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              channel.topic,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${channel.memberCount} members',
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
