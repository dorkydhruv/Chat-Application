import 'dart:convert';

import 'package:chat_app/constants.dart';
import 'package:chat_app/state/auth/providers/user_provider.dart';
import 'package:chat_app/state/chat/models/chat.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final chatProvider = FutureProvider<Iterable<Chat>>((ref) async {
  final userId = ref.read(userProvider)!.userId;
  final response = await http.get(
    Uri.parse('$api_url/chat/get/$userId'),
    headers: {
      'Content-Type': 'application/json',
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials":
          "true", // Required for cookies, authorization headers with HTTPS
    },
  );
  final body = jsonDecode(response.body) as List;
  final chats = body.map((chat) => Chat.fromJson(chat)).toList();
  return chats;
});
