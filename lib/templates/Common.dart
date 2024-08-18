import 'dart:ui' as ui;

// import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../flutter_beautiful_popup.dart';

typedef BeautifulPopupButton = Widget Function({
  required String label,
  required VoidCallback onPressed,
  TextStyle labelStyle,
  bool outline,
  bool flat,
});

/// You can extend this class to custom your own template.
abstract class BeautifulPopupTemplate extends StatefulWidget {
  final BeautifulPopup options;

  BeautifulPopupTemplate(this.options, {super.key});

  final State<StatefulWidget> state = BeautifulPopupTemplateState();

  @override
  State<StatefulWidget> createState() => BeautifulPopupTemplateState();

  Size get size {
    double screenWidth = MediaQuery.of(options.context).size.width;
    double screenHeight = MediaQuery.of(options.context).size.height;
    double height = screenHeight > maxHeight ? maxHeight : screenHeight;
    double width;
    height = height - bodyMargin * 2;
    if ((screenHeight - height) < 140) {
      // For keep close button visible
      height = screenHeight - 140;
      width = height / maxHeight * maxWidth;
    } else {
      if (screenWidth > maxWidth) {
        width = maxWidth - bodyMargin * 2;
      } else {
        width = screenWidth - bodyMargin * 2;
      }
      height = width / maxWidth * maxHeight;
    }
    return Size(width, height);
  }

  double get width => size.width;
  double get height => size.height;

  double get maxWidth;
  double get maxHeight;
  double get bodyMargin;

  /// The path of the illustration asset.
  String get illustrationPath => '';
  String get illustrationKey =>
      'packages/flutter_beautiful_popup/img/bg/$illustrationPath';
  Color get primaryColor;

  double percentW(double n) {
    return width * n / 100;
  }

  double percentH(double n) {
    return height * n / 100;
  }

  Widget get close {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      minWidth: 45,
      height: 45,
      padding: const EdgeInsets.all(0),
      onPressed: Navigator.of(options.context).pop,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: const Icon(Icons.close, color: Colors.white70, size: 26),
      ),
    );
  }

  Widget get background {
    final illustration = options.illustration;
    return illustration == null
        ? Image.asset(
            illustrationKey,
            width: percentW(100),
            height: percentH(100),
            fit: BoxFit.fill,
          )
        : CustomPaint(
            size: Size(percentW(100), percentH(100)),
            painter: ImageEditor(
              image: illustration,
            ),
          );
  }

  Widget get title {
    if (options.title is Widget) {
      return Container(
        width: percentW(100),
        height: percentH(10),
        alignment: Alignment.center,
        child: options.title,
      );
    }
    return Container(
      alignment: Alignment.center,
      width: percentW(100),
      height: percentH(10),
      child: Opacity(
        opacity: 0.95,
        child: AutoSizeText(
          options.title,
          maxLines: 1,
          style: TextStyle(
            fontSize: Theme.of(options.context).textTheme.titleLarge?.fontSize,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget get content {
    return options.content is String
        ? AutoSizeText(
            options.content,
            minFontSize: 10,
            style: const TextStyle(
              color: Colors.black87,
            ),
          )
        : options.content;
  }

  Widget? get actions {
    final actionsList = options.actions;
    if (actionsList == null || actionsList.isEmpty) return null;
    return Flex(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      direction: Axis.horizontal,
      children: actionsList
          .map(
            (button) => Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: button,
              ),
            ),
          )
          .toList(),
    );
  }

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
                color: labelColor,
              ).merge(labelStyle),
            ),
          ),
        ),
      );
    };
  }

  List<Positioned> get layout;
}

class BeautifulPopupTemplateState extends State<BeautifulPopupTemplate> {
  OverlayEntry? closeEntry;
  @override
  void initState() {
    super.initState();

    // Display close button
    Future.delayed(Duration.zero, () {
      closeEntry = OverlayEntry(
        builder: (ctx) {
          final bottom = (MediaQuery.of(context).size.height -
                      widget.height -
                      widget.bodyMargin * 2) /
                  4 -
              20;
          return Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                left: 0,
                right: 0,
                bottom: bottom,
                child: Container(
                  alignment: Alignment.center,
                  child: widget.options.close ?? Container(),
                ),
              )
            ],
          );
        },
      );
      final entry = closeEntry;
      if (entry != null) Overlay.of(context).insert(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.all(widget.bodyMargin),
            height: widget.height,
            width: widget.width,
            child: Stack(
              clipBehavior: Clip.none,
              children: widget.layout,
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    closeEntry?.remove();
    super.dispose();
  }
}

class ImageEditor extends CustomPainter {
  ui.Image image;
  ImageEditor({
    required this.image,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTRB(0, 0, size.width, size.height),
      Paint(),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
