import 'dart:collection';

import 'package:chat_app/state/fieldnames.dart';

class User extends MapView<String, String?> {
  final String userId;
  final String displayName;
  final String? email;
  final String createdAt;

  User({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.createdAt,
  }) : super({
          'userId': userId,
          'displayName': displayName,
          'email': email,
          'createdAt': createdAt
        });

  User.fromJson(Map<String, dynamic> json)
      : this(
            displayName: json[Fieldnames.displayName],
            userId: json[Fieldnames.userId],
            email: json[Fieldnames.email],
            createdAt: json[Fieldnames.createdAt]);
}
