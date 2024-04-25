import 'package:chat_app/state/user/models/user.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final User user;
  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      hoverColor: Colors.deepPurpleAccent[500],
      leading: CircleAvatar(
        radius: 30,
        child: Text(user.displayName[0]),
      ),
      title: Text(user.displayName),
      subtitle: Text(user.email ?? ""),
    );
  }
}
