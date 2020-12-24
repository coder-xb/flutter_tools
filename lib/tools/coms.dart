import 'package:oktoast/oktoast.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:screenshot/screenshot.dart';
import 'package:event_bus/event_bus.dart';
import 'package:rether/tools/index.dart';
import 'package:rether/core/index.dart';
import 'package:rether/views/pages/index.dart';
import 'package:rether/views/widgets/index.dart';

/// APP事件总线
EventBus evbus = EventBus();

/// 是否刷新Asset-Info
class RefreshAssetInfo {
  bool refresh;
  RefreshAssetInfo(this.refresh);
}

/// 是否刷新Asset-Wallet日志列表
class RefreshWalletBills {
  bool refresh;
  RefreshWalletBills(this.refresh);
}

/// 是否刷新Asset-Wards日志列表
class RefreshWardsBills {
  bool refresh;
  RefreshWardsBills(this.refresh);
}

/// 是否刷新Report列表
class RefreshReport {
  bool refresh;
  RefreshReport(this.refresh);
}

/// 是否刷新Setting
class RefreshSetting {
  bool refresh;
  RefreshSetting(this.refresh);
}

class RefreshAppoint {
  bool refresh;
  RefreshAppoint(this.refresh);
}

/// 全局公用静态事件及其变量
class Coms {
  static DateTime _date;

  /// 全局路由控制Key, 仅用于Http请求10008错误码使用
  static GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

  static ScreenshotController screen = ScreenshotController();

  /// 复制
  static void copy(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    showToast(I18n.of(context).$t('copySucess'));
  }

  /// 空组件
  static Widget empty = Container(width: 0, height: 0);

  /// 输入框失焦
  static void unfocus(BuildContext context) =>
      FocusScope.of(context).requestFocus(FocusNode());

  /// 退出账号
  static void logout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppDialog(
        type: DialogType.warning,
        text: I18n.of(context).$t('signoutTips'),
        confirm: () => _logout(context),
      ),
    );
  }

  /// 退出账号handler
  static void _logout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppLoading('loading'),
    );
    $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.logout).then((res) {
      Navigator.of(context).pop();
      if (res.code == 0) {
        $SP.remove('token');
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (_) => Index()),
          (r) => r == null,
        );
      }
    });
  }

  /// 退出APP
  static Future<bool> exitApp(BuildContext context) async {
    if (_date == null ||
        DateTime.now().difference(_date) > Duration(seconds: 2)) {
      _date = DateTime.now();
      showToast(I18n.of(context).$t('exitApp'), position: ToastPosition.bottom);
      return false;
    }

    HttpResponse _res = await $Http(
      showError: false,
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.logout);
    if (_res.code == 0) $SP.remove('token');
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }

  /// 物理返回键打开drawer
  static Future<bool> openDrawer(GlobalKey<ScaffoldState> key) async {
    key.currentState.openDrawer();
    return false;
  }

  /// 手机加密显示
  static String phone(String phone) => phone != null && phone.isNotEmpty
      ? phone.replaceRange(3, phone.length - 2, '******')
      : '';

  /// 邮箱加密显示
  static String email(String email) => email != null && email.isNotEmpty
      ? email.replaceRange(1, email.lastIndexOf('@'), '******')
      : '';

  /// UID加密显示
  static String uid(String uid) => uid != null && uid.isNotEmpty
      ? uid.replaceRange(2, uid.length - 2, '******')
      : '';
}
