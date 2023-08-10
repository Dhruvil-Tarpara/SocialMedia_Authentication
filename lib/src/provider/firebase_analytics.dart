import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  Analytics._();
  static final Analytics analytics = Analytics._();

  final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

  Future<void> loginEvent(String isUser) async {
    await firebaseAnalytics.logEvent(
      name: "login_event",
      parameters: {
        "is_user": isUser,
      },
    );
  }

  Future<void> notesEvent(int id) async {
    await firebaseAnalytics.logEvent(
      name: "login_event",
      parameters: {
        "notes_id": id,
      },
    );
  }
}
