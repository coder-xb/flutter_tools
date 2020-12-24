import 'package:flutter/material.dart';
import 'package:rether/tools/index.dart';

class AppState extends ChangeNotifier {
  String _spLang = $SP.getString('lang', def: 'en-us');
  String get spLang => _spLang;
  Locale _lang = Locale(
    $SP
        .getString('lang', def: 'en-us')
        .split(RegExp(r'[_-]'))[0]
        ?.toLowerCase(),
    $SP
        .getString('lang', def: 'en-us')
        .split(RegExp(r'[_-]'))[1]
        ?.toUpperCase(),
  );
  Locale get lang => _lang;

  String _currency = 'USD';
  String get currency => _currency;

  void setLang(var lang) {
    Locale tmp = lang != null
        ? (lang is String
            ? Locale(
                lang.split(RegExp(r'[_-]'))[0]?.toLowerCase(),
                lang.split(RegExp(r'[_-]'))[1]?.toUpperCase(),
              )
            : (lang is Locale ? lang : lang))
        : lang;
    if (!I18n.supportedLocales.contains(tmp)) return;
    _lang = tmp;
    _spLang = $SP.getString('lang', def: 'en-us');
    notifyListeners();
  }

  void setCurrency(String cur) {
    _currency = cur;
    notifyListeners();
  }
}
