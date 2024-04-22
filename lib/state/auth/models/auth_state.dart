class AuthState {
  final bool isLoading;
  final bool isAuth;
  final String? error;

  AuthState({
    required this.isLoading,
    required this.isAuth,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuth,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuth: isAuth ?? this.isAuth,
      error: error ?? this.error,
    );
  }

  factory AuthState.initial() {
    return AuthState(
      isLoading: false,
      isAuth: false,
    );
  }
}
