import 'package:flutter/services.dart';
import 'package:decimal/decimal.dart';

class Num {
  /// get int by String
  static int getInt(String str) => int.tryParse(str);

  /// get double by String
  static double getDouble(String str) => double.tryParse(str);

  /// 加法 (精确相加,防止精度丢失)
  static double add(num a, num b) => addDec(a, b).toDouble();
  static Decimal addDec(num a, num b) => addDecStr(a.toString(), b.toString());
  static Decimal addDecStr(String a, String b) =>
      Decimal.parse(a) + Decimal.parse(b);

  /// 减法 (精确相减,防止精度丢失)
  static double subtract(num a, num b) => subtractDec(a, b).toDouble();
  static Decimal subtractDec(num a, num b) =>
      subtractDecStr(a.toString(), b.toString());
  static Decimal subtractDecStr(String a, String b) =>
      Decimal.parse(a) - Decimal.parse(b);

  /// 乘法 (精确相乘,防止精度丢失)
  static double multiply(num a, num b) => multiplyDec(a, b).toDouble();
  static Decimal multiplyDec(num a, num b) =>
      multiplyDecStr(a.toString(), b.toString());
  static Decimal multiplyDecStr(String a, String b) =>
      Decimal.parse(a) * Decimal.parse(b);

  /// 除法 (精确相除,防止精度丢失)
  static double divide(num a, num b) => divideDec(a, b).toDouble();
  static Decimal divideDec(num a, num b) =>
      divideDecStr(a.toString(), b.toString());
  static Decimal divideDecStr(String a, String b) =>
      Decimal.parse(a) / Decimal.parse(b);

  /// 求余（精确求余,防止进度丢失）
  static double remainder(num a, num b) => remainderDec(a, b).toDouble();
  static Decimal remainderDec(num a, num b) =>
      remainderDecStr(a.toString(), b.toString());
  static Decimal remainderDecStr(String a, String b) =>
      Decimal.parse(a) % Decimal.parse(b);

  /// 小于（精确比较，防止进度丢失）
  static bool less(num a, num b) => lessDecStr(a.toString(), b.toString());
  static bool lessDecStr(String a, String b) =>
      Decimal.parse(a) < Decimal.parse(b);

  /// 小于等于（精确比较，防止进度丢失）
  static bool lessOrEqual(num a, num b) =>
      lessOrEqualDecStr(a.toString(), b.toString());
  static bool lessOrEqualDecStr(String a, String b) =>
      Decimal.parse(a) <= Decimal.parse(b);

  /// 大于（精确比较，防止进度丢失）
  static bool more(num a, num b) => moreDecStr(a.toString(), b.toString());
  static bool moreDecStr(String a, String b) =>
      Decimal.parse(a) > Decimal.parse(b);

  /// 大于等于（精确比较，防止进度丢失）
  static bool moreOrEqual(num a, num b) =>
      moreOrEqualDecStr(a.toString(), b.toString());
  static bool moreOrEqualDecStr(String a, String b) =>
      Decimal.parse(a) >= Decimal.parse(b);

  /// 保留小数位数（不会四舍五入）
  static String toFixed(num a, {int pos = 0}) {
    String _num = a.toString();
    if (pos > 0) {
      if ((_num.length - _num.lastIndexOf('.') - 1) < pos) {
        return a
            .toStringAsFixed(pos)
            .substring(0, _num.lastIndexOf('.') + pos + 1)
            .toString();
      } else
        return _num.substring(0, _num.lastIndexOf('.') + pos + 1).toString();
    } else
      return _num.split('.')[0];
  }

  /// 小数转换为百分数
  static String toPercent(num a, {int pos = 0}) =>
      toFixed(multiply(a, 100), pos: pos);

  /// 千分符转换
  static String toThousand(num a, {int pos = 3}) {
    if (a != null) {
      if (a is int) {
        List<String> _vals = int.parse(a.toString()).toString().split('');
        for (int i = 0, l = _vals.length - 1; l >= 0; i++, l--) {
          if (i % 3 == 0 && i != 0 && l != 1) _vals[l] = _vals[l] + ',';
        }

        return _vals.join('');
      } else {
        List<String> _strs = double.parse(a.toString()).toString().split('.'),
            _vals = _strs[0].split(''), // 小数点前
            _points = _strs[1].split(''); // 小数点后

        for (int i = 0, l = _vals.length - 1; l >= 0; i++, l--) {
          if (i % 3 == 0 && i != 0 && l != 1) _vals[l] = _vals[l] + ',';
        }

        for (int i = 0; i <= pos - _points.length; i++) _points.add('0');

        if (_points.length > pos) _points = _points.sublist(0, pos);

        return _points.length > 0
            ? '${_vals.join('')}.${_points.join('')}'
            : _vals.join('');
      }
    } else
      return '0';
  }
}

/// 限制输入合法数字
class InpInt extends TextInputFormatter {
  static const def = 0;
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldVal,
    TextEditingValue newVal,
  ) {
    String val = newVal.text;
    int index = newVal.selection.end;
    if (val != '' && val != def.toString() && _int(val, def) == def) {
      val = oldVal.text;
      index = oldVal.selection.end;
    }
    return TextEditingValue(
      text: val,
      selection: TextSelection.collapsed(offset: index),
    );
  }

  static int _int(String str, [int val = def]) {
    try {
      return int.parse(str);
    } catch (e) {
      return val;
    }
  }
}

/// 限制输入合法小数
class InpDouble extends TextInputFormatter {
  static const def = 0.01;
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldVal,
    TextEditingValue newVal,
  ) {
    String val = newVal.text;
    int index = newVal.selection.end;
    if (val == '.') {
      val = '0.';
      index++;
    } else if (val != '' && val != def.toString() && _float(val, def) == def) {
      val = oldVal.text;
      index = oldVal.selection.end;
    }
    return TextEditingValue(
      text: val,
      selection: TextSelection.collapsed(offset: index),
    );
  }

  static double _float(String str, [double val = def]) {
    try {
      return double.parse(str);
    } catch (e) {
      return val;
    }
  }
}
