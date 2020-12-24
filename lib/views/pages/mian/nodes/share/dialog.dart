import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';
import 'screen.dart';

class ShareDialog extends StatefulWidget {
  final VoidCallback confirm;
  final ShareModel model;
  ShareDialog({
    Key key,
    this.model,
    this.confirm,
  }) : super(key: key);
  @override
  _ShareDialogState createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          Expanded(
            child: AppTap(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColor.c_FFFFFF,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: SafeArea(
              top: false,
              child: AppTap(
                onTap: () => Coms.unfocus(context),
                child: Column(children: <Widget>[_input(), _button()]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input() => Container(
        padding: EdgeInsets.only(top: 30, bottom: 10),
        child: Column(
          children: <Widget>[
            Text(
              I18n.of(context).$t('shareTo'),
              style: AppText.f18_w5_596373,
            ),
            _option(),
          ],
        ),
      );

  Widget _option() => Container(
        margin: EdgeInsets.fromLTRB(8, 16, 8, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _icon('link', onTap: _copyLink),
            _icon(
              'save',
              onTap: () => Navigator.of(context).push(
                AuthRoute(
                  child: ShareScreen(model: widget.model, confirm: _saveImage),
                ),
              ),
            ),
            _icon('face', onTap: () => _openApp('Facebook')),
            _icon('twitter', onTap: () => _openApp('Twitter')),
            _icon('wechat', onTap: () => _openApp('WeChat')),
          ],
        ),
      );

  Widget _icon(
    String key, {
    VoidCallback onTap,
  }) =>
      Expanded(
        child: AppTap(
          onTap: onTap,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Image.asset('assets/images/icon_$key.png',
                    scale: 2, width: 32),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Text(I18n.of(context).$t(key),
                    style: AppText.f11_w4_596373),
              ),
            ],
          ),
        ),
      );

  Widget _button() => Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: AppTap(
          onTap: _confirm,
          child: Container(
            height: 50,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColor.c_596C8B,
              borderRadius: BorderRadius.circular(50),
            ),
            child:
                Text(I18n.of(context).$t('done'), style: AppText.f15_w7_FFFFFF),
          ),
        ),
      );

  void _confirm() {
    Navigator.of(context).pop();
    if (widget.confirm != null) widget.confirm();
  }

  void _copyLink() {
    Coms.copy(context,
        '${API.shares}?r=${Provider.of<ProfileState>(context, listen: false).model.uid}');
  }

  Future _saveImage() async {
    try {
      Coms.screen.capture(pixelRatio: 3.0).then((File image) async {
        ImagePickerSaver.saveFile(fileData: image.readAsBytesSync())
            .then((res) {
          showToast(I18n.of(context).$t('saveSuccess'));
        });
      });
    } on PlatformException {
      showToast(I18n.of(context).$t('saveFailed'));
    }
  }

  Future _openApp(String name) async {
    String _url = '';
    switch (name) {
      case 'WeChat':
        _url = 'weixin://';
        break;
      case 'Facebook':
        _url = 'fb://';
        break;
      case 'Twitter':
        _url = 'twitter://';
        break;
    }

    if (await canLaunch(_url)) {
      Clipboard.setData(
        ClipboardData(
            text:
                '${API.shares}?r=${Provider.of<ProfileState>(context, listen: false).model.uid}'),
      );
      showToast(
        I18n.of(context).$t('openAppSuccess', params: {'app': name}),
        onDismiss: () async {
          await launch(_url);
        },
      );
    } else
      showToast(I18n.of(context).$t('openAppFaild', params: {'app': name}));
  }
}
