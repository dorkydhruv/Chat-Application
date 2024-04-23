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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.isLoading == isLoading &&
        other.isAuth == isAuth &&
        other.error == error &&
        other.user == user;
  }

  @override
  int get hashCode {
    return isLoading.hashCode ^
        isAuth.hashCode ^
        error.hashCode ^
        user.hashCode;
  }
}
