class Levels {
  Levels._();
  static String v(int v) => _map.containsKey(v) ? _map[v] : _map[0];
  static Map<int, String> _map = {
    0: 'COLD NODE',
    1: 'BASIC NODE',
    2: 'CHILD NODE',
    3: 'PARENT NODE',
    4: 'LIGHT NODE',
    5: 'WEIGHT NODE',
    6: 'SUPER NODE',
  };
}

class CurSymbol {
  CurSymbol._();
  static String v(String v) =>
      _map.containsKey(v.toUpperCase()) ? _map[v.toUpperCase()] : _map['USD'];
  static Map<String, String> _map = {
    'USD': '\$',
    'CNY': '¥',
    'JPY': '￥',
    'EUR': '€',
    'GBP': '￡',
    'CHF': 'CHF',
    'KRW': '₩',
    'TWD': 'NT\$',
    'SGD': 'S\$',
  };
}

class CurrencyModel {
  String code, name, rate;
  CurrencyModel({
    this.code, // 货币标识
    this.name, // 货币名称
    this.rate, // 货币汇率
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        name: json['name'] as String,
        rate: json['rate'] as String,
        code: json['currency'] as String,
      );
}

class LanguageModel {
  String code, name, rate;
  LanguageModel({
    this.code, // 语言标识
    this.name, // 语言名称
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
        name: json['name'] as String,
        code: json['lang'] as String,
      );
}

class ShareModel {
  int level;
  String uid, code, avatar, phone, email, content, qrcode, nickname, phoneCode;

  ShareModel({
    this.uid,
    this.code,
    this.phone,
    this.email,
    this.level,
    this.qrcode,
    this.avatar,
    this.content,
    this.nickname,
    this.phoneCode,
  });

  factory ShareModel.fromJson(Map<String, dynamic> json) => ShareModel(
        uid: json['uid'] as String,
        level: json['levels'] as int,
        phone: json['phone'] as String,
        email: json['email'] as String,
        avatar: json['avatar'] as String,
        content: json['content'] as String,
        code: json['invite_code'] as String,
        nickname: json['nickname'] as String,
        phoneCode: json['phone_code'] as String,
        qrcode: json['qr_code_content'] as String,
      );
}
