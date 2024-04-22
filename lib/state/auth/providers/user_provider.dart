import 'package:chat_app/state/auth/providers/auth_state_provider.dart';
import 'package:chat_app/state/user/models/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProvider =
    Provider<User?>((ref) => ref.watch(authStateProvider).user);
