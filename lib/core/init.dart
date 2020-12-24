import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orientation/orientation.dart';

import '../tools/index.dart';
import 'config/lang/index.dart';

class App {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    I18n.localize(Lang);
    await $SP.instance();
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    if (Platform.isAndroid)
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
  }
}
