// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_user/src/provider/firebase_auth_helper.dart';
import 'package:get_user/src/provider/local_database.dart';
import 'package:get_user/src/view/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () async {
              User? user =
                  await FirebaseAuthHelper.firebaseAuthHelper.singWithGoogle();
              (user != null) ? _buildStatus(true) : _buildStatus(false);
            },
            child: const Row(
              children: [
                Spacer(),
                Image(
                  image: AssetImage("assets/search.png"),
                  height: 22,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Sign in with Google"),
                Spacer(),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Row(
              children: [
                Spacer(),
                Image(
                  image: AssetImage("assets/facebook.png"),
                  height: 22,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Sign in with Facebook"),
                Spacer(),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              User? user =
                  await FirebaseAuthHelper.firebaseAuthHelper.signInWithApple();
              (user != null) ? _buildStatus(true) : _buildStatus(false);
            },
            child: const Row(
              children: [
                Spacer(),
                Image(
                  image: AssetImage("assets/apple.png"),
                  height: 22,
                ),
                SizedBox(
                  width: 20,
                ),
                Text("Sign in with Apple Id"),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildStatus(bool isUser) {
    if (isUser) {
      SPHelper.prefs.setBool("is_login", true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Login succesfull...."),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login insertion failed...."),
        ),
      );
    }
  }
}
