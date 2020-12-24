import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rether/tools/index.dart';
import 'package:rether/core/index.dart';
import '../widgets/index.dart';
import 'index.dart';
import 'mian/home/index.dart';

class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2500));
    _animation = Tween(begin: 0.75, end: 1.0).animate(_controller);
    _animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed)
        Version.check(context, dismiss: _enter);
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Screen.ins = Screen(w: 375, h: 812, font: true)..init(context);
    return FadeTransition(
      opacity: _animation,
      child: Scaffold(
        backgroundColor: AppColor.c_596373,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_main.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: SafeArea(
            top: true,
            child: Center(
              child: Image.asset(
                'assets/images/icon_logo.png',
                scale: 2,
                width: 52,
                height: 52,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _enter() async {
    Navigator.of(context).pushAndRemoveUntil(
      CupertinoPageRoute(
        builder: (_) =>
            $SP.getString('token') != null && $SP.getString('token').isNotEmpty
                ? Home()
                : Index(),
      ),
      (r) => r == null,
    );
  }
}
