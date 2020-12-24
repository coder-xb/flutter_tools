import 'package:flutter/material.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import 'tap.dart';

enum LoadingType { dialog, widget }

class AppNone extends StatelessWidget {
  final String text;
  final Widget child;
  final IconData icon;

  AppNone(
    this.text, {
    Key key,
    this.child,
    this.icon = AppIcon.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50, right: 4),
              child: Icon(icon, color: AppColor.c_E3E5E7, size: 60),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 20, bottom: 30),
              child: Text(
                I18n.of(context).$t(text),
                style: AppText.f12_w5_A3ACBB,
              ),
            ),
            child ?? Container(width: 0, height: 0),
          ],
        ),
      ),
    );
  }
}

class AppLoading extends StatelessWidget {
  final Color color;
  final String textKey;
  final TextStyle style;
  final LoadingType type;
  final bool maskDismiss; // 只有[type]为[LoadingType.dialog]时有效
  AppLoading(
    this.textKey, {
    Key key,
    this.maskDismiss = false,
    this.color = AppColor.c_FFFFFF,
    this.type = LoadingType.dialog,
    this.style = const TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return type == LoadingType.dialog
        ? WillPopScope(
            onWillPop: () async => maskDismiss,
            child: Material(
              type: MaterialType.transparency,
              child: AppTap(
                onTap: () {
                  if (maskDismiss) Navigator.of(context).pop();
                },
                child: SafeArea(
                  top: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(color)),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child:
                              Text(I18n.of(context).$t(textKey), style: style),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : SafeArea(
            top: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(color)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Text(I18n.of(context).$t(textKey), style: style),
                  ),
                ],
              ),
            ),
          );
  }
}
