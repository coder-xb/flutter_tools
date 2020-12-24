import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rether/core/config/api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:rether/tools/index.dart';
import 'dialog.dart';
import '../others/dialog.dart';

class Version {
  static void check(BuildContext context, {VoidCallback dismiss}) async {
    VerModel _model;
    PackageInfo.fromPlatform().then((PackageInfo info) {
      int _type = Platform.isAndroid ? 1 : 2;
      $Http(lang: $SP.getString('lang', def: 'en-us')).get(API.version,
          params: {'type': _type, 'v': info.version}).then((res) {
        if (res.code == 0) {
          _model = VerModel.fromJson(res.data);
          if (_model.version != null && _model.version.isNotEmpty) {
            _appUpdate(context, _model, dismiss: dismiss);
          } else if (dismiss != null) dismiss();
        } else if (dismiss != null) dismiss();
      });
    });
  }

  /// APP更新
  static void _appUpdate(
    BuildContext context,
    VerModel model, {
    VoidCallback dismiss,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => VerDialog(
        dismiss: dismiss,
        force: model.force,
        version: model.version,
        confirm: () => _launchUrl(context, model.url),
      ),
    );
  }

  /// 加载路由
  static void _launchUrl(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else
      _upError(context);
  }

  /// 跳转浏览器失败
  static void _upError(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AppDialog(
          text: I18n.of(context).$t('updateError'),
          maskDismiss: false,
          type: DialogType.error,
          complete: () async =>
              await SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
        ),
      );
}

class VerModel {
  bool force;
  String version, url;
  VerModel({this.url, this.force, this.version});

  factory VerModel.fromJson(Map<String, dynamic> json) => VerModel(
        url: json['new_url'] as String,
        version: json['new_v'] as String,
        force: json['is_force_update'] as bool,
      );
}
