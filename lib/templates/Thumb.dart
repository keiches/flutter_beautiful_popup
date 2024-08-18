import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'Common.dart';
import '../flutter_beautiful_popup.dart';
import 'package:auto_size_text/auto_size_text.dart';

/// ![](https://raw.githubusercontent.com/jaweii/Flutter_beautiful_popup/master/img/bg/thumb.png)
class TemplateThumb extends BeautifulPopupTemplate {
  TemplateThumb(super.options, {super.key});

  @override
  String get illustrationPath => 'thumb.png';
  @override
  Color get primaryColor => options.primaryColor ?? const Color(0xfffb675d);
  @override
  final maxWidth = 400;
  @override
  final maxHeight = 570;
  @override
  final bodyMargin = 0;

  @override
  Widget get title {
    if (options.title is Widget) {
      return SizedBox(
        width: percentW(54),
        height: percentH(10),
        child: options.title,
      );
    }
    return SizedBox(
      width: percentW(54),
      child: Opacity(
        opacity: 0.9,
        child: AutoSizeText(
          options.title,
          maxLines: 1,
          style: TextStyle(
            fontSize: Theme.of(options.context).textTheme.titleLarge?.fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  BeautifulPopupButton get button {
    return ({
      required String label,
      required VoidCallback onPressed,
      bool outline = false,
      bool flat = false,
      TextStyle labelStyle = const TextStyle(),
    }) {
      final gradient = LinearGradient(colors: [
        primaryColor.withOpacity(0.5),
        primaryColor,
      ]);
      final double elevation = (outline || flat) ? 0 : 2;
      final labelColor =
          (outline || flat) ? primaryColor : Colors.white.withOpacity(0.95);
      final decoration = BoxDecoration(
        gradient: (outline || flat) ? null : gradient,
        borderRadius: const BorderRadius.all(Radius.circular(80.0)),
        border: Border.all(
          color: outline ? primaryColor : Colors.transparent,
          width: (outline && !flat) ? 1 : 0,
        ),
      );
      final minHeight = 40.0 - (outline ? 2 : 0);
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateColor.transparent,
          elevation: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              // highlightElevation
              return 0.0;
            }
            return elevation;
          }),
          // splashColor
          overlayColor: WidgetStateColor.transparent,
          padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(
              const EdgeInsets.all(0)),
          shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          )),
        ),
        onPressed: onPressed,
        child: Ink(
          decoration: decoration,
          child: Container(
            constraints: BoxConstraints(
              minWidth: 100,
              minHeight: minHeight,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                // color: Colors.white.withOpacity(0.95),
                color: labelColor,
              ).merge(labelStyle),
            ),
          ),
        ),
      );
    };
  }

  @override
  get layout {
    return [
      Positioned(
        child: background,
      ),
      Positioned(
        top: percentH(10),
        left: percentW(10),
        child: title,
      ),
      Positioned(
        top: percentH(28),
        left: percentW(10),
        right: percentW(10),
        height: percentH(actions == null ? 62 : 50),
        child: content,
      ),
      Positioned(
        bottom: percentW(14),
        left: percentW(10),
        right: percentW(10),
        child: actions ?? Container(),
      ),
    ];
  }
}
