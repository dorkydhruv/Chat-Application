import 'package:flutter/material.dart';

@immutable
class Message {
  final int userId;
  final String message;

  const Message({
    required this.userId,
    required this.message,
  });

  fromString(String recieved) {
    return Message(
      userId: int.parse(recieved.split(":")[0]),
      message: recieved.split(":")[1],
    );
  }
}
