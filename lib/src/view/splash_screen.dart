import 'package:flutter/material.dart';
import 'package:get_user/src/constant/const_colors.dart';
import 'package:get_user/src/constant/global.dart';
import 'package:get_user/src/provider/database/local_database.dart';
import 'package:get_user/src/utils/media_query.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> gotoNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)).then(
      (value) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SPHelper.spHelper.initialScreen(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    gotoNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColor.backgroundColor,
      body: Center(
        child: SizedBox(
          height: size(context: context).height * 0.5,
          child: Image.asset(Global.notesGif),
        ),
      ),
    );
  }
}
