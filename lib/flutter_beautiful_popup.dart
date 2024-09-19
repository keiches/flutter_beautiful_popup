library beautiful_popup;

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'templates/Common.dart';
import 'templates/OrangeRocket.dart';
import 'templates/GreenRocket.dart';
import 'templates/OrangeRocket2.dart';
import 'templates/Coin.dart';
import 'templates/BlueRocket.dart';
import 'templates/Thumb.dart';
import 'templates/Gift.dart';
import 'templates/Camera.dart';
import 'templates/Notification.dart';
import 'templates/Geolocation.dart';
import 'templates/Success.dart';
import 'templates/Fail.dart';
import 'templates/Authentication.dart';
import 'templates/Term.dart';
import 'templates/RedPacket.dart';

export 'templates/Common.dart';
export 'templates/OrangeRocket.dart';
export 'templates/GreenRocket.dart';
export 'templates/OrangeRocket2.dart';
export 'templates/Coin.dart';
export 'templates/BlueRocket.dart';
export 'templates/Thumb.dart';
export 'templates/Gift.dart';
export 'templates/Camera.dart';
export 'templates/Notification.dart';
export 'templates/Geolocation.dart';
export 'templates/Success.dart';
export 'templates/Fail.dart';
export 'templates/Authentication.dart';
export 'templates/Term.dart';
export 'templates/RedPacket.dart';

// Predefined template types
enum TemplateType {
  orangeRocket,
  greenRocket,
  orangeRocket2,
  coin,
  blueRocket,
  thumb,
  gift,
  camera,
  notification,
  geolocation,
  success,
  fail,
  authentication,
  term,
  redPacket,
}

/*class PopupButton {
  final String label;
  final VoidCallback onPressed;
  bool outline;
  bool flat;
  TextStyle labelStyle;

  PopupButton(
      {required this.label,
      required this.onPressed,
      this.outline = false,
      this.flat = false,
      this.labelStyle = const TextStyle()});
}*/

class BeautifulPopup {
  final BuildContext _context;
  BuildContext get context => _context;

  final TemplateType? _template;
  TemplateType? get template => _template;

  BeautifulPopupTemplate Function(BeautifulPopup options)? _templateBuilder;
  BeautifulPopupTemplate get instance {
    final build = _templateBuilder;
    if (build != null) return build(this);
    switch (_template) {
      case TemplateType.orangeRocket:
        return TemplateOrangeRocket(this);
      case TemplateType.greenRocket:
        return TemplateGreenRocket(this);
      case TemplateType.orangeRocket2:
        return TemplateOrangeRocket2(this);
      case TemplateType.coin:
        return TemplateCoin(this);
      case TemplateType.blueRocket:
        return TemplateBlueRocket(this);
      case TemplateType.thumb:
        return TemplateThumb(this);
      case TemplateType.gift:
        return TemplateGift(this);
      case TemplateType.camera:
        return TemplateCamera(this);
      case TemplateType.success:
        return TemplateSuccess(this);
      case TemplateType.authentication:
        return TemplateAuthentication(this);
      case TemplateType.term:
        return TemplateTerm(this);
      case TemplateType.notification:
        return TemplateNotification(this);
      case TemplateType.geolocation:
        return TemplateGeolocation(this);
      case TemplateType.fail:
        return TemplateFail(this);
      case TemplateType.redPacket:
      default:
        return TemplateRedPacket(this);
    }
  }

  ui.Image? _illustration;
  ui.Image? get illustration => _illustration;

  dynamic title = '';
  dynamic content = '';
  List<Widget>? actions;
  Widget? close;
  // bool? barrierDismissible;

  Color? primaryColor;

  BeautifulPopup({
    required BuildContext context,
    required TemplateType template,
  })  : _context = context,
        _template = template {
    primaryColor = instance.primaryColor; // Get the default primary color.
  }

  BeautifulPopup.builder({
    required BuildContext context,
    required BeautifulPopupTemplate Function(BeautifulPopup options)
        templateBuilder,
  })  : _context = context,
        _template = null,
        _templateBuilder = templateBuilder {
    primaryColor = instance.primaryColor; // Get the default primary color.
  }

  /// Recolor the BeautifulPopup.
  /// This method is  kind of slow.R
  Future<BeautifulPopup> recolor(Color color) async {
    primaryColor = color;
    final illustrationData = await rootBundle.load(instance.illustrationKey);
    final buffer = illustrationData.buffer.asUint8List();
    img.Image? asset;
    asset = img.decodePng(buffer);
    if (asset != null) {
      img.adjustColor(
        asset,
        saturation: 0,
        // hue: 0,
      );
      img.colorOffset(
        asset,
        red: color.red,
        // I don't know why the effect is nicer with the number ╮(╯▽╰)╭
        green: color.green ~/ 3,
        blue: color.blue ~/ 2,
        alpha: 0,
      );
    }
    final paint = await ui.instantiateImageCodec(
        asset != null ? Uint8List.fromList(img.encodePng(asset)) : buffer);
    final nextFrame = await paint.getNextFrame();
    _illustration = nextFrame.image;
    return this;
  }

  /// A method that shows the dialog.
  ///
  /// `title`: Must be a `String` or `Widget`. Defaults to `''`.
  ///
  /// `content`: Must be a `String` or `Widget`. Defaults to `''`.
  ///
  /// `actions`: The set of actions that are displayed at bottom of the dialog,
  ///
  ///  Typically this is a list of [BeautifulPopup.button]. Defaults to `[]`.
  ///
  /// `barrierDismissible`: Determine whether this dialog can be dismissed. Default to `False`.
  ///
  /// `close`: Close widget.
  Future<T?> show<T>({
    dynamic title,
    dynamic content,
    List<Widget>? actions,
    Duration transitionDuration = const Duration(milliseconds: 150),
    Color barrierColor = const Color(0x61000000),
    bool barrierDismissible = false,
    String? barrierLabel,
    Widget? close,
  }) {
    this.title = title;
    this.content = content;
    this.actions = actions;
    // this.barrierDismissible = barrierDismissible;
    this.close = close ?? instance.close;
    final child = PopScope(
      canPop: barrierDismissible,
      child: instance,
    );
    return showGeneralDialog<T>(
      // barrierColor: Colors.black38,
      barrierColor: barrierColor, // Color(0x61000000),
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      context: context,
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return child;
      },
      transitionDuration: transitionDuration,
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
    );
  }

  /// Hides the dialog.
  ///
  /// {@tool snippet}
  ///
  /// Typical usage for closing a route is as follows:
  ///
  /// ```dart
  /// void _handleClose() {
  ///   popup.hide();
  /// }
  /// ```
  /// {@end-tool}
  /// {@tool snippet}
  ///
  /// A dialog box might be closed with a result:
  ///
  /// ```dart
  /// void _handleAccept() {
  ///   popup.hide(true); // dialog returns true
  /// }
  /// ```
  /// {@end-tool}
  void hide<T>([T? result]) {
    Navigator.of(_context).pop<T>(result);
  }

  /// Creates a button widget for dialog actions.
  ///
  /// [label] is the text to display on the button.
  /// [onPressed] is the callback function to call when the button is pressed.
  /// [outline] determines whether the button should be an outline button. Defaults to `false`.
  /// [flat] determines whether the button should be a flat button. Defaults to `false`.
  /// [labelStyle] is the style of the button label. Defaults to a default text style.
  ///
  /// Returns a [Widget] that represents the button.
  BeautifulPopupButton get buttonBuilder => instance.button;

  /*Widget buttonBuilder({
    required String label,
    required VoidCallback onPressed,
    bool outline = false,
    bool flat = false,
    TextStyle labelStyle = const TextStyle(),
  }) =>
      instance.button(
          label: label,
          onPressed: onPressed,
          outline: outline,
          flat: flat,
          labelStyle: labelStyle);*/

  /*List<Widget> actionsBuilder(List<PopupButton> objects) {
    final buttonBuilder = instance.button;
    return objects.map((object) {
      return buttonBuilder(
          label: object.label,
          onPressed: object.onPressed,
          outline: object.outline,
          flat: object.flat,
          labelStyle: object.labelStyle);
    }).toList();
  }*/
}

typedef FrameCallback = void Function(Duration duration);

class DialogAction {
  final String label;
  final VoidCallback onPressed;
  bool outline;
  bool flat;
  TextStyle labelStyle;

  DialogAction({
    required this.label,
    required this.onPressed,
    this.outline = false,
    this.flat = false,
    this.labelStyle = const TextStyle(),
  });
}

/// Displays a dialog above the current contents of the app.
///
/// This function allows for customization of aspects of the dialog popup.
///
/// This function takes a `contentBuilder` which is used to build the primary
/// content of the route (typically a dialog widget). Content below the dialog
/// is dimmed with a [ModalBarrier]. The widget returned by the `pageBuilder`
/// does not share a context with the location that [showGeneralDialog] is
/// originally called from. Use a [StatefulBuilder] or a custom
/// [StatefulWidget] if the dialog needs to update dynamically.
///
/// The `context` argument is used to look up the [Navigator] for the
/// dialog. It is only used when the method is called. Its corresponding widget
/// can be safely removed from the tree before the dialog is closed.
///
/// The `useRootNavigator` argument is used to determine whether to push the
/// dialog to the [Navigator] furthest from or nearest to the given `context`.
/// By default, `useRootNavigator` is `true` and the dialog route created by
/// this method is pushed to the root navigator.
///
/// If the application has multiple [Navigator] objects, it may be necessary to
/// call `Navigator.of(context, rootNavigator: true).pop(result)` to close the
/// dialog rather than just `Navigator.pop(context, result)`.
///
/// The `barrierDismissible` argument is used to determine whether this route
/// can be dismissed by tapping the modal barrier. This argument defaults
/// to false. If `barrierDismissible` is true, a non-null `barrierLabel` must be
/// provided.
///
/// The `barrierLabel` argument is the semantic label used for a dismissible
/// barrier. This argument defaults to `null`.
///
/// The `barrierColor` argument is the color used for the modal barrier. This
/// argument defaults to `Color(0x80000000)`.
///
/// The `transitionDuration` argument is used to determine how long it takes
/// for the route to arrive on or leave off the screen. This argument defaults
/// to 200 milliseconds.
///
/// The `transitionBuilder` argument is used to define how the route arrives on
/// and leaves off the screen. By default, the transition is a linear fade of
/// the page's contents.
///
/// The `routeSettings` will be used in the construction of the dialog's route.
/// See [RouteSettings] for more details.
///
/// {@macro flutter.widgets.RawDialogRoute}
///
/// Returns a [Future] that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the dialog was closed.
///
/// ### State Restoration in Dialogs
///
/// Using this method will not enable state restoration for the dialog. In order
/// to enable state restoration for a dialog, use [Navigator.restorablePush]
/// or [Navigator.restorablePushNamed] with [RawDialogRoute].
///
/// For more information about state restoration, see [RestorationManager].
///
/// {@tool sample}
/// This sample demonstrates how to create a restorable dialog. This is
/// accomplished by enabling state restoration by specifying
/// [WidgetsApp.restorationScopeId] and using [Navigator.restorablePush] to
/// push [RawDialogRoute] when the button is tapped.
///
/// {@macro flutter.widgets.RestorationManager}
///
/// ** See code in examples/api/lib/widgets/routes/show_general_dialog.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [DisplayFeatureSubScreen], which documents the specifics of how
///    [DisplayFeature]s can split the screen into sub-screens.
///  * [showGeneralDialog], which allows for customization of the dialog popup.
Future<T?> showCustomDialog<T extends Object?>({
  required BuildContext context,
  required String title,
  required dynamic content,
  WidgetBuilder? contentBuilder,
  required List<DialogAction> actions,
  TemplateType template = TemplateType.orangeRocket,
  bool barrierDismissible = false,
  String? barrierLabel,
  Color barrierColor = const Color(0x80000000),
  Duration transitionDuration = const Duration(milliseconds: 200),
  // RouteTransitionsBuilder? transitionBuilder,
  // bool useRootNavigator = true,
  // RouteSettings? routeSettings,
  // Offset? anchorPoint,
}) {
  assert(_debugIsActive(context));

  Widget dialogTitle = Text(title);
  Widget dialogContent;

  if (content == null && contentBuilder != null) {
    // content가 없고 contentBuilder가 제공된 경우
    dialogContent = contentBuilder(context);
  } else if (content is String) {
    // content가 문자열인 경우
    dialogContent = Text(content);
  } else if (content is Widget) {
    // content가 Widget인 경우
    dialogContent = content;
  } else {
    // content가 없고 contentBuilder도 없는 경우
    dialogContent = Container(); // 빈 컨테이너
  }

  // final ThemeData theme = Theme.of(context);
  // theme.platform === TargetPlatform.android
  final popup = BeautifulPopup(
    context: context,
    template: template,
  );
  return popup.show(
    title: dialogTitle,
    content: dialogContent,
    actions: actions.length == 1
        ? <Widget>[
            popup.buttonBuilder(
              label: actions[0].label,
              onPressed: () {
                actions[0].onPressed();
                popup.hide();
              },
              outline: actions[1].outline,
              flat: actions[1].flat,
              labelStyle: actions[1].labelStyle,
            ),
          ]
        : <Widget>[
            popup.buttonBuilder(
              label: actions[0].label,
              onPressed: () {
                actions[0].onPressed();
                popup.hide();
              },
              outline: actions[1].outline,
              flat: actions[1].flat,
              labelStyle: actions[1].labelStyle,
            ),
            popup.buttonBuilder(
              label: actions[1].label,
              onPressed: () {
                actions[1].onPressed();
                popup.hide();
              },
              outline: actions[1].outline,
              flat: actions[1].flat,
              labelStyle: actions[1].labelStyle,
            )
          ],
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    transitionDuration: transitionDuration,
  );
}

bool _debugIsActive(BuildContext context) {
  if (context is Element && !context.debugIsActive) {
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary('This BuildContext is no longer valid.'),
      ErrorDescription(
          'The showDialog function context parameter is a BuildContext that is no longer valid.'),
      ErrorHint(
        'This can commonly occur when the showDialog function is called after awaiting a Future. '
        'In this situation the BuildContext might refer to a widget that has already been disposed during the await. '
        'Consider using a parent context instead.',
      ),
    ]);
  }
  return true;
}
