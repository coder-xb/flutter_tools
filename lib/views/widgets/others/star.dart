import 'package:flutter/material.dart';
import 'package:rether/core/index.dart';

class Star extends StatelessWidget {
  final bool show;
  final double size;
  Star(this.show, {Key key, this.size = 16}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: Icon(
        AppIcon.star,
        size: size,
        color: show ? AppColor.c_FFBD74 : AppColor.c_A3ACBB,
      ),
    );
  }
}
