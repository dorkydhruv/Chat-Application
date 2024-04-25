import 'dart:convert';

import 'package:chat_app/constants.dart';
import 'package:chat_app/state/auth/providers/user_provider.dart';
import 'package:chat_app/state/chat/models/chat.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final createChatProvider =
    FutureProvider.family<Chat, int>((ref, anotherUserId) async {
  final userId = ref.watch(userProvider)!.userId;
  final response = await http.post(Uri.parse("$api_url/chat/create"), headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    "Access-Control-Allow-Origin": "*", // Required for CORS support to work
    "Access-Control-Allow-Credentials": "true",
  }, body: {
    "user1_id": userId.toString(),
    "user2_id": anotherUserId.toString(),
  });
  final chat = Chat.fromJson(jsonDecode(response.body));
  return chat;
});
