import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_beautiful_popup/flutter_beautiful_popup.dart';

void main() {
  /*testWidgets('testing', (WidgetTester tester) async {
    await tester.pumpWidget(
      Builder(
        builder: (BuildContext context) {
          final popup = BeautifulPopup(
            context: context,
            template: TemplateType.blueRocket,
          );
          popup.show(
            title: 'String or Widget',
            content: 'String or Widget',
            actions: [
              popup.button(
                label: 'Close',
                onPressed: Navigator
                    .of(context)
                    .pop,
              ),
            ],
            // bool barrierDismissible = false,
            // Widget close,
          );
          return const Placeholder();
        },
      ),
    );
  });*/
  testWidgets('showPopup', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      title: 'Flutter_beautiful_popup',
      theme: ThemeData(primaryColor: Colors.blue),
      home: Material(child: Container()),
    ));
    final BuildContext context = tester.element(find.byType(Container));

    // apply your tests to dialog or its contents here.
    final popup = BeautifulPopup(
      context: context,
      template: TemplateType.gift,
    );
    await popup.show(
      title: 'Popup Title',
      content: 'Popup Content',
      actions: [
        popup.buttonBuilder(
          label: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      ],
      // bool barrierDismissible = false,
      // Widget close,
    );
    await tester.tap(find.text('Popup Title'));
    await tester.pump(); // start animation
    await tester.pump(const Duration(seconds: 5));
    // final Finder titleFinder = find.text('Popup Title');
    final Finder contentFinder = find.text('Popup Content');
    // final Finder buttonFinder = find.text('Close');
    // final Finder buttonFinder1 = find.byElementType(BeautifulPopupButton);
    // expect(titleFinder, findsWidgets);
    expect(contentFinder, findsWidgets);
    // expect(buttonFinder, findsWidgets);
    // expect(buttonFinder1, findsWidgets);
  });
}
