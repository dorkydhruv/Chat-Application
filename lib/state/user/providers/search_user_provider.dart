import 'dart:convert';

import 'package:chat_app/constants.dart';
import 'package:chat_app/state/user/models/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final searchUserProvider =
    FutureProvider.family<Iterable<User>, String>((ref, searchTerm) async {
  try {
    final response = await http.get(
      Uri.parse(
        "$api_url/search?name=$searchTerm",
      ),
      headers: {
        'Content-Type': 'application/json',
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
      },
    );
    final body = jsonDecode(response.body) as List;
    final users = body.map((user) => User.fromJson(user)).toList();
    return users;
  } catch (e) {
    return [];
  }
});
