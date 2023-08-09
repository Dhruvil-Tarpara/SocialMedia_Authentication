import 'package:get_user/src/view/home_screen.dart';
import 'package:get_user/src/view/login_screen.dart';
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
    SPHelper.prefs.setString("user_uid", userUid);
    SPHelper.prefs.setString("user_email", userEmail);
    SPHelper.prefs.setString("user_photo", userPhoto);
  }

  initialScreen() {
    if (SPHelper.prefs.getBool("is_login") ?? false) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}
