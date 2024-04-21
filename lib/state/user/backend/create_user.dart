import 'dart:convert';

import 'package:chat_app/constants.dart';
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
      final response = await http.get(
        Uri.parse("$api_url/"),
        headers: {"Content-Type": "application/json;charset=UTF-8"},
      );
      final dio = Dio().get("$api_url/");
      print(response.body);
      print(response.statusCode);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
