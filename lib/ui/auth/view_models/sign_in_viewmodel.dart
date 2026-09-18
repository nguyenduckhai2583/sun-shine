import 'package:sun_shine/core.dart';

typedef Credentials = ({String email, String password});

class SignInViewModel extends BaseViewModel {
  SignInViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    signIn = Command1(_signIn);
  }

  final AuthRepository _authRepository;

  late final Command1<Session, Credentials> signIn;

  Future<Result<Session>> _signIn(Credentials credentials) {
    return _authRepository.signIn(credentials.email, credentials.password);
  }
}
