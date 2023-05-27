import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; //Firebase import
import 'package:flutter/services.dart';
import 'package:flutter/material.dart'; //Widget Style import

import 'package:intl/date_symbol_data_local.dart'; //Date import

import 'package:qed_app_thinkit/BasicWidgets/BotNaviBar.dart';
import 'Main/0_Intro/LoginScreens/Login.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ThinKit());
}

String version = 'Provided by GitHub';

class ThinKit extends StatelessWidget {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);

  const ThinKit({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));

    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Thin Kit',
              theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  splashColor: Colors.white,
                  highlightColor: Colors.transparent),
              themeMode: currentMode,
              home: StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return MyPage();
                    }
                    return LogIn();
                  }));
        });
  }
}
