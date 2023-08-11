import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_user/src/provider/database/cloud_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'src/my_app.dart';
import 'src/provider/database/local_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SPHelper.prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  bool isImage = await FirebaseCloud.firebaseCloud.getFolder();
  if (isImage) {
    runApp(const MyApp());
  } else {
    isImage = await FirebaseCloud.firebaseCloud.getFolder();
  }
}
