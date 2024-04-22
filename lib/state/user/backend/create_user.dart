import 'dart:convert';

import 'package:chat_app/constants.dart';
import 'package:chat_app/state/user/models/user.dart';
import 'package:chat_app/state/user/models/user_payload.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

@immutable
class CreateUser {
  const CreateUser();
  Future<bool> createUser({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      //Call the api
      UserPayload userPayload = UserPayload(
        displayName: displayName,
        email: email,
        password: password,
      );
      final response = await http.post(
        Uri.parse("$api_url/users"),
        body: jsonEncode(userPayload),
        headers: {
          'Content-Type': 'application/json',
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
              "true", // Required for cookies, authorization headers with HTTPS
        },
      );
      final user = User.fromJson(jsonDecode(response.body));
      print(user.createdAt);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
