import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../../widgets/index.dart';
import 'nickname.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.c_FFFFFF,
      body: Column(
        children: <Widget>[
          _appBar(),
          _avatar(Provider.of<ProfileState>(context).model.avatar),
          _nickname(),
        ],
      ),
    );
  }

  Widget _appBar() => MyAppBar(
        color: Colors.transparent,
        title:
            Text(I18n.of(context).$t('profile'), style: AppText.f17_w6_151515),
        prefix: AppTap(
          onTap: () => Navigator.of(context).pop(),
          icon: Icon(AppIcon.back, size: 14, color: AppColor.c_2F3231),
        ),
      );

  Widget _avatar(String avatar) => Container(
        margin: EdgeInsets.only(top: 30, bottom: 30),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(48),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColor.c_000000.withOpacity(.05),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: AppTap(
                onTap: _getImg,
                child: ClipOval(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: 120,
                        height: 120,
                        color: AppColor.c_FFFFFF,
                        child: avatar != null && avatar.isNotEmpty
                            ? FadeImg.assetNetwork(
                                image: avatar,
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
                      Container(
                        width: 120,
                        height: 120,
                        alignment: Alignment.center,
                        color: AppColor.c_000000.withOpacity(.15),
                        child: Icon(AppIcon.image, color: AppColor.c_FFFFFF),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Text(
              I18n.of(context).$t('chageAvatar'),
              style: AppText.f13_w5_A3ACBB,
            ),
          ],
        ),
      );

  Widget _nickname() => SetTile(
        onTap: () => Navigator.of(context).push(
          CupertinoPageRoute(
              builder: (_) =>
                  Nickname(Provider.of<ProfileState>(context).model.nickname)),
        ),
        height: 50,
        color: AppColor.c_FFFFFF,
        shadow: <BoxShadow>[
          BoxShadow(
            color: AppColor.c_000000.withOpacity(.05),
            blurRadius: 20,
          ),
        ],
        padding: EdgeInsets.symmetric(horizontal: 20),
        prefix:
            Text(I18n.of(context).$t('nickname'), style: AppText.f15_w5_596373),
        suffix: Text(Provider.of<ProfileState>(context).model.nickname,
            style: AppText.f13_w4_A3ACBB),
        suffixIcon: Icon(AppIcon.next, size: 12, color: AppColor.c_A3ACBB),
      );

  Future _getImg() async {
    ImagePickerSaver.pickImage(source: ImageSource.gallery)
        .then((File file) async {
      if (file != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AppLoading('submiting'),
        );
        String _path = file.path;
        FormData _form = FormData.fromMap({
          'type': 'avatar',
          'file': await MultipartFile.fromFile(
            _path,
            filename: _path.substring(_path.lastIndexOf('/') + 1, _path.length),
          ),
        });
        $Http(
          upload: true,
          lang: $SP.getString('lang', def: 'en-us'),
        ).post(API.upload, data: _form).then((fileRes) {
          if (fileRes.code == 0)
            $Http(
              token: $SP.getString('token'),
              lang: $SP.getString('lang', def: 'en-us'),
            ).post(
              API.setting['avatar'],
              data: {'avatar': fileRes.data['file_url']},
            ).then((res) {
              Navigator.of(context).pop();
              if (res.code == 0)
                Provider.of<ProfileState>(context, listen: false)
                    .setAvatar(fileRes.data['file_url']);
            });
          else
            Navigator.of(context).pop();
        });
      }
    });
  }
}
