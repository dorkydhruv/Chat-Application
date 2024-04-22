import 'package:chat_app/state/auth/models/auth_state.dart';
import 'package:chat_app/state/auth/notifier/auth_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
    (_) => AuthStateNotifier());
