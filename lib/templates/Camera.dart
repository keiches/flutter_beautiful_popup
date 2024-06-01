import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'Common.dart';
import '../flutter_beautiful_popup.dart';

/// ![](https://raw.githubusercontent.com/jaweii/Flutter_beautiful_popup/master/img/bg/camera.png)
class TemplateCamera extends BeautifulPopupTemplate {
  TemplateCamera(super.options, {super.key});

  @override
  String get illustrationPath => 'camera.png';
  @override
  Color get primaryColor => options.primaryColor ?? const Color(0xff72b2e0);
  @override
  final maxWidth = 400;
  @override
  final maxHeight = 500;
  @override
  final bodyMargin = 20;
  @override
  get layout {
    return [
      Positioned(
        child: background,
      ),
      Positioned(
        top: percentH(42),
        child: title,
      ),
      Positioned(
        top: percentH(54),
        height: percentH(actions == null ? 40 : 24),
        left: percentW(8),
        right: percentW(8),
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
