import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rether/core/index.dart';
import 'package:rether/tools/index.dart';
import '../../../widgets/index.dart';
import 'infos.dart';
import 'asset.dart';
import 'prize.dart';
import '../notice/index.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future _future;
  HomeModel _model;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _future = _get();
  }

  Future<HomeModel> _get() async {
    HttpResponse _res = await $Http(
      token: $SP.getString('token'),
      lang: $SP.getString('lang', def: 'en-us'),
    ).get(API.home);
    if (_res.code == 0) {
      ProfileModel _profile = ProfileModel.fromJson(_res.data);
      Provider.of<ProfileState>(context, listen: false).initInfo(
        model: _profile,
        level: _res.data['levels'] as int,
        callback: () {
          _model = HomeModel(
            model: HomeInfoModel.fromJson(_res.data),
            state: Provider.of<ProfileState>(context, listen: false),
          );
        },
      );
    }

    return _model;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Coms.exitApp(context),
      child: Scaffold(
        key: _key,
        drawer: AppDrawer(),
        backgroundColor: AppColor.c_596373,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColor.c_596373, AppColor.c_768BA3],
            ),
          ),
          child: SafeArea(
            top: false,
            child: FutureBuilder(
              future: _future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? _widget(home: snapshot.data)
                    : _widget();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _widget({HomeModel home}) => Column(
        children: <Widget>[
          _appBar(model: home != null ? home : null),
          _notice(model: home != null ? home.model : null),
          _body(model: home != null ? home.model : null),
        ],
      );

  Widget _appBar({HomeModel model}) => MyAppBar(
        height: 105,
        color: Colors.transparent,
        title: AppTap(
          onTap: () => _key.currentState.openDrawer(),
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 15, 16, 0),
            child: Row(children: <Widget>[
              _avatar(Provider.of<ProfileState>(context).model != null
                  ? Provider.of<ProfileState>(context).model.avatar
                  : null),
              Expanded(
                child: _infos(model: model),
              ),
            ]),
          ),
        ),
      );

  Widget _body({HomeInfoModel model}) => Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            children: <Widget>[
              HomeAsset(model: model),
              HomeInfos(model: model),
              HomePrize(model: model?.prizePool),
              Container(
                margin: EdgeInsets.only(top: 40, bottom: 30),
                child: Image.asset(
                  'assets/images/icon_textlogo.png',
                  width: 50,
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _avatar(String avatar) => Container(
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
        ),
      );

  Widget _infos({HomeModel model}) {
    int _nums = model != null ? model.model.inviteNumsAll : 0,
        _level = model != null ? model.state.level : 0;
    String _nickname = model != null
        ? model.state.model.nickname
        : I18n.of(context).$t('loading');
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 25,
            margin: EdgeInsets.only(top: 8, bottom: 6),
            child: Text(
              _nickname,
              maxLines: 1,
              style: AppText.f18_w6_FFFFFF,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    Levels.v(_level),
                    style: AppText.f12_w6_FFFFFF
                        .copyWith(color: AppColor.c_FFFFFF.withOpacity(.6)),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: List.generate(
                        6,
                        (int index) =>
                            Star(_level > -1 && _level < 7 && _level > index),
                      ),
                    ),
                  ),
                ],
              ),
              _likes(_nums),
            ],
          ),
        ],
      ),
    );
  }

  Widget _likes(int nums) => Container(
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_like.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 6),
              child: Text('$nums', style: AppText.f15_w6_FFFFFF),
            ),
            Icon(Icons.favorite, size: 14, color: AppColor.c_FFFFFF),
          ],
        ),
      );

  Widget _notice({HomeInfoModel model}) => Container(
        margin: EdgeInsets.fromLTRB(16, 25, 16, 0),
        child: Marquee(
          style: AppText.f15_w4_596373,
          alignment: Alignment.centerLeft,
          shadow: <BoxShadow>[
            BoxShadow(color: AppColor.c_FFFFFF.withOpacity(.05), blurRadius: 15)
          ],
          suffix: Icon(AppIcon.next1, size: 15, color: AppColor.c_596373),
          prefix: Icon(AppIcon.notice, size: 16, color: AppColor.c_596373),
          texts: (model != null && model.notice.length != 0)
              ? List.generate(
                  model.notice.length, (int i) => model.notice[i].title)
              : <String>[I18n.of(context).$t('loading')],
          onTap: (int index) => Navigator.of(context).push(
            CupertinoPageRoute(builder: (BuildContext context) => Notice()),
          ),
        ),
      );
}
