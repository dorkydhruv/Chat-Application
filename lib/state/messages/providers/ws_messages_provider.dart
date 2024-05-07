import 'dart:async';
import 'dart:convert';
import 'package:chat_app/state/messages/message.dart';
import 'package:chat_app/state/messages/providers/ws_connection_provider.dart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../chat/models/chat.dart';

final wsChatProvider = StreamProvider.family<List<Message>, Chat>((ref, chat) {
  final controller = StreamController<List<Message>>();
  final messages = <Message>[];
  final ws = ref.read(wsConnectionProvider(chat));
  ws.stream.listen(
    (data) {
      final m = jsonDecode(data);
      final message = Message.fromJson(m);
      messages.add(message);
      controller.add([...messages, message]);
    },
    onDone: () {
      ws.sink.close();
    },
    onError: (e) => print(e),
  );
  return controller.stream;
});
