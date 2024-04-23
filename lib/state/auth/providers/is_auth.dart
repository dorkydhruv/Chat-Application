import 'package:chat_app/state/auth/providers/auth_state_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final isAuthenticated = Provider((ref) {
  return ref.watch(authStateProvider).isAuth;
});
