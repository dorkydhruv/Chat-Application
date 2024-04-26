import 'dart:async';
import 'dart:math';

import 'package:chat_app/constants.dart';
import 'package:chat_app/state/auth/providers/user_provider.dart';
import 'package:chat_app/state/chat/models/chat.dart';
import 'package:chat_app/state/chat/models/message.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final messageProvider =
    StreamProvider.family.autoDispose<Iterable<Message>, Chat>((ref, chat) {
  final userId = ref.watch(userProvider)!.userId;
  final controller = StreamController<Iterable<Message>>();
  final channel = WebSocketChannel.connect(
      Uri.parse("$api_url/messages/${chat.chatId}/$userId"));
  final stream = channel.stream;
  stream.listen((data) {
    //Add the message to the controller
    print(data);
  }, onError: (e) {
    print(e);
  }, onDone: () {
    controller.close();
  });
  ref.onDispose(() {
    channel.sink.close();
  });
  return controller.stream;
});
