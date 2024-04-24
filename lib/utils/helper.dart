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

  static Future<void> removeToken() async {
    final sf = await SharedPreferences.getInstance();
    sf.remove(ACCESS_TOKEN);
  }

  static Future<void> storeId(int id) async {
    final sf = await SharedPreferences.getInstance();
    sf.setInt(USERID, id);
  }

  static Future<int> getId() async {
    final sf = await SharedPreferences.getInstance();
    return sf.getInt(USERID) ?? 0;
  }

  static Future<void> removeId() async {
    final sf = await SharedPreferences.getInstance();
    sf.remove(USERID);
  }
}
