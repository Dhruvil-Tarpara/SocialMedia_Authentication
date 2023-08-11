// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_user/src/constant/global.dart';
import 'package:get_user/src/constant/widgets/text.dart';
import 'package:get_user/src/constant/widgets/text_form_field.dart';
import 'package:get_user/src/provider/authentication/firebase_auth_helper.dart';
import 'package:get_user/src/provider/database/cloud_database.dart';
import 'package:get_user/src/provider/database/local_database.dart';
import 'package:get_user/src/provider/firebase_analytics.dart';
import 'package:get_user/src/provider/model/user_model.dart';
import 'package:get_user/src/utils/media_query.dart';
import 'package:get_user/src/utils/validetion.dart';
import 'package:get_user/src/view/home_screen.dart';
import 'phone_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ValueNotifier<AutovalidateMode> _valueNotifier =
      ValueNotifier(AutovalidateMode.disabled);
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: ValueListenableBuilder(
            valueListenable: _valueNotifier,
            builder: (context, value, child) => Form(
              key: _loginKey,
              autovalidateMode: value,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image(
                      height: size(context: context).height * 0.28,
                      image: const AssetImage(Global.notesLogo),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CommonText(
                      text: "Login",
                      size: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: CommonText(
                      text: "Please sign in to continue",
                      size: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: size(context: context).height * 0.02,
                  ),
                  CommonTextFormField(
                    controller: _emailController,
                    textInputType: TextInputType.emailAddress,
                    hintText: "email",
                    labelText: const CommonText(text: "Email"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter email";
                      } else if (!emailValidation(
                          email: _emailController.text)) {
                        return "invalied";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: size(context: context).height * 0.02,
                  ),
                  CommonTextFormField(
                    controller: _passwordController,
                    textInputType: TextInputType.visiblePassword,
                    hintText: "password",
                    labelText: const CommonText(text: "Password"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "enter password";
                      } else {
                        return null;
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        String? data = await FirebaseAuthHelper
                            .firebaseAuthHelper
                            .resetPassword(_emailController.text);
                        if (data != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Invalied email...."),
                            ),
                          );
                        }
                      },
                      child: const CommonText(
                        text: "Forgot Password?",
                        color: Colors.blueAccent,
                        size: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      _valueNotifier.value = AutovalidateMode.onUserInteraction;
                      if (_loginKey.currentState!.validate()) {
                        UserData user = await FirebaseAuthHelper
                            .firebaseAuthHelper
                            .signInwithEmailPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                        if (user.user != null) {
                          FirebaseCloud.firebaseCloud.createDocument();
                          SPHelper.prefs.setBool(Global.isLogin, true).then(
                                (value) =>
                                    Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                ),
                              );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Somthing want to wrong..."),
                            ),
                          );
                        }
                      }
                    },
                    child: const CommonText(text: "Login"),
                  ),
                  SizedBox(
                    height: size(context: context).height * 0.02,
                  ),
                  const CommonText(
                    text: "Sign up with social account",
                  ),
                  SizedBox(
                    height: size(context: context).height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: size(context: context).width * 0.1,
                        child: _buildButton(
                          onPressed: () async {
                            UserData user = await FirebaseAuthHelper
                                .firebaseAuthHelper
                                .signInWithGoogle();
                            if (user.user != null) {
                              FirebaseCloud.firebaseCloud.createDocument();
                              SPHelper.prefs.setBool(Global.isLogin, true).then(
                                    (value) =>
                                        Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(),
                                      ),
                                    ),
                                  );
                            } else {
                              await Analytics.analytics.loginEvent("false");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(user.error ?? ""),
                                ),
                              );
                            }
                          },
                          image: Global.googleLogo,
                        ),
                      ),
                      SizedBox(
                        width: size(context: context).width * 0.1,
                        child: _buildButton(
                          onPressed: () {},
                          image: Global.facebookLogo,
                        ),
                      ),
                      SizedBox(
                        width: size(context: context).width * 0.1,
                        child: _buildButton(
                          onPressed: () async {
                            UserData user = await FirebaseAuthHelper
                                .firebaseAuthHelper
                                .signInWithApple();
                            if (user.user != null) {
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(user.error ?? ""),
                                ),
                              );
                            }
                          },
                          image: Global.appleLogo,
                        ),
                      ),
                      SizedBox(
                        width: size(context: context).width * 0.1,
                        child: _buildButton(
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const PhoneScreen(),
                              ),
                            );
                          },
                          image: Global.phoneLogo,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ));
                    },
                    child: const CommonText(
                      text: "Don't have an account?Sign Up",
                      color: Colors.blueAccent,
                      size: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      {required String image, required void Function()? onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        side: MaterialStatePropertyAll(
          BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: Image(
        image: AssetImage(image),
        height: 22,
      ),
    );
  }
}
