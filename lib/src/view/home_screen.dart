import 'package:flutter/material.dart';
import 'package:get_user/src/constant/widgets/common_text.dart';
import 'package:get_user/src/provider/firebase_auth_helper.dart';
import 'package:get_user/src/provider/local_database.dart';
import 'package:get_user/src/view/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText(text: "Home Screen"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuthHelper.firebaseAuthHelper.logout().then(
                    (value) => SPHelper.prefs.setBool("is_login", false).then(
                          (value) => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          ),
                        ),
                  );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
