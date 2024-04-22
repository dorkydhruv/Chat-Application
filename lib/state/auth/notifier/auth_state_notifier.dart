import 'dart:convert';

import 'package:chat_app/constants.dart';
import 'package:chat_app/helper.dart';
import 'package:chat_app/state/auth/models/auth_state.dart';
import 'package:chat_app/state/auth/models/toke.dart';
import 'package:chat_app/state/fieldnames.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState.initial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    //Call the api
    try {
      final payload = {
        Fieldnames.email: email,
        Fieldnames.password: password,
      };
      final response = await http.post(
        Uri.parse("$api_url/login"),
        body: jsonEncode(payload),
        headers: {
          'Content-Type': 'application/json',
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
              "true", // Required for cookies, authorization headers with HTTPS
        },
      );
      final token = Token.fromJson(jsonDecode(response.body));
      Helper.storeToken(token.accessToken);
      state = state.copyWith(isLoading: false, isAuth: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
