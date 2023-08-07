import 'package:flutter/material.dart';

import 'provider/local_database.dart';
import 'view/home_screen.dart';
import 'view/login_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (SPHelper.prefs.getBool("is_login") ?? false)
          ? const HomeScreen()
          : const LoginScreen(),
    );
  }
}
