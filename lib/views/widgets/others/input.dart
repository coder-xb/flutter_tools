import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  final Color color;
  final double horPadding, verPadding;
  final String placehoder;
  final TextStyle style, placehoderStyle;
  final TextInputType inputType;
  final bool obscure, disabled;
  final Border border;
  final Widget prefix, suffix;
  final TextEditingController controller;
  final TextInputAction inputAction;
  final ValueChanged<String> onInput;
  final VoidCallback onComplete;
  final int maxLength, maxLines;
  final FocusNode focusNode;
  final List<TextInputFormatter> formatter;
  final TextAlign textAlign;
  final bool autofocus;

  const Input({
    this.color = Colors.white,
    this.horPadding = 16,
    this.verPadding = 16,
    this.placehoder,
    this.style,
    this.inputType,
    this.obscure = false,
    this.border,
    this.suffix,
    this.prefix,
    this.controller,
    this.inputAction,
    this.maxLength,
    this.focusNode,
    this.onInput,
    this.onComplete,
    this.formatter,
    this.maxLines = 1,
    this.textAlign = TextAlign.left,
    this.disabled = false,
    this.autofocus = false,
    this.placehoderStyle = const TextStyle(color: Colors.grey),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: color, border: border),
      padding: suffix != null
          ? EdgeInsets.only(left: horPadding)
          : EdgeInsets.symmetric(horizontal: horPadding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          prefix != null
              ? Container(
                  margin: EdgeInsets.only(right: 12),
                  child: prefix,
                )
              : Container(width: 0, height: 0),
          Expanded(
            child: Material(
              type: MaterialType.transparency,
              child: TextField(
                autofocus: autofocus,
                controller: controller,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: verPadding, horizontal: 0),
                  hintText: placehoder,
                  hintStyle: placehoderStyle,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.zero,
                  ),
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  fillColor: color,
                  filled: true,
                  counterText: '',
                ),
                style: style,
                focusNode: focusNode,
                textAlign: textAlign,
                obscureText: obscure,
                keyboardType: inputType,
                textInputAction: inputAction,
                maxLength: maxLength,
                onChanged: onInput,
                inputFormatters: formatter,
                enabled: !disabled,
                maxLines: maxLines,
                onEditingComplete: onComplete,
              ),
            ),
          ),
          suffix != null
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  child: suffix,
                )
              : Container(width: 0, height: 0),
        ],
      ),
    );
  }
}
