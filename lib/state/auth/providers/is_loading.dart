import 'package:chat_app/state/auth/providers/auth_state_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final isLoading =
    Provider<bool>((ref) => ref.watch(authStateProvider).isLoading);
