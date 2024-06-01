import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../flutter_beautiful_popup.dart';
import 'Common.dart';

/// ![](https://raw.githubusercontent.com/jaweii/Flutter_beautiful_popup/master/img/bg/authentication.png)
class TemplateAuthentication extends BeautifulPopupTemplate {
  TemplateAuthentication(super.options, {super.key});

  @override
  String get illustrationPath => 'authentication.png';
  @override
  Color get primaryColor => options.primaryColor ?? const Color(0xff15c0ec);
  @override
  final maxWidth = 400;
  @override
  final maxHeight = 617;
  @override
  final bodyMargin = 0;
  @override
  get layout {
    return [
      Positioned(
        child: background,
      ),
      Positioned(
        top: percentH(32),
        child: title,
      ),
      Positioned(
        top: percentH(44),
        left: percentW(10),
        right: percentW(10),
        height: percentH(actions == null ? 52 : 38),
        child: content,
      ),
      Positioned(
        bottom: percentW(8),
        left: percentW(8),
        right: percentW(8),
        child: actions ?? Container(),
      ),
    ];
  }
}
