import 'dart:collection';
import 'package:chat_app/state/user/models/user.dart';
import 'package:flutter/foundation.dart';

@immutable
class Chat extends MapView<String, String> {
  final User user1;
  final User user2;
  final int chatId;
  Chat({required this.user1, required this.user2, required this.chatId})
      : super({
          'user1': user1.toString(),
          'user2': user2.toString(),
          'chatId': chatId.toString(),
        });

  Chat.fromJson(Map<String, dynamic> json)
      : this(
            chatId: json['chatId'],
            user1: User.fromJson(json['user1']),
            user2: User.fromJson(json['user2']));
}
