import 'package:chat_app/state/auth/providers/user_provider.dart';
import 'package:chat_app/state/chat/models/chat.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final wsConnectionProvider =
    Provider.family<WebSocketChannel, Chat>((ref, chat) {
  final user = ref.watch(userProvider)!;
  final ws = WebSocketChannel.connect(
    Uri.parse(
      "ws://localhost:8000/chat/messages/${chat.chatId}/${user.userId}",
    ),
  );
  return ws;
});
