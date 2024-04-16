import 'dart:io' show Platform;

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:seventh_project/Controller/quran_controller.dart';
import 'package:seventh_project/Controller/timer_controller.dart';
import 'package:seventh_project/Shared/Screen/boarding_screen.dart';
import 'package:seventh_project/Shared/Screen/mushaf_screen.dart';
import 'package:seventh_project/Shared/Theme/theme_widget.dart';
import 'package:seventh_project/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS)
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationIcon: 'mipmap/launcher_icon',
      androidNotificationOngoing: true,
    );
  Wakelock.enable();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => quranController()),
        BlocProvider(create: (context) => TimerController())
      ],
      child: MaterialApp(
        locale: Locale('ar'),
        supportedLocales: [Locale('ar')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        builder: DevicePreview.appBuilder,
        theme: themeData.light(context),
        darkTheme: themeData.dark(context),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: checkFirstOnce(),
          builder: (context, snapshot) {
            if (snapshot.data == false) {
              return Mushaf_screen();
            } else {
              return Boarding_screen(firstOnce: true);
            }
          },
        ),
      ),
    );
  }

  Future checkFirstOnce() async {
    // check if user first once use app to show on boarding screen
    SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getBool('showBoarding') ?? true;
  }
}
