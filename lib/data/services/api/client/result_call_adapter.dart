import 'package:retrofit/retrofit.dart';
import 'package:sun_shine/core.dart';

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
