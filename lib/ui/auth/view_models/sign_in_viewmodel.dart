import 'package:sun_shine/core.dart';

typedef Credentials = ({String email, String password});

class SignInViewModel extends BaseViewModel {
  SignInViewModel({
    required SignInUseCase signInUseCase,
    required SignInFlowUseCase signInFlowUseCase,
    required FinalizeSessionUseCase finalizeSessionUseCase,
  }) : _signInUseCase = signInUseCase,
       _signInFlowUseCase = signInFlowUseCase,
       _finalizeSessionUseCase = finalizeSessionUseCase {
    signIn = Command1(_signIn);
    _isAddingAccount = _signInFlowUseCase.isAddingAccount;
  }

  final SignInUseCase _signInUseCase;
  final SignInFlowUseCase _signInFlowUseCase;
  final FinalizeSessionUseCase _finalizeSessionUseCase;

  late final Command1<bool, Credentials> signIn;

  late final bool _isAddingAccount;

  bool get isAddingAccount => _isAddingAccount;

  void cancel() => _signInFlowUseCase.cancel();

  Future<Result<bool>> _signIn(Credentials credentials) async {
    final result = await _signInUseCase.signIn(
      email: credentials.email.trim(),
      password: credentials.password,
    );

    switch (result) {
      case Error(:final error):
        return Result.error(error);
      case Ok(value: final needsSecondFactor):
        if (needsSecondFactor) return const Result.ok(true);
        final finalized = await _finalizeSessionUseCase.execute();
        return switch (finalized) {
          Ok() => const Result.ok(false),
          Error(:final error) => Result.error(error),
        };
    }
  }
}
