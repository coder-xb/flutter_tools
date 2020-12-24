/// 使用方法参考 flutter_screenutil
import 'package:flutter/material.dart';

class Screen {
  // 设计稿的设备尺寸（宽高）
  double w, h;
  bool font; // 字体是否缩放
  static Screen ins = Screen.ins;
  static double _screenWidth = 0,
      _screenHeight = 0,
      _pixelRatio = 0,
      _statusBarHeight = 0,
      _bottomBarHeight = 0,
      _textScaleFactor = 0;
  static MediaQueryData _mediaQuery;

  Screen({
    this.w = 1080,
    this.h = 1920,
    this.font = false,
  });

  void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    if (_mediaQuery != mediaQuery) {
      _mediaQuery = mediaQuery;
      _screenWidth = mediaQuery.size.width;
      _screenHeight = mediaQuery.size.height;
      _pixelRatio = mediaQuery.devicePixelRatio;
      _statusBarHeight = mediaQuery.padding.top;
      _bottomBarHeight = mediaQuery.padding.bottom;
      _textScaleFactor = mediaQuery.textScaleFactor;
    }
  }

  static MediaQueryData get mediaQuery => _mediaQuery;

  /// 每个逻辑像素的字体像素数，字体的缩放比例
  static double get textScaleFactor => _textScaleFactor;

  /// 设备的像素密度
  static double get pixelRatio => _pixelRatio;

  /// 当前设备宽度 dp
  static double get screenWidthDp => _screenWidth;

  /// 当前设备高度 dp
  static double get screenHeightDp => _screenHeight;

  /// 当前设备宽度 px
  static double get screenWidth => _screenWidth * _pixelRatio;

  /// 当前设备高度 px
  static double get screenHeight => _screenHeight * _pixelRatio;

  /// 状态栏高度 dp 刘海屏会更高
  static double get statusBarHeight => _statusBarHeight;

  /// 底部安全区距离 dp
  static double get bottomBarHeight => _bottomBarHeight;

  /// 实际的dp与设计稿px的比例
  double get scaleWidth => _screenWidth / ins.w;
  double get scaleHeight => _screenHeight / ins.h;

  /// 根据设计稿的设备宽度进行适配，高度也根据这个来适配可以保证不变形
  double setSize(double size) => size * scaleWidth;

  /// 根据设计稿的设备高度进行适配
  /// 当发现设计稿中的一屏显示与当前样式不符合时或者形状有差异，高度适配建议使用此方法
  /// 高度适配主要针对想根据设计稿的一屏展示一样的效果
  double setHeight(double h) => h * scaleHeight;

  /// 字体大小适配
  /// fontSize 传入设计稿上字体的px值
  /// font 控制字体是否要根据系统的字体大小辅助选项来进行缩放，默认为false
  double setFont(double fontSize) =>
      font ? setSize(fontSize) : setSize(fontSize) / _textScaleFactor;
}
