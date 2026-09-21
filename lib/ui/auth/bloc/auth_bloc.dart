import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../domain/models/user.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => const [];
}

/// Fired once, by the bloc itself, to start following the repository.
final class AuthSubscribed extends AuthEvent {
  const AuthSubscribed();
}

final class AuthSignedOut extends AuthEvent {
  const AuthSignedOut();
}

/// One state class, not a sealed hierarchy: it holds data, and `copyWith`
/// makes the next value.
final class AuthState extends Equatable {
  const AuthState({this.user});

  final User? user;

  bool get isSignedIn => user != null;

  AuthState copyWith({User? Function()? user}) =>
      AuthState(user: user == null ? this.user : user());

  @override
  List<Object?> get props => [user];
}

/// Holds the session for the UI. The repository is still the source of
/// truth; this only mirrors it into bloc-land.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState()) {
    on<AuthSubscribed>(_onSubscribed);
    on<AuthSignedOut>(_onSignedOut);

    add(const AuthSubscribed());
  }

  final AuthRepository _authRepository;

  /// `emit.forEach` keeps this handler alive for as long as the stream is,
  /// and cancels the subscription when the bloc closes. It is the bloc way
  /// of holding a StreamSubscription without holding one.
  Future<void> _onSubscribed(AuthSubscribed event, Emitter<AuthState> emit) =>
      emit.forEach(
        _authRepository.user,
        onData: (user) => state.copyWith(user: () => user),
      );

  void _onSignedOut(AuthSignedOut event, Emitter<AuthState> emit) =>
      _authRepository.signOut();
}
