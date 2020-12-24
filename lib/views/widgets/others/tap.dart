import 'package:flutter/material.dart';

class AppTap extends StatelessWidget {
  final Icon icon;
  final Widget child;
  final VoidCallback onTap;

  AppTap({
    Key key,
    this.icon,
    this.child,
    @required this.onTap,
  })  : assert(child != null || icon != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return icon == null
        ? InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: child,
            onTap: onTap,
          )
        : IconButton(
            icon: icon,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            disabledColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: onTap,
          );
  }
}
