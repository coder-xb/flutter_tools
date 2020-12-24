import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import 'package:rether/views/widgets/index.dart';
import '../asset/index.dart';

class HomeAsset extends StatelessWidget {
  final HomeInfoModel model;
  HomeAsset({this.model});

  @override
  Widget build(BuildContext context) {
    return AppTap(
      onTap: () => Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (_) => Asset()),
        (r) => r == null,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColor.c_41C88E,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(I18n.of(context).$t('myAssets'), style: AppText.f16_w7_FFFFFF),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    model != null ? model.myAsset : '0.00000000',
                    style: AppText.f30_w6_FFFFFF
                        .copyWith(fontFamily: 'EncodeSans'),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, bottom: 2),
                    child: Text(
                      'ETH',
                      style: AppText.f10_w7_FFFFFF
                          .copyWith(color: AppColor.c_FFFFFF.withOpacity(.7)),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          I18n.of(context).$t('contractValue'),
                          style: AppText.f12_w5_FFFFFF.copyWith(
                              color: AppColor.c_FFFFFF.withOpacity(.7)),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            model != null
                                ? model.profitAmountAlready
                                : '0.00000000',
                            style: AppText.f15_w6_FFFFFF
                                .copyWith(fontFamily: 'EncodeSans'),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, bottom: 2),
                            child: Text(
                              'ETH',
                              style: AppText.f10_w7_FFFFFF.copyWith(
                                  color: AppColor.c_FFFFFF.withOpacity(.7)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          I18n.of(context).$t('todayIncome'),
                          style: AppText.f12_w5_FFFFFF.copyWith(
                              color: AppColor.c_FFFFFF.withOpacity(.7)),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            model != null ? model.todayIncome : '0.00000000',
                            style: AppText.f15_w6_FFFFFF
                                .copyWith(fontFamily: 'EncodeSans'),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, bottom: 2),
                            child: Text(
                              'ETH',
                              style: AppText.f10_w7_FFFFFF.copyWith(
                                  color: AppColor.c_FFFFFF.withOpacity(.7)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
