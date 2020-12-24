import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import 'pages/start.dart';
import 'widgets/index.dart';

class Rether extends StatefulWidget {
  @override
  _RetherState createState() => _RetherState();
}

class _RetherState extends State<Rether> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed)
      Version.check(Coms.navigator.currentState.overlay.context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <ChangeNotifierProvider>[
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<ProfileState>(create: (_) => ProfileState()),
      ],
      child: Consumer<AppState>(
        builder: (BuildContext context, AppState state, Widget child) {
          return OKToast(
            backgroundColor: AppColor.c_000000.withOpacity(.5),
            child: MaterialApp(
              title: 'Rether',
              color: AppColor.c_FFFFFF,
              navigatorKey: Coms.navigator,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: <LocalizationsDelegate>[
                I18n.delegate,
                ZhCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
              ],
              locale: state.lang,
              supportedLocales: I18n.supportedLocales,
              theme: ThemeData(
                accentColor: AppColor.c_596373,
                primaryColor: AppColor.c_596373,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                backgroundColor: AppColor.c_FFFFFF,
              ),
              home: Start(),
            ),
          );
        },
      ),
    );
  }
}
