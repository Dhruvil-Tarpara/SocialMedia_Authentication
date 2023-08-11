import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get_user/src/provider/database/local_database.dart';
import 'package:get_user/src/provider/firebase_analytics.dart';
import 'package:get_user/src/provider/model/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'exaption_handle.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();
  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AppleAuthProvider appleAuthProvider = AppleAuthProvider();
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserData> signUpWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await Analytics.analytics.loginEvent("true");
      return UserData(error: null, user: credential.user!);
    } catch (e) {
      final status = AuthExceptionHandler.handleException(e);
      await Analytics.analytics.loginEvent("false");
      return UserData(
          error: AuthExceptionHandler.generateExceptionMessage(status),
          user: null);
    }
  }

  Future<UserData> signInwithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await Analytics.analytics.loginEvent("true");
      SPHelper.spHelper.getUser(
        userUid: credential.user!.uid,
        userEmail: credential.user?.email ?? "",
        userPhoto: credential.user?.photoURL ?? "",
      );
      return UserData(error: null, user: credential.user!);
    } catch (e) {
      final status = AuthExceptionHandler.handleException(e);
      await Analytics.analytics.loginEvent("false");
      return UserData(
          error: AuthExceptionHandler.generateExceptionMessage(status),
          user: null);
    }
  }

  Future<UserData> signInWithPhoneNumber({
    required String smsCode,
    required String verificationId,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      await Analytics.analytics.loginEvent("true");
      SPHelper.spHelper.getUser(
        userUid: userCredential.user!.uid,
        userEmail: userCredential.user?.email ?? "",
        userPhoto: userCredential.user?.photoURL ?? "",
      );
      return UserData(
        error: "",
        user: userCredential.user,
      );
    } catch (e) {
      final status = AuthExceptionHandler.handleException(e);
      await Analytics.analytics.loginEvent("false");
      return UserData(
          error: AuthExceptionHandler.generateExceptionMessage(status),
          user: null);
    }
  }

  Future<UserData> signInWithGoogle() async {
    try {
      if (Platform.isIOS) {
        googleSignIn = GoogleSignIn(
          clientId:
              "953226139203-m30riok47kqvc3ticpdd64aqslk9mccj.apps.googleusercontent.com",
          scopes: ["email"],
        );
      }
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication? googleAuth =
          await googleSignInAccount?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      SPHelper.spHelper.getUser(
        userUid: userCredential.user!.uid,
        userEmail: userCredential.user?.email ?? "",
        userPhoto: userCredential.user?.photoURL ?? "",
      );
      await Analytics.analytics.loginEvent("true");
      return UserData(error: null, user: userCredential.user!);
    } catch (e) {
      final status = AuthExceptionHandler.handleException(e);
      await Analytics.analytics.loginEvent("false");
      return UserData(
          error: AuthExceptionHandler.generateExceptionMessage(status),
          user: null);
    }
  }

  Future<UserData> signInWithApple() async {
    UserCredential userCredential;
    try {
      if (kIsWeb) {
        userCredential = await firebaseAuth.signInWithPopup(appleAuthProvider);
      } else {
        userCredential =
            await firebaseAuth.signInWithProvider(appleAuthProvider);
      }
      await Analytics.analytics.loginEvent("true");
      return UserData(error: null, user: userCredential.user!);
    } catch (e) {
      final status = AuthExceptionHandler.handleException(e);
      await Analytics.analytics.loginEvent("false");
      return UserData(
          error: AuthExceptionHandler.generateExceptionMessage(status),
          user: null);
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return "ResetPassword failed...";
    }
  }

  // Future<User?> signInWithFacebook() async {
  //   try {
  //     final LoginResult loginResult = await FacebookAuth.instance.login();
  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //     UserCredential userCredential =
  //         await firebaseAuth.signInWithCredential(facebookAuthCredential);
  //     return userCredential.user;
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<bool> logout() async {
    try {
      await firebaseAuth.signOut();
      await googleSignIn.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
