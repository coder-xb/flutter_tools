import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import 'package:rether/views/widgets/index.dart';
import '../prize/index.dart';

class HomePrize extends StatelessWidget {
  final HomePrizeModel model;
  HomePrize({this.model});

  @override
  Widget build(BuildContext context) {
    return AppTap(
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute(builder: (_) => Prize()),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColor.c_000000.withOpacity(.3),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            model != null ? model.prize : '0.00000000',
                            style: AppText.f24_w6_FF7B76
                                .copyWith(fontFamily: 'EncodeSans'),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5, right: 15),
                          child: Text(
                            'ETH',
                            style: AppText.f10_w7_FFFFFF.copyWith(
                                color: AppColor.c_FFFFFF.withOpacity(.7)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    model != null ? model.today : '0.00000000',
                    style: AppText.f16_w5_FCBE6B
                        .copyWith(fontFamily: 'EncodeSans'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            DefaultTextStyle(
              style: AppText.f12_w5_FFFFFF,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(I18n.of(context).$t('homePrizeAmount')),
                  Text(I18n.of(context).$t('homePrizeToday')),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: DefaultTextStyle(
                style: AppText.f10_w4_FFFFFF
                    .copyWith(color: AppColor.c_FFFFFF.withOpacity(.7)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(I18n.of(context).$t(
                      'homePrizeTime',
                      params: {
                        'time': model != null ? model.time : '----/--/-- --:--'
                      },
                    )),
                    Text(I18n.of(context).$t(
                      'homePrizeTotal',
                      params: {
                        'num': model != null ? model.total : '0.00000000'
                      },
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
