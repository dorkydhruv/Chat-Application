import 'dart:collection';

import 'package:flutter/material.dart';

@immutable
class Message extends MapView<String, String> {
  final String id;
  final String data;
  final String type;
  Message({
    required this.id,
    required this.data,
    required this.type,
  }) : super({
          'id': id,
          'data': data,
          'type': type,
        });

  Message.fromJson(final Map<String, dynamic> json)
      : this(
          id: json['id'],
          data: json['data'],
          type: json['type'],
        );
}
