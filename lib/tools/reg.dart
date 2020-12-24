const List<String> IDCARD_DICT = const [
  '11=北京',
  '12=天津',
  '13=河北',
  '14=山西',
  '15=内蒙古',
  '21=辽宁',
  '22=吉林',
  '23=黑龙江',
  '31=上海',
  '32=江苏',
  '33=浙江',
  '34=安徽',
  '35=福建',
  '36=江西',
  '37=山东',
  '41=河南',
  '42=湖北',
  '43=湖南',
  '44=广东',
  '45=广西',
  '46=海南',
  '50=重庆',
  '51=四川',
  '52=贵州',
  '53=云南',
  '54=西藏',
  '61=陕西',
  '62=甘肃',
  '63=青海',
  '64=宁夏',
  '65=新疆',
  '71=台湾',
  '81=香港',
  '82=澳门',
  '91=国外',
];

class Reg {
  /// simple mobile
  static final String regMobileSimple = '^[1]\\d{10}\$';

  /// exact mobile
  /// china mobile: 134(0-8), 135, 136, 137, 138, 139, 147, 150, 151, 152, 157, 158, 159, 178, 182, 183, 184, 187, 188, 198
  /// china unicom: 130, 131, 132, 145, 155, 156, 166, 171, 175, 176, 185, 186
  /// china telecom: 133, 153, 173, 177, 180, 181, 189, 199
  /// global star: 1349
  /// virtual operator: 170
  static final String regMobileExact =
      '^((13[0-9])|(14[5,7])|(15[0-3,5-9])|(16[6])|(17[0,1,3,5-8])|(18[0-9])|(19[1,8,9]))\\d{8}\$';

  /// telephone number
  static final regTel = '^0\\d{2,3}[- ]?\\d{7,8}';

  /// id card number which length is 15
  static final String regIdCard15 =
      '^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}\$';

  /// id card number which length is 18
  static final String regIdCard18 =
      '^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9Xx])\$';

  /// email
  static final String regEmail =
      '^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$';

  /// url
  static final String regUrl = '[a-zA-Z]+://[^\\s]*';

  /// Chinese character
  static final String regZh = '[\\u4e00-\\u9fa5]';

  /// date which pattern is 'YYYY-MM-DD'
  static final String regDate =
      '^(?:(?!0000)[0-9]{4}-(?:(?:0[1-9]|1[0-2])-(?:0[1-9]|1[0-9]|2[0-8])|(?:0[13-9]|1[0-2])-(?:29|30)|(?:0[13578]|1[02])-31)|(?:[0-9]{2}(?:0[48]|[2468][048]|[13579][26])|(?:0[48]|[2468][048]|[13579][26])00)-02-29)\$';

  /// ip address
  static final String regIp =
      '((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)';

  /// matches handle
  static bool matches(String reg, String inp) {
    if (inp == null || inp.isEmpty) return false;
    return RegExp(reg).hasMatch(inp);
  }

  /// whether input matches regex of simple mobile
  static bool isMobileSimple(String inp) => matches(regMobileSimple, inp);

  /// whether input matches regex of exact mobile
  static bool isMobileExact(String inp) => matches(regMobileExact, inp);

  /// whether input matches regex of telephobne mobile
  static bool isTel(String inp) => matches(regTel, inp);

  /// whether input matches regex of id card number which length is 15
  static bool isIDCard15(String inp) => matches(regIdCard15, inp);

  /// whether input matches regex of id card number which length is 18
  static bool isIDCard18(String inp) => matches(regIdCard18, inp);

  /// whether input matches regex of id card number
  static bool isIDCard(String inp) {
    if (inp != null && inp.length == 15) return isIDCard15(inp);
    if (inp != null && inp.length == 18) return isIDCard18(inp);
    return false;
  }

  /// whether input matches regex of exact id card number which length is 15
  static final Map<String, String> cityMap = Map();
  static bool isIDCard18Exact(String inp) {
    if (isIDCard18(inp)) {
      List<int> _factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      List<String> _suffix = [
        '1',
        '0',
        'X',
        '9',
        '8',
        '7',
        '6',
        '5',
        '4',
        '3',
        '2'
      ];

      if (cityMap.isEmpty) {
        List<String> list = IDCARD_DICT;
        List<MapEntry<String, String>> mapEntryList = List();
        for (int i = 0, len = list.length; i < len; i++) {
          List<String> city = list[i].trim().split('=');
          MapEntry<String, String> mapEntry = MapEntry(city[0], city[1]);
          mapEntryList.add(mapEntry);
        }
        cityMap.addEntries(mapEntryList);
      }
      if (cityMap[inp.substring(0, 2)] != null) {
        int sum = 0;
        for (int i = 0; i < 17; i++) {
          sum += (inp.codeUnitAt(i)) - '0'.codeUnitAt(0) * _factor[i];
        }
        String _last = String.fromCharCode(inp.codeUnitAt(17));
        return _last == _suffix[sum % 11];
      }
    }
    return false;
  }

  /// whether input matches regex of email
  static bool isEmail(String inp) => matches(regEmail, inp);

  /// whether input matches regex of URL
  static bool isURL(String inp) => matches(regUrl, inp);

  /// whether input matches regex of Chinese character
  static bool isZh(String inp) => '〇' == inp || matches(regZh, inp);

  /// whether input matches regex of date which pattern is 'YYYY-MM-DD'
  static bool isDate(String inp) => matches(regDate, inp);

  /// whether input matches regex of ip address
  static bool isIP(String inp) => matches(regIp, inp);
}
