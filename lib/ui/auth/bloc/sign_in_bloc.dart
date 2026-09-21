import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';

sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object?> get props => const [];
}

final class SignInSubmitted extends SignInEvent {
  const SignInSubmitted({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

final class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object?> get props => const [];
}

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  SignInBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const SignInState()) {
    on<SignInSubmitted>(_onSubmitted);
  }

  final AuthRepository _authRepository;

  /// No navigation here. The repository emits a user, AuthBloc picks it up,
  /// AuthScope re-keys, and the router lands on /students.
  Future<void> _onSubmitted(SignInSubmitted event, Emitter<SignInState> emit) =>
      _authRepository.signIn(email: event.email, password: event.password);
}
