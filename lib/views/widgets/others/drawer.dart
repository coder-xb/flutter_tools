import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import 'tap.dart';
import 'star.dart';
import 'appbar.dart';
import '../image/index.dart';
import '../../pages/mian/index.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          _appBar(context),
          Expanded(
            child: SafeArea(
              top: false,
              child: Container(
                margin: EdgeInsets.fromLTRB(30, 40, 30, 0),
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: .5,
                      color: AppColor.c_626F81.withOpacity(.2),
                    ),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          _taps(
                            icon: AppIcon.home,
                            text: I18n.of(context).$t('home'),
                            size: 20,
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(builder: (_) => Home()),
                                (r) => r == null,
                              );
                            },
                          ),
                          _taps(
                            icon: AppIcon.wallet,
                            text: I18n.of(context).$t('asset'),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(builder: (_) => Asset()),
                                (r) => r == null,
                              );
                            },
                          ),
                          _taps(
                            icon: AppIcon.contract,
                            size: 19,
                            text: I18n.of(context).$t('contract'),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(builder: (_) => Contract()),
                                (r) => r == null,
                              );
                            },
                          ),
                          _taps(
                            icon: AppIcon.nodes,
                            size: 19,
                            text: I18n.of(context).$t('nodes'),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(builder: (_) => Nodes()),
                                (r) => r == null,
                              );
                            },
                          ),
                          _taps(
                            icon: AppIcon.setting,
                            size: 20,
                            text: I18n.of(context).$t('setting'),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(builder: (_) => Setting()),
                                (r) => r == null,
                              );
                            },
                          ),
                          _taps(
                            icon: AppIcon.faq,
                            size: 20,
                            text: I18n.of(context).$t('report'),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(builder: (_) => Report()),
                                (r) => r == null,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: .5,
                            color: AppColor.c_626F81.withOpacity(.2),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          _bottomTap(
                            icon: AppIcon.exit,
                            text: I18n.of(context).$t('exit'),
                            onTap: () => Coms.logout(context),
                          ),
                          _bottomTap(
                            icon: AppIcon.share1,
                            text: I18n.of(context).$t('share'),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(builder: (_) => Share(0)),
                                (r) => r == null,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    ProfileModel _model = Provider.of<ProfileState>(context).model;
    return AppTap(
      onTap: () => Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(builder: (_) => Setting()),
        (r) => r == null,
      ),
      child: MyAppBar(
        height: 110,
        color: Colors.transparent,
        title: Container(
          padding: EdgeInsets.fromLTRB(30, 20, 20, 0),
          child: Row(
            children: <Widget>[
              _avatar(_model),
              _infos(
                level: Provider.of<ProfileState>(context).level,
                nickname: _model != null
                    ? Provider.of<ProfileState>(context).model.nickname
                    : '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar(ProfileModel model) => Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 3,
            color: AppColor.c_FCBE6B,
          ),
          borderRadius: BorderRadius.circular(80),
        ),
        child: ClipOval(
          child: SizedBox(
            width: 76,
            height: 76,
            child: model != null && model.avatar.isNotEmpty
                ? FadeImg.assetNetwork(
                    image: model.avatar,
                    imageScale: 2,
                    fit: BoxFit.cover,
                    placeholder: 'assets/images/icon_avatar.png',
                  )
                : Image.asset(
                    'assets/images/icon_avatar.png',
                    scale: 2,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      );

  Widget _infos({
    int level = 0,
    int nums = 0,
    String nickname = '',
  }) =>
      Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 8, bottom: 6),
                child: Text(
                  nickname,
                  maxLines: 1,
                  style: AppText.f18_w6_596373,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                Levels.v(level),
                style: AppText.f12_w6_A3ACBB,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: List.generate(
                    6,
                    (int index) =>
                        Star(level > -1 && level < 7 && level > index),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _taps({
    double size = 18,
    @required String text,
    @required IconData icon,
    @required VoidCallback onTap,
  }) =>
      AppTap(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Icon(icon, size: size, color: AppColor.c_A3ACBB),
              ),
              Container(
                margin: EdgeInsets.only(left: 12),
                child: Text(text, style: AppText.f15_w5_596373),
              ),
            ],
          ),
        ),
      );

  Widget _bottomTap({
    @required String text,
    @required IconData icon,
    @required VoidCallback onTap,
  }) =>
      AppTap(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5),
                child: Icon(icon, size: 20, color: AppColor.c_596373),
              ),
              Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Text(text, style: AppText.f14_w5_596373),
              ),
            ],
          ),
        ),
      );
}
