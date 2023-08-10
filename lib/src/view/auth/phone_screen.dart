// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_user/src/constant/const_colors.dart';
import 'package:get_user/src/constant/widgets/common_text.dart';
import 'package:get_user/src/constant/widgets/common_text_form_field.dart';
import 'package:get_user/src/provider/authentication/firebase_auth_helper.dart';
import 'package:get_user/src/provider/database/cloud_database.dart';
import 'package:get_user/src/provider/database/local_database.dart';
import 'package:get_user/src/provider/model/user_model.dart';
import 'package:get_user/src/utils/media_query.dart';
import 'package:get_user/src/view/home_screen.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final ValueNotifier<AutovalidateMode> _valueNotifier =
      ValueNotifier(AutovalidateMode.disabled);
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      image: const AssetImage("assets/logo.png"),
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
                    controller: _phoneController,
                    textInputType: TextInputType.phone,
                    hintText: 'Enter your phone number',
                    labelText: const CommonText(text: 'Phone Number'),
                    prefix: const Icon(Icons.phone),
                    validator: (value) {
                      if (_phoneController.text.isEmpty &&
                          _phoneController.text.length == 10 &&
                          int.tryParse(_phoneController.text) != null) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: size(context: context).height * 0.02,
                  ),
                  SizedBox(
                    width: size(context: context).width * 0.38,
                    child: ElevatedButton(
                      onPressed: () async {
                        _valueNotifier.value =
                            AutovalidateMode.onUserInteraction;
                        if (_loginKey.currentState!.validate()) {
                          UserData user = await FirebaseAuthHelper
                              .firebaseAuthHelper
                              .signInWithPhoneNumber(
                                  number: _phoneController.text.trim(),
                                  otp: _otpController.text.trim());
                          if (user.user != null) {
                            print("helllo");
                            FirebaseCloud.firebaseCloud.createDocument();

                            SPHelper.prefs.setBool("is_login", true).then(
                                  (value) =>
                                      Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  ),
                                );
                          } else {
                            print("by");

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(user.error ?? ""),
                              ),
                            );
                          }
                          await otpDialogBox(context);
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(text: "Send OTP"),
                          Icon(Icons.arrow_circle_right),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: size(context: context).width * 0.38,
                    child: TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.arrow_back_rounded,
                            color: ConstColor.buttonColor,
                            size: 18,
                          ),
                          CommonText(
                            text: "Back to login",
                            color: ConstColor.buttonColor,
                            size: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
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

  Future otpDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter your OTP'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonTextFormField(
              controller: _otpController,
              hintText: "Otp",
              textInputType: TextInputType.number,
            ),
          ),
          contentPadding: const EdgeInsets.all(10.0),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                UserData user = await FirebaseAuthHelper.firebaseAuthHelper
                    .signInWithPhoneNumber(
                        number: _phoneController.text.trim(),
                        otp: _otpController.text.trim());
                if (user.user != null) {
                  print("helllo");
                  FirebaseCloud.firebaseCloud.createDocument();
                  _otpController.clear();
                  _phoneController.clear();
                  SPHelper.prefs.setBool("is_login", true).then(
                        (value) => Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        ),
                      );
                } else {
                  print("by");
                  _otpController.clear();

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(user.error ?? ""),
                    ),
                  );
                }
              },
              child: const Text(
                'Submit',
              ),
            ),
            IconButton(
              onPressed: () {
                _otpController.clear();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ],
        );
      },
    );
  }
}
