import 'package:flutter/material.dart';

class SetTile extends StatelessWidget {
  final Color color;
  final double height;
  final Border border;
  final VoidCallback onTap;
  final Widget prefix, suffix;
  final List<BoxShadow> shadow;
  final EdgeInsetsGeometry padding;
  final Icon prefixIcon, suffixIcon;

  const SetTile({
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 18),
    this.color = Colors.white,
    this.prefix,
    this.suffix,
    this.border,
    this.shadow,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Container(
        decoration: BoxDecoration(boxShadow: shadow, color: color),
        child: Container(
          alignment: Alignment.center,
          height: height,
          margin: padding,
          decoration: BoxDecoration(border: border),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              prefix != null
                  ? (prefixIcon != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            prefixIcon,
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: prefix,
                            ),
                          ],
                        )
                      : prefix)
                  : (prefixIcon != null ? prefixIcon : Container(height: 0)),
              suffix != null
                  ? (suffixIcon != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: suffix,
                            ),
                            suffixIcon,
                          ],
                        )
                      : suffix)
                  : (suffixIcon != null ? suffixIcon : Container(height: 0)),
            ],
          ),
        ),
      ),
    );
  }
}
