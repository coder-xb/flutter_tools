import 'package:rether/tools/index.dart';

class PrizeModel {
  String zoIssue, toIssue, prize, today, total;

  PrizeModel({
    this.prize, // 总奖金
    this.today, // 今日派奖
    this.total, // 累计派奖
    this.zoIssue, // 昨日期号
    this.toIssue, // 今日期号
  });
  factory PrizeModel.fromJson(Map<String, dynamic> json) => PrizeModel(
        prize: json['prize_pool_amount'] as String,
        today: json['pie_reward_amount_new'] as String,
        total: json['pie_reward_amount_total'] as String,
        toIssue: json['issue_today'] as String,
        zoIssue: json['issue_yesterday'] as String,
      );
}

class RankModel {
  int total, rank;
  String reward, issue, uid, avatar, nickname, phoneCode, phone, email;

  RankModel({
    this.uid, // UID
    this.rank, // 排名
    this.total, // 份数
    this.issue, // 期号
    this.email, // 邮箱
    this.phone, // 手机
    this.reward, // 奖金
    this.avatar, // 头像
    this.nickname, // 昵称
    this.phoneCode, // 手机区域代码
  });

  factory RankModel.fromJson(Map<String, dynamic> json) => RankModel(
        uid: json['uid'] as String,
        rank: json['number'] as int,
        issue: json['issue'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
        avatar: json['avatar'] as String,
        total: (json['number_total'] != null
            ? json['number_total'] as int
            : json['number_total_all']) as int,
        nickname: json['nickname'] as String,
        phoneCode: json['phone_code'] as String,
        reward: (json['reward_amount'] != null
            ? json['reward_amount'] as String
            : json['reward_amount_all']) as String,
      );
}

class PrizeLogsModel {
  int id, rank, type;
  String uid,
      time,
      text,
      issue,
      phone,
      email,
      avatar,
      amount,
      nickname,
      phoneCode;

  PrizeLogsModel({
    this.id, // 日志id
    this.uid, // 用户UID
    this.rank, // 排名
    this.type, // 类型标识
    this.time, // 时间
    this.text, // 类型描述
    this.issue, // 期号
    this.phone, // 手机
    this.email, // 邮箱
    this.avatar, // 头像
    this.amount, // 数量
    this.nickname, // 昵称
    this.phoneCode, // 手机区域代码
  });

  factory PrizeLogsModel.fromJson(Map<String, dynamic> json) => PrizeLogsModel(
      id: json['id'] as int,
      type: json['type'] as int,
      uid: json['uid'] as String,
      rank: json['number'] as int,
      phone: json['phone'] as String,
      email: json['email'] as String,
      issue: json['issue'] as String,
      amount: json['amount'] as String,
      avatar: json['avatar'] as String,
      text: json['type_text'] as String,
      nickname: json['nickname'] as String,
      phoneCode: json['phone_code'] as String,
      time: Time.format(
          time: json['createtime'] as int, fmt: 'YYYY/MM/DD hh:mm'));
}
