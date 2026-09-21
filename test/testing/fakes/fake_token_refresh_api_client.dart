import 'package:sun_shine/core.dart';

class FakeTokenRefreshApiClient implements TokenRefreshApiClient {
  FakeTokenRefreshApiClient({this.response, this.failure});

  SessionApiModel? response;
  Exception? failure;

  final List<String> refreshTokens = [];

  @override
  Future<Result<SessionApiModel>> refresh(String refreshToken) async {
    refreshTokens.add(refreshToken);

    final failure = this.failure;
    if (failure != null) return Result.error(failure);

    final response = this.response;
    if (response == null) {
      return const Result.error(ApiException(error: ApiErrorEnum.unknown));
    }
    return Result.ok(response);
  }
}
