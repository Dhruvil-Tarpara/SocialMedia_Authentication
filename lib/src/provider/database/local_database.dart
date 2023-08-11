import 'package:get_user/src/constant/global.dart';
import 'package:get_user/src/view/auth/login_screen.dart';
import 'package:get_user/src/view/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SPHelper {
  SPHelper._();
  static final SPHelper spHelper = SPHelper._();
  static late final SharedPreferences prefs;
  

  void getUser({
    required String userUid,
    required String userEmail,
    required String userPhoto,
  }) {
    SPHelper.prefs.setString(Global.userUid, userUid);
    SPHelper.prefs.setString(Global.userEmail, userEmail);
    SPHelper.prefs.setString(Global.userPhoto, userPhoto);
  }

  initialScreen() {
    if (SPHelper.prefs.getBool(Global.isLogin) ?? false) {
      return const HomeScreen();
    } else {
      if (SPHelper.prefs.getBool(Global.isSignUp) ?? false) {
        return const LoginScreen();
      } else {
        return const LoginScreen();
      }
    }
  }
}
