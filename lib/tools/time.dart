class Time {
  static String format({int time, String fmt}) {
    fmt = (fmt != null && fmt.isNotEmpty) ? fmt : 'YYYY-MM-DD hh:mm:ss';
    time = (time != null && time != 0)
        ? (time.toString().length != 10 ? time : time * 1000)
        : DateTime.now().millisecondsSinceEpoch;
    DateTime _t = DateTime.fromMillisecondsSinceEpoch(time);
    Map<String, int> _o = {
      'M+': _t.month, // 月
      'D+': _t.day, // 日
      'h+': _t.hour, // 时
      'm+': _t.minute, // 分
      's+': _t.second, // 秒
      'S': _t.millisecondsSinceEpoch // 毫秒
    };
    Iterable<RegExpMatch> year = RegExp(r'(Y+)').allMatches(fmt);
    if (year.length != 0) {
      for (RegExpMatch y in year) {
        fmt = fmt.replaceAll(
            y.group(0), _t.year.toString().substring(4 - y.group(0).length));
      }
    }
    _o.forEach((k, v) {
      Iterable<RegExpMatch> reg = RegExp(r'(' + k + ')').allMatches(fmt);
      if (reg.length != 0) {
        for (RegExpMatch m in reg) {
          fmt = fmt.replaceAll(
              m.group(0),
              m.group(0).length == 1
                  ? v.toString()
                  : ('00' + v.toString()).substring(v.toString().length));
        }
      }
    });
    return fmt;
  }
}
