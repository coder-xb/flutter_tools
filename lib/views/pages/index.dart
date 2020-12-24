import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:rether/tools/index.dart';
import 'package:rether/core/index.dart';
import '../widgets/index.dart';
import 'entry/login.dart';
import 'entry/regist/index.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Coms.exitApp(context),
      child: Scaffold(
        backgroundColor: AppColor.c_596373,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_main.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                _appBar(context),
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'assets/images/icon_textlogo.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 35),
                  child: Column(
                    children: <Widget>[
                      AppTap(
                        onTap: () => Navigator.of(context).push(
                          CupertinoPageRoute(builder: (_) => Login()),
                        ),
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          width: Screen.ins.setSize(295),
                          decoration: BoxDecoration(
                            color: AppColor.c_FFFFFF,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            I18n.of(context).$t('login'),
                            style: AppText.f16_w7_596373,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: AppTap(
                          onTap: () => Navigator.of(context).push(
                            CupertinoPageRoute(builder: (_) => Regist()),
                          ),
                          child: Container(
                            height: 50,
                            alignment: Alignment.center,
                            width: Screen.ins.setSize(295),
                            color: Colors.transparent,
                            child: Text(
                              I18n.of(context).$t('regist'),
                              style: AppText.f16_w7_FFFFFF,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context) => MyAppBar(
        height: Screen.ins.setSize(44),
        color: Colors.transparent,
        suffix: AppTap(
          icon: Icon(
            AppIcon.scan,
            size: 16,
            color: AppColor.c_FFFFFF,
          ),
          onTap: () => _scan(context),
        ),
      );

  Future _scan(BuildContext context) async {
    try {
      String _content = (await BarcodeScanner.scan()).rawContent;
      if (_content.isNotEmpty) {
        String _code = (Uri.parse(_content)).queryParameters['invite_code'];
        $SP.setString('inviteCode', _code);
        Navigator.of(context).push(
          CupertinoPageRoute(builder: (_) => Regist()),
        );
      }
    } on PlatformException catch (_) {
      if (_.code == BarcodeScanner.cameraAccessDenied)
        showToast(I18n.of(context).$t('camera'));
    }
  }
}
