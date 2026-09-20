import 'package:material_ui/material_ui.dart';
import 'package:sun_shine/core.dart';

class ChannelsScreen extends StatelessWidget {
  const ChannelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              ChannelsViewModel(channelRepository: context.read()),
        ),
      ],
      child: const _ChannelsView(),
    );
  }
}

class _ChannelsView extends StatelessWidget {
  const _ChannelsView();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChannelsViewModel>();

    return TabScaffold(
      tab: HomeTab.channels,
      body: ListenableBuilder(
        listenable: viewModel.load,
        builder: (context, _) {
          if (viewModel.load.running) {
            return const Center(child: CircularProgressIndicator());
          }
          if (viewModel.load.error) {
            return ErrorIndicator(
              title: 'Could not load channels',
              onRetry: viewModel.load.execute,
            );
          }
          return _ChannelList(channels: viewModel.channels);
        },
      ),
    );
  }
}

class _ChannelList extends StatelessWidget {
  const _ChannelList({required this.channels});

  final List<Channel> channels;

  @override
  Widget build(BuildContext context) {
    if (channels.isEmpty) {
      return const PlaceholderTab(
        icon: Icons.tag,
        title: 'No channels yet',
        message: 'Channels you join will show up here.',
      );
    }

    return ListView.separated(
      itemCount: channels.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final channel = channels[index];
        return _ChannelTile(channel: channel);
      },
    );
  }
}

class _ChannelTile extends StatelessWidget {
  const _ChannelTile({required this.channel});

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: () => context.push(Routes.channelDetail(channel.id)),
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        foregroundColor: theme.colorScheme.onSurfaceVariant,
        child: const Icon(Icons.tag, size: 18),
      ),
      title: Text(channel.displayName),
      subtitle: channel.topic.isEmpty
          ? null
          : Text(channel.topic, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Text(
        '${channel.memberCount}',
        style: theme.textTheme.labelMedium,
      ),
    );
  }
}
