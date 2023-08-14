import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get_user/src/provider/database/cloud_database.dart';
import 'constant/global.dart';
import 'view/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  Future<void> virsion() async {
    await remoteConfig.ensureInitialized();
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 2),
      ),
    );
    await remoteConfig.fetchAndActivate().then(
      (value) {
        Global.appVersion = remoteConfig.getString(Global.appName);
      },
    );
  }

  @override
  void initState() {
    FirebaseCloud.firebaseCloud.createCollection();
    virsion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
