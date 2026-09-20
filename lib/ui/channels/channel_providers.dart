import 'package:provider/single_child_widget.dart';
import 'package:sun_shine/core.dart';

List<SingleChildWidget> get channelDataProviders {
  return [
    Provider(create: (context) => ChannelApiClient()),
    Provider(
      create: (context) => ChannelLocalService(),
      dispose: (context, service) => service.dispose(),
    ),
    Provider<ChannelRepository>(
      create: (context) => ChannelRepositoryImpl(
        apiClient: context.read(),
        localService: context.read(),
      ),
    ),
  ];
}

List<SingleChildWidget> get channelsProviders {
  return [
    ChangeNotifierProvider(
      create: (context) => ChannelsViewModel(channelRepository: context.read()),
    ),
  ];
}

List<SingleChildWidget> channelDetailProviders(String channelId) {
  return [
    ChangeNotifierProvider(
      create: (context) => ChannelDetailViewModel(
        channelId: channelId,
        channelRepository: context.read(),
      ),
    ),
  ];
}
