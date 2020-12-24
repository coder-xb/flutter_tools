import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import 'package:rether/views/pages/index.dart';

class $Http {
  static Dio _client;
  static bool _showError, _exit;
  static String _token, _lang;

  factory $Http({
    String token,
    bool upload = false,
    String lang = 'en-us',
    bool showError = true,
    bool exit = true, // 是否强制退出
  }) {
    _lang = lang;
    _token = token;
    _exit = exit;
    _showError = showError;
    return $Http._init(upload);
  }

  $Http._init(upload) {
    _client = Dio(BaseOptions(
      baseUrl: upload ? API.upload : API.url,
      headers: {'token': _token, 'Accept-Language': _lang},
      contentType:
          upload ? 'multipart/form-data' : 'application/x-www-form-urlencoded',
    ));
  }
  Future _request(String method, String url,
      {dynamic data, Map<String, dynamic> params}) async {
    try {
      Response _res = await _client.request(
        url,
        data: data,
        queryParameters: params,
        options: Options(method: method),
      );

      return _res.statusCode == HttpStatus.ok
          ? HttpResponse.fromJson(_res.data)
          : HttpResponse(
              code: HttpResponse.resError,
              msg: 'RESPONSE_ERROR: ${_res.statusCode}',
            );
    } catch (_) {
      return HttpResponse(
        code: HttpResponse.reqError,
        msg: 'REQUEST_ERROR: $_',
      );
    }
  }

  Future get(
    url, {
    Map<String, dynamic> data,
    Map<String, dynamic> params,
  }) async {
    HttpResponse _res = await _request('GET', url, data: data, params: params);
    if (!(_res.code == 0 || _res.code == 10009) && _showError)
      HttpError(_res.code, msg: _res.msg, lang: _lang, exit: _exit);

    return _res;
  }

  Future post(
    url, {
    dynamic data,
    Map<String, dynamic> params,
  }) async {
    HttpResponse _res = await _request('POST', url, data: data, params: params);
    if (!(_res.code == 0 || _res.code == 10009) && _showError)
      HttpError(_res.code, msg: _res.msg, lang: _lang, exit: _exit);

    return _res;
  }
}

/// Http请求响应序列化
class HttpResponse {
  static const int success = 0; // 请求成功
  static const int reqError = -1; // 请求失败
  static const int resError = -2; // 响应失败

  final int code;
  final String msg;
  final dynamic data;

  HttpResponse({this.code, this.msg, this.data});

  factory HttpResponse.fromJson(Map<String, dynamic> json) => HttpResponse(
        code: json['code'] as int,
        msg: json['msg'] as String,
        data: json['data'] is Map<String, dynamic>
            ? json['data'] as Map<String, dynamic>
            : json['data'] as List<dynamic>,
      );
}

/// 统一错误处理
class HttpError {
  static int _code;
  static bool _exit;
  static String _msg, _lang;

  factory HttpError(
    int code, {
    String msg = '',
    bool exit = true,
    String lang = 'en-us',
  }) {
    _msg = msg;
    _code = code;
    _lang = lang;
    _exit = exit;
    return HttpError._();
  }

  HttpError._() {
    switch (_code) {
      case 10001:
        showToast(_msg);
        break;
      case 10003:
        showToast(_strs[_lang]['maintain']);
        break;
      case 10007:
        showToast(_strs[_lang]['resubmit']);
        break;
      case 10008:
        showToast(_strs[_lang]['logout'], onDismiss: () {
          if (Coms.navigator != null && _exit) {
            Coms.navigator.currentState.pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (_) => Index(),
              ),
              (r) => r == null,
            );
          }
        });
        break;
      default:
        showToast(_strs[_lang]['abnormal']);
        break;
    }
  }

  static Map<String, Map<String, String>> _strs = {
    'en-us': {
      'maintain': 'System Maintenance',
      'resubmit': 'Submit Repeatedly',
      'logout': 'Login Status Lost',
      'abnormal': 'Network Congested',
    },
    'zh-tw': {
      'maintain': '系統維護中',
      'resubmit': '請勿重複提交',
      'logout': '登錄狀態丟失',
      'abnormal': '網絡擁擠',
    },
    'ja-jp': {
      'maintain': 'システムメンテナンス',
      'resubmit': '繰り返し送信しないでください',
      'logout': 'ログイン状態の喪失',
      'abnormal': 'ネットワークの混雑',
    },
    'ko-kr': {
      'maintain': '시스템 유지 보수',
      'resubmit': '반복해서 제출하지 마십시오',
      'logout': '로그인 상실',
      'abnormal': '네트워크 혼잡',
    },
  };
}
