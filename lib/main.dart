import 'dart:async';

import 'package:chat_app/helper.dart';
import 'package:chat_app/state/auth/providers/auth_state_provider.dart';
import 'package:chat_app/state/auth/providers/is_auth.dart';
import 'package:chat_app/state/auth/providers/is_loading.dart';
import 'package:chat_app/views/home_view.dart';
import 'package:chat_app/views/loading/loading.dart';
import 'package:chat_app/views/login.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  getUserLoggedInState() async {
    await Helper.getId().then((id) {
      if (id != 0) {
        setState(() {
          isLoggedIn = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserLoggedInState();
    Timer.periodic(Duration(seconds: 4), (_) {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: Consumer(
        builder: (context, ref, child) {
          ref.listen(isLoading, (_, isLoading) {
            if (isLoading) {
              LoadingScreen.instance().show(context: context);
            } else {
              LoadingScreen.instance().hide();
            }
          });
          return isLoggedIn ? const HomeView() : const LoginView();
        },
      ),
    );
  }
}
