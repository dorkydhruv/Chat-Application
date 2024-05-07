import 'dart:collection';

import 'package:flutter/material.dart';

@immutable
class Message extends MapView<String, String> {
  final int messageId;
  final String message;
  final int userId;
  final int chatId;
  Message({
    required this.messageId,
    required this.message,
    required this.userId,
    required this.chatId,
  }) : super({
          'messageId': messageId.toString(),
          'message': message,
          'userId': userId.toString(),
          'chatId': chatId.toString(),
        });

  Message.fromJson(final Map<String, dynamic> json)
      : this(
          messageId: json['messageId']!,
          message: json['message']!,
          userId: json['userId']!,
          chatId: json['chatId']!,
        );
}
