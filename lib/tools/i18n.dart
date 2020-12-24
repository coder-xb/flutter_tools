import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

/// _locales exapmle:
///   Map<String, Map<String, dynamic>> _locales = {
///     'en': {
///       'US': {'ok': 'OK'}
///     },
///     'zh': {
///       'CN': {'ok': '确定'},
///       'HK': {'ok': '確定'},
///       'TW': {'ok': '確定'}
///     }
///   };

class I18n {
  Locale locale;
  I18n(this.locale);
  static Map<String, Map<String, dynamic>> _locales =
      Map<String, Map<String, dynamic>>();

  /// 实现of方法
  static I18n of(BuildContext context) => Localizations.of<I18n>(context, I18n);

  /// 设置I18n类的代理
  static const LocalizationsDelegate<I18n> delegate = _I18nDelegate();

  /// 多语言配置
  static void localize(Map<String, Map<String, dynamic>> locales) =>
      _locales = locales;

  /// 语言转换翻译
  /// @key          key标识
  /// @params       占位参数[Map<String, dynamic>]
  String $t(String key, {Map<String, dynamic> params}) {
    String val;
    if (_locales.isNotEmpty) {
      String languageCode = locale.languageCode;
      if (locale.countryCode == null || locale.countryCode.isEmpty) {
        val = _locales[languageCode][key];
      } else {
        String countryCode = locale.countryCode;
        if (countryCode == null ||
            countryCode.isEmpty ||
            !_locales[languageCode].containsKey(countryCode))
          countryCode = _locales[languageCode].keys.toList()[0];
        val = _locales[languageCode][countryCode][key];
      }

      if (params != null && params.isNotEmpty) {
        params.keys.forEach((k) {
          val = val?.replaceAll('\{$k\}', '${params[k]}');
        });
      }
    }
    return val;
  }

  /// 所支持的语言种类
  static Iterable<Locale> supportedLocales = _supportedLocales();
  static List<Locale> _supportedLocales() {
    List<Locale> list = List<Locale>();
    _locales.keys.forEach((lang) {
      _locales[lang].keys.forEach((country) {
        list.add(Locale(lang, country.toUpperCase()));
      });
    });
    return list;
  }
}

class _I18nDelegate extends LocalizationsDelegate<I18n> {
  const _I18nDelegate();

  @override
  bool isSupported(Locale locale) =>
      I18n._locales.keys.contains(locale.languageCode);

  @override
  Future<I18n> load(Locale locale) => SynchronousFuture<I18n>(I18n(locale));

  @override
  bool shouldReload(LocalizationsDelegate<I18n> old) => false;
}
