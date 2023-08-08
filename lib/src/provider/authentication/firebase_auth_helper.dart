import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();
  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final AppleAuthProvider appleAuthProvider = AppleAuthProvider();
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> singWithGoogle() async {
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
      return userCredential.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> signInWithApple() async {
    UserCredential userCredential;
    try {
      if (kIsWeb) {
        userCredential = await firebaseAuth.signInWithPopup(appleAuthProvider);
      } else {
        userCredential =
            await firebaseAuth.signInWithProvider(appleAuthProvider);
      }
      return userCredential.user;
    } catch (e) {
      return null;
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
