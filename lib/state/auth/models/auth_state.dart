import 'package:chat_app/state/user/models/user.dart';

class AuthState {
  final bool isLoading;
  final bool isAuth;
  final String? error;
  final User? user;

  AuthState({
    required this.isLoading,
    required this.isAuth,
    this.error,
    this.user,
  });

  AuthState copyWith(
      {bool? isLoading, bool? isAuth, String? error, User? user}) {
    return AuthState(
        isLoading: isLoading ?? this.isLoading,
        isAuth: isAuth ?? this.isAuth,
        error: error ?? this.error,
        user: user ?? this.user);
  }

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isAuth: false,
    );
  }
}
