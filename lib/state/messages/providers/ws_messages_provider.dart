import 'dart:async';
import 'package:chat_app/state/messages/message.dart';
import 'package:chat_app/state/messages/providers/ws_connection_provider.dart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../chat/models/chat.dart';

final wsChatProvider = StreamProvider.family<List<Message>, Chat>((ref, chat) {
  final controller = StreamController<List<Message>>();
  final messages = <Message>[];
  final ws = ref.watch(wsConnectionProvider(chat));
  ws.stream.listen(
    (data) {
      final message = Message.fromJson(data);
      messages.add(message);
      controller.add([...messages, message]);
    },
    onDone: () {
      ws.sink.close();
    },
  );
  return controller.stream;
});
