import 'package:retrofit/retrofit.dart';
import 'package:sun_shine/core.dart';

/// Adapts a retrofit call into the app's [Result], so generated API clients
/// return `Result<T>` instead of throwing.
///
/// Named in `@RestApi(callAdapter: ResultCallAdapter)`; retrofit instantiates
/// it per method, so it must have a zero-argument constructor.
class ResultCallAdapter<T> extends CallAdapter<Future<T>, Future<Result<T>>> {
  @override
  Future<Result<T>> adapt(Future<T> Function() call) async {
    try {
      return Result.ok(await call());
    } catch (error) {
      return Result.error(ApiException.from(error));
    }
  }
}
