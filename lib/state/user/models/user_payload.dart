import 'dart:collection';

import 'package:chat_app/state/fieldnames.dart';
import 'package:flutter/material.dart';

@immutable
class UserPayload extends MapView<String, String> {
  final String userId;
  final String? displayName;
  final String? email;
  UserPayload({
    required this.userId,
    required this.displayName,
    required this.email,
  }) : super({
          Fieldnames.displayName: displayName ?? "",
          Fieldnames.userId: userId,
          Fieldnames.email: email ?? "",
        });
}
