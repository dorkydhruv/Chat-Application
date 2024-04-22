import 'dart:convert';

import 'package:chat_app/constants.dart';
import 'package:chat_app/helper.dart';
import 'package:chat_app/state/auth/models/auth_state.dart';
import 'package:chat_app/state/auth/models/token.dart';
import 'package:chat_app/state/fieldnames.dart';
import 'package:chat_app/state/user/models/user.dart';
import 'package:chat_app/state/user/models/user_payload.dart';
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
      final user = await http.get(
        Uri.parse("$api_url/check-access"),
        headers: {
          'Content-Type': 'application/json',
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
              "true", // Required for cookies, authorization headers with HTTPS
          "Authorization": token.accessToken,
        },
      );
      final userdata = User.fromJson(jsonDecode(user.body));
      state = state.copyWith(
        isLoading: false,
        isAuth: true,
        user: userdata,
      );
      print(userdata);
      Helper.storeId(userdata.userId);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> createUser({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
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
      print(user);
      state.copyWith(isLoading: false, isAuth: false, user: user);
      return true;
    } catch (e) {
      state.copyWith(isLoading: false, isAuth: false, error: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> checkAccess() async {
    state = state.copyWith(isLoading: true);
    final token = await Helper.getToken();
    if (token == "") {
      return false;
    }
    try {
      final user = await http.get(
        Uri.parse("$api_url/check-access"),
        headers: {
          'Content-Type': 'application/json',
          "Access-Control-Allow-Origin":
              "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials":
              "true", // Required for cookies, authorization headers with HTTPS
          "Authorization": token,
        },
      );
      final userdata = User.fromJson(jsonDecode(user.body));
      state = state.copyWith(
        isLoading: false,
        isAuth: true,
        user: userdata,
      );
      print(userdata);
      Helper.storeId(userdata.userId);
      return true;
    } catch (e) {
      state.copyWith(isLoading: false, isAuth: false, error: e.toString());
      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await Helper.removeToken();
      await Helper.removeId();
      state = state.copyWith(isLoading: false, isAuth: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
