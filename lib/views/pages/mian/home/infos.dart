import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import 'package:rether/views/widgets/index.dart';
import '../nodes/index.dart';
import '../contract/index.dart';

class HomeInfos extends StatelessWidget {
  final HomeInfoModel model;
  HomeInfos({this.model});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Wrap(
        runSpacing: 16,
        alignment: WrapAlignment.spaceBetween,
        children: <Widget>[
          AppTap(
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (_) => Contract()),
              (r) => r == null,
            ),
            child: Container(
              width: Screen.ins.setSize(165),
              padding: EdgeInsets.fromLTRB(16, 18, 14, 18),
              decoration: BoxDecoration(
                color: AppColor.c_7DBEF4,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    I18n.of(context).$t('myContract'),
                    style: AppText.f13_w6_FFFFFF.copyWith(
                      color: AppColor.c_FFFFFF.withOpacity(.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${model != null ? model.contractMine : 0}',
                          style: AppText.f30_w6_FFFFFF
                              .copyWith(fontFamily: 'EncodeSans'),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, bottom: 2),
                          child: Text(
                            I18n.of(context).$t('copies'),
                            style: AppText.f12_w5_FFFFFF.copyWith(
                                color: AppColor.c_FFFFFF.withOpacity(.7)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    I18n.of(context).$t('myContractCan', params: {
                      'num': model != null
                          ? max(0, model.contractMax - model.contractMine)
                          : 0
                    }),
                    style: AppText.f12_w4_FFFFFF.copyWith(
                      color: AppColor.c_FFFFFF.withOpacity(.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
            ),
          ),
          AppTap(
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (_) => Nodes()),
              (r) => r == null,
            ),
            child: Container(
              width: Screen.ins.setSize(165),
              padding: EdgeInsets.fromLTRB(16, 18, 14, 18),
              decoration: BoxDecoration(
                color: AppColor.c_FF7B76,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    I18n.of(context).$t('validNode'),
                    style: AppText.f13_w6_FFFFFF.copyWith(
                      color: AppColor.c_FFFFFF.withOpacity(.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${model != null ? model.myNodes : 0}',
                          style: AppText.f30_w6_FFFFFF
                              .copyWith(fontFamily: 'EncodeSans'),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, bottom: 2),
                          child: Text(
                            I18n.of(context).$t('node'),
                            style: AppText.f12_w5_FFFFFF.copyWith(
                                color: AppColor.c_FFFFFF.withOpacity(.7)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    I18n.of(context).$t('haveNode',
                        params: {'num': model != null ? model.superNode : 0}),
                    style: AppText.f12_w4_FFFFFF.copyWith(
                      color: AppColor.c_FFFFFF.withOpacity(.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: Screen.ins.setSize(165),
            padding: EdgeInsets.fromLTRB(16, 18, 14, 18),
            decoration: BoxDecoration(
              color: AppColor.c_B67AF6,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  I18n.of(context).$t('levelInterests'),
                  style: AppText.f13_w6_FFFFFF.copyWith(
                    color: AppColor.c_FFFFFF.withOpacity(.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${model != null ? Num.toPercent(double.parse(model.rewardInviteRate), pos: 2) : '0.00'}',
                        style: AppText.f30_w6_FFFFFF
                            .copyWith(fontFamily: 'EncodeSans'),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, bottom: 2),
                        child: Text(
                          '%',
                          style: AppText.f12_w5_FFFFFF.copyWith(
                              color: AppColor.c_FFFFFF.withOpacity(.7)),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  I18n.of(context).$t('myContractPer', params: {
                    'rate':
                        '${model != null ? Num.toPercent(double.parse(model.rewardTeamRate)) : 0}%',
                    'level': model != null ? model.rewardsTeamLayers : 0
                  }),
                  style: AppText.f12_w4_FFFFFF.copyWith(
                    color: AppColor.c_FFFFFF.withOpacity(.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
          Container(
            width: Screen.ins.setSize(165),
            padding: EdgeInsets.fromLTRB(16, 18, 14, 18),
            decoration: BoxDecoration(
              color: AppColor.c_FCBE6B,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  I18n.of(context).$t('benchmarkYield'),
                  style: AppText.f13_w6_FFFFFF.copyWith(
                    color: AppColor.c_FFFFFF.withOpacity(.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${model != null ? Num.toPercent(double.parse(model.profitMultiple)) : 0}',
                        style: AppText.f30_w6_FFFFFF
                            .copyWith(fontFamily: 'EncodeSans'),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5, bottom: 2),
                        child: Text(
                          '%',
                          style: AppText.f12_w5_FFFFFF.copyWith(
                              color: AppColor.c_FFFFFF.withOpacity(.7)),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  I18n.of(context).$t('benchmarkYieldMost', params: {
                    'num': model != null
                        ? Num.toFixed(double.parse(model.releaseDayMax), pos: 1)
                        : '0.0',
                    'time': '24H'
                  }),
                  style: AppText.f12_w4_FFFFFF.copyWith(
                    color: AppColor.c_FFFFFF.withOpacity(.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
