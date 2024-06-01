import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/flutter_beautiful_popup.dart';

class MyTemplate extends BeautifulPopupTemplate {
  MyTemplate(super.options, {super.key});

  @override
  final illustrationKey = 'images/my_template.png';
  @override
  Color get primaryColor => options.primaryColor ?? const Color(0xff000000);
  @override
  final maxWidth = 400;
  @override
  final maxHeight = 600;
  @override
  final bodyMargin = 10;
  @override
  get layout {
    return [
      Positioned(
        child: background,
      ),
      Positioned(
        top: percentH(10),
        child: title,
      ),
      Positioned(
        top: percentH(40),
        height: percentH(actions == null ? 32 : 42),
        left: percentW(10),
        right: percentW(10),
        child: content,
      ),
      Positioned(
        bottom: percentW(10),
        left: percentW(10),
        right: percentW(10),
        child: actions ?? Container(),
      ),
    ];
  }
}
