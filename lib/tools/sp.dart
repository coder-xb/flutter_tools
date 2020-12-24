import 'dart:async';
import 'dart:convert';
import 'package:synchronized/synchronized.dart';
import 'package:shared_preferences/shared_preferences.dart';

class $SP {
  static $SP _instance;
  static SharedPreferences _prefs;
  static Lock _lock = Lock();
  $SP._init();

  static Future<$SP> instance() async {
    if (_instance == null) {
      await _lock.synchronized(() async {
        /// 保持本地实例化直到完全初始化
        var instance = $SP._init();
        await instance._init();
        _instance = instance;
      });
    }
    return _instance;
  }

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// set object
  static Future<bool> setObject(String key, Object val) {
    if (_prefs == null) return null;
    return _prefs.setString(key, val == null ? '' : json.encode(val));
  }

  /// get object
  static Map getObject(String key) {
    if (_prefs == null) return null;
    String _data = _prefs.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// get obj
  static T getObj<T>(String key, T f(Map val), {T def}) {
    Map _map = getObject(key);
    return _map == null ? def : f(_map);
  }

  /// set object list
  static Future<bool> setObjectList(String key, List<Object> list) {
    if (_prefs == null) return null;
    List<String> _list = list?.map((val) => json.encode(val))?.toList();
    return _prefs.setStringList(key, _list);
  }

  /// get object list
  static List<Map> getObjectList(String key) {
    if (_prefs == null) return null;
    List<String> _list = _prefs.getStringList(key);
    return _list?.map((val) {
      Map _map = json.decode(val);
      return _map;
    })?.toList();
  }

  /// get obj list
  static List<T> getObjList<T>(String key, T f(Map val),
      {List<T> def = const []}) {
    List<Map> _list = getObjectList(key);
    return _list?.map((val) => f(val))?.toList() ?? def;
  }

  /// set string
  static Future<bool> setString(String key, String val) =>
      _prefs == null ? val : _prefs.setString(key, val);

  /// get string
  static String getString(String key, {String def = ''}) =>
      _prefs == null ? def : (_prefs.getString(key) ?? def);

  /// set string list
  static Future<bool> setStringList(String key, List<String> val) =>
      _prefs == null ? val : _prefs.setStringList(key, val);

  /// get string list
  static List<String> getStringList(String key,
          {List<String> def = const []}) =>
      _prefs == null ? def : (_prefs.getStringList(key) ?? def);

  /// set bool
  static Future<bool> setBool(String key, bool val) =>
      _prefs == null ? null : _prefs.setBool(key, val);

  /// get bool
  static bool getBool(String key, {bool def = false}) =>
      _prefs == null ? def : (_prefs.getBool(key) ?? def);

  /// set int
  static Future<bool> setInt(String key, int val) =>
      _prefs == null ? null : _prefs.setInt(key, val);

  /// get int
  static int getInt(String key, {int def = 0}) =>
      _prefs == null ? def : (_prefs.getInt(key) ?? def);

  /// set double
  static Future<bool> setDouble(String key, double val) =>
      _prefs == null ? null : _prefs.setDouble(key, val);

  /// get double
  static double getDouble(String key, {double def = 0.0}) =>
      _prefs == null ? def : (_prefs.getDouble(key) ?? def);

  /// get dynamic
  static dynamic get(String key, {Object def}) =>
      _prefs == null ? def : (_prefs.get(key) ?? def);

  /// have key
  static bool haveKey(String key) =>
      _prefs == null ? null : _prefs.getKeys().contains(key);

  /// get keys
  static Set<String> getKeys() => _prefs == null ? null : _prefs.getKeys();

  /// remove
  static Future<bool> remove(String key) =>
      _prefs == null ? null : _prefs.remove(key);

  /// clear
  static Future<bool> clear() => _prefs == null ? null : _prefs.clear();

  /// Sp is init
  static bool isInit() => _prefs != null;
}
