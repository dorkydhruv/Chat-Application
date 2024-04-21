import 'dart:collection';

import 'package:chat_app/state/fieldnames.dart';
import 'package:flutter/material.dart';

@immutable
class UserPayload extends MapView<String, String> {
  final String? displayName;
  final String? email;
  final String? password;
  UserPayload({
    required this.displayName,
    required this.email,
    required this.password,
  }) : super({
          Fieldnames.displayName: displayName ?? "",
          Fieldnames.email: email ?? "",
          Fieldnames.password: password ?? "",
        });

  toJson() {
    return {
      Fieldnames.displayName: displayName,
      Fieldnames.email: email,
      Fieldnames.password: password,
    };
  }
}
