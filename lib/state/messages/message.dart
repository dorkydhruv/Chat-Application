import 'dart:collection';

import 'package:flutter/material.dart';

@immutable
class Message extends MapView<String, String> {
  final int userId;
  final String message;

  Message({
    required this.userId,
    required this.message,
  }) : super({
          'userId': userId.toString(),
          'message': message,
        });

  Message.fromString(String recieved)
      : this(
            message: recieved.split(":")[1],
            userId: int.parse(recieved.split(":")[0]));
}
