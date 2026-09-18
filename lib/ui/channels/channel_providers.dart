import 'package:provider/single_child_widget.dart';
import 'package:sun_shine/core.dart';

List<SingleChildWidget> get channelDataProviders {
  return [
    trackedProvider((context) => ChannelApiClient()),
    trackedProvider(
      (context) => ChannelLocalService(),
      dispose: (service) => service.dispose(),
    ),
    trackedProvider<ChannelRepository>(
      (context) => ChannelRepositoryRemote(
        apiClient: context.read(),
        localService: context.read(),
      ),
    ),
  ];
}

List<SingleChildWidget> get channelsProviders {
  return [
    trackedViewModel(
      (context) => ChannelsViewModel(channelRepository: context.read()),
    ),
  ];
}

List<SingleChildWidget> channelDetailProviders(String channelId) {
  return [
    trackedViewModel(
      (context) => ChannelDetailViewModel(
        channelId: channelId,
        channelRepository: context.read(),
      ),
    ),
  ];
}
