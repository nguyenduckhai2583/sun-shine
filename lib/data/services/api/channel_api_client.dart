import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sun_shine/core.dart';

part 'channel_api_client.g.dart';

@RestApi(baseUrl: '/chat-services', callAdapter: ResultCallAdapter)
abstract class ChannelApiClient {
  factory ChannelApiClient(Dio dio, {String? baseUrl}) = _ChannelApiClient;

  /// Channels of the active workspace; the workspace header is attached by
  /// [AuthInterceptor].
  @GET('/channels')
  Future<Result<List<ChannelApiModel>>> getChannels();

  /// Answers with an empty body, so callers keep their own copy up to date.
  @PUT('/channels/{channelId}')
  Future<Result<void>> updateChannel(
    @Path('channelId') String channelId,
    @Body() ChannelUpdateRequest request,
  );
}

class ChannelNotFoundException implements Exception {
  const ChannelNotFoundException(this.channelId);

  final String channelId;

  @override
  String toString() => 'ChannelNotFoundException($channelId)';
}

class InvalidChannelNameException implements Exception {
  const InvalidChannelNameException(this.name);

  final String name;

  @override
  String toString() => 'InvalidChannelNameException($name)';
}
