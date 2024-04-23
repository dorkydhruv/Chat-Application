import 'package:chat_app/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        home: const SplashScreen());
  }
}
