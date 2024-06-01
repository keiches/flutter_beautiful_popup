import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../flutter_beautiful_popup.dart';

/// ![](https://raw.githubusercontent.com/jaweii/Flutter_beautiful_popup/master/img/bg/fail.png)
class TemplateFail extends TemplateSuccess {
  TemplateFail(super.options, {super.key});

  @override
  String get illustrationPath => 'fail.png';
  @override
  Color get primaryColor => options.primaryColor ?? const Color(0xffF77273);
}
