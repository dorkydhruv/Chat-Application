import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class Helper {
  const Helper();

  static Future<void> storeToken(String str) async {
    final sf = await SharedPreferences.getInstance();
    sf.setString(ACCESS_TOKEN, str);
  }

  static Future<String> getToken() async {
    final sf = await SharedPreferences.getInstance();
    return sf.getString(ACCESS_TOKEN) ?? "";
  }
}
