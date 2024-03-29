// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_user/src/constant/global.dart';
import 'package:get_user/src/constant/widgets/text.dart';
import 'package:get_user/src/constant/widgets/text_form_field.dart';
import 'package:get_user/src/provider/authentication/firebase_auth_helper.dart';
import 'package:get_user/src/provider/database/local_database.dart';
import 'package:get_user/src/provider/model/user_model.dart';
import 'package:get_user/src/utils/media_query.dart';
import 'package:get_user/src/utils/validetion.dart';
import 'package:get_user/src/view/auth/email_validation_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _singUpKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conformPasswordController =
      TextEditingController();
  final ValueNotifier<AutovalidateMode> _valueNotifier =
      ValueNotifier(AutovalidateMode.disabled);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _conformPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: (size(context: context).width >= 500)
                ? 500
                : size(context: context).width,
            child: ValueListenableBuilder(
              valueListenable: _valueNotifier,
              builder: (context, validation, _) => Form(
                key: _singUpKey,
                autovalidateMode: validation,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image(
                            height: size(context: context).height * 0.22,
                            image:
                                NetworkImage(Global.allImage[Global.notesLogo]),
                          ),
                        ),
                        const CommonText(
                          text: Global.signUpTitle,
                          size: 32,
                          fontWeight: FontWeight.w800,
                        ),
                        const CommonText(
                          text: Global.signUpSubTitle,
                          color: Colors.black,
                          size: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        SizedBox(
                          height: size(context: context).height * 0.03,
                        ),
                        CommonTextFormField(
                          hintText: Global.formUserName,
                          textInputType: TextInputType.text,
                          controller: _userNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("enter") + Global.formUserName;
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: size(context: context).height * 0.02,
                        ),
                        CommonTextFormField(
                          hintText: Global.formEmail,
                          textInputType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("enter") + Global.formEmail;
                            } else if (!emailValidation(
                                email: _emailController.text)) {
                              return Global.formInvalied;
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: size(context: context).height * 0.02,
                        ),
                        CommonTextFormField(
                          hintText: "Password",
                          textInputType: TextInputType.text,
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "enter password";
                            } else if (!passwordValidation(
                                password: _passwordController.text)) {
                              return Global.formInvalied;
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: size(context: context).height * 0.02,
                        ),
                        CommonTextFormField(
                          hintText: "Conform Password",
                          textInputType: TextInputType.text,
                          controller: _conformPasswordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "enter password";
                            } else if (value != _passwordController.text) {
                              return Global.formInvalied;
                            } else {
                              return null;
                            }
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            SPHelper.prefs.setBool(Global.isSignUp, true).then(
                                  (value) =>
                                      Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  ),
                                );
                          },
                          child: const CommonText(
                            text: "Already have an account? Login",
                            color: Colors.blueAccent,
                            size: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            _valueNotifier.value =
                                AutovalidateMode.onUserInteraction;
                            if (_singUpKey.currentState!.validate()) {
                              UserData user = await FirebaseAuthHelper
                                  .firebaseAuthHelper
                                  .signUpWithEmailPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                              if (user.user != null) {
                                _buildClearController();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EmailVerificationScreen(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(user.error ?? ""),
                                  ),
                                );
                              }
                            }
                          },
                          child: const CommonText(
                            text: Global.signUpTitle,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _buildClearController() {
    _userNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _conformPasswordController.clear();
  }
}
