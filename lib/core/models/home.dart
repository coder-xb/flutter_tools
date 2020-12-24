import 'package:flutter/material.dart';
import 'package:rether/tools/index.dart';
import 'package:rether/core/index.dart';

class HomeModel {
  ProfileState state;
  HomeInfoModel model;
  HomeModel({@required this.state, @required this.model});
}

class HomeInfoModel {
  int myNodes,
      superNode,
      contractMax,
      contractMine,
      inviteNumsAll,
      rewardsTeamLayers;
  String myAsset,
      todayIncome,
      contractValue,
      releaseDayMax,
      profitMultiple,
      rewardTeamRate,
      rewardInviteRate,
      profitAmountAlready;
  List<HomeNoticeModel> notice;
  HomePrizeModel prizePool;

  HomeInfoModel({
    this.notice,
    this.myAsset,
    this.myNodes,
    this.prizePool,
    this.superNode,
    this.todayIncome,
    this.contractMax,
    this.contractMine,
    this.contractValue,
    this.inviteNumsAll,
    this.releaseDayMax,
    this.profitMultiple,
    this.rewardTeamRate,
    this.rewardInviteRate,
    this.rewardsTeamLayers,
    this.profitAmountAlready,
  });

  factory HomeInfoModel.fromJson(Map<String, dynamic> json) {
    List _notices = (json['notice_list'] as List).cast();
    return HomeInfoModel(
      myNodes: json['my_nodes'] as int,
      myAsset: json['my_asset'] as String,
      superNode: json['super_node'] as int,
      todayIncome: json['today_income'] as String,
      contractMax: json['contract_nums_max'] as int,
      contractMine: json['contract_nums_my'] as int,
      inviteNumsAll: json['invite_nums_all'] as int,
      contractValue: json['contract_value'] as String,
      releaseDayMax: json['release_day_max'] as String,
      prizePool: HomePrizeModel.fromJson(json['game1']),
      profitMultiple: json['profit_multiple'] as String,
      rewardTeamRate: json['reward_team_rate'] as String,
      rewardInviteRate: json['reward_invite_rate'] as String,
      rewardsTeamLayers: json['rewards_team_layers'] as int,
      profitAmountAlready: json['profit_amount_already'] as String,
      notice: List.generate(
          _notices.length, (int i) => HomeNoticeModel.fromJson(_notices[i])),
    );
  }
}

class HomeNoticeModel {
  int id;
  String desc, title;
  HomeNoticeModel({this.id, this.desc, this.title});

  factory HomeNoticeModel.fromJson(Map<String, dynamic> json) =>
      HomeNoticeModel(
        id: json['id'] as int,
        title: json['title'] as String,
        desc: json['description'] as String,
      );
}

class HomePrizeModel {
  String prize, today, total, time;
  HomePrizeModel({this.prize, this.today, this.total, this.time});

  factory HomePrizeModel.fromJson(Map<String, dynamic> json) => HomePrizeModel(
        prize: json['prize_pool_amount'] as String,
        today: json['pie_reward_amount_new'] as String,
        total: json['pie_reward_amount_total'] as String,
        time: Time.format(
            time: json['pie_reward_amount_updatetime'] as int,
            fmt: 'YYYY/MM/DD hh:mm'),
      );
}
