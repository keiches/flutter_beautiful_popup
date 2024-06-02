import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_beautiful_popup/flutter_beautiful_popup.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github-gist.dart';
import 'package:url_launcher/url_launcher.dart';
import 'my_template.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_beautiful_popup',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter_Beautiful_Popup'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
    final templates = [
      TemplateType.gift,
      TemplateType.camera,
      TemplateType.notification,
      TemplateType.geolocation,
      TemplateType.success,
      TemplateType.fail,
      // TemplateType.orangeRocket,
      TemplateType.greenRocket,
      TemplateType.orangeRocket2,
      TemplateType.coin,
      TemplateType.blueRocket,
      TemplateType.thumb,
      TemplateType.authentication,
      TemplateType.term,
      TemplateType.redPacket,
    ];

    demos = templates.map((template) {
      return BeautifulPopup(
        context: context,
        template: template,
      );
    }).toList();
  }

  List<BeautifulPopup> demos = [];

  BeautifulPopup? activeDemo;

  Widget get showcases {
    final popup = BeautifulPopup.builder(
      context: context,
      templateBuilder: (options) => MyTemplate(options),
    );
    return Flex(
      mainAxisSize: MainAxisSize.max,
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 10, 10),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Text(
                'All Templates:',
                style: Theme.of(context).textTheme.headlineMedium?.merge(
                      const TextStyle(
                        backgroundColor: Colors.transparent,
                      ),
                    ),
              ),
              const Spacer(),
              TextButton(
                child: const Text('Customize'),
                onPressed: () {
                  popup.show(
                    title: 'Example',
                    content: Container(
                      color: Colors.black12,
                      child: const Text(
                          'This popup shows you how to customize your own BeautifulPopupTemplate.'),
                    ),
                    actions: [
                      popup.button(
                        label: 'Code',
                        labelStyle: const TextStyle(),
                        onPressed: () async {
                          await _launchURL(
                            'https://github.com/jaweii/Flutter_beautiful_popup/blob/master/example/lib/MyTemplate.dart',
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 20,
              runSpacing: 30,
              children: demos.map((demo) {
                final i = demos.indexWhere((d) => d.template == demo.template);
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 160),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: demo.primaryColor?.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image.asset(
                          demo.instance.illustrationKey,
                          height: 54,
                          width: 100,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Demo-${i + 1}\n${demo.instance.runtimeType}',
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    openDemo(demo: demo);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget get body {
    final exampleCode = '''
final popup = BeautifulPopup(
  context: context,
  template: ${activeDemo?.instance.runtimeType ?? '// Select a template in right'},
);
                                                                  
popup.show(
  title: 'String',
  content: 'BeautifulPopup is a flutter package that is responsible for beautify your app popups.',
  actions: [
    popup.button(
      label: 'Close',
      onPressed: Navigator.of(context).pop,
    ),
  ],
);
    ''';
    if (MediaQuery.of(context).size.width > 1024) {
      return Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              color: activeDemo?.primaryColor?.withOpacity(0.25) ??
                  Theme.of(context).primaryColor.withOpacity(0.25),
              child: Flex(
                mainAxisSize: MainAxisSize.max,
                direction: Axis.vertical,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                    child: Text(
                      '# Usage',
                      style: Theme.of(context).textTheme.headlineMedium?.merge(
                            const TextStyle(
                              color: Colors.black54,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: HighlightView(
                        exampleCode,
                        language: 'dart',
                        theme: githubGistTheme,
                        padding: const EdgeInsets.all(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: showcases,
          ),
        ],
      );
    } else {
      return showcases;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor:
            activeDemo?.primaryColor ?? Theme.of(context).primaryColor,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            child: Image.asset(
              'images/github.png',
              width: 32,
              height: 32,
            ),
            onPressed: () async {
              await _launchURL(
                'https://github.com/keiches/flutter_beautiful_popup',
              );
            },
          ),
        ],
      ),
      body: body,
    );
  }

  void changeColor(
    BeautifulPopup demo,
    void Function(Color? color)? callback,
  ) {
    Color? color = demo.primaryColor?.withOpacity(0.5);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: color == null ? const Color(0xFF000000) : color!,
            onColorChanged: (c) => color = c,
            // showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Got it'),
            onPressed: () async {
              callback?.call(color);
            },
          ),
        ],
      ),
    );
  }

  openDemo({
    required BeautifulPopup demo,
    dynamic title = 'String',
    dynamic content =
        'BeautifulPopup is a flutter package that is responsible for beautify your app popups.',
  }) {
    assert(title is Widget || title is String);
    setState(() {
      activeDemo = demo;
    });
    demo.show(
      title: title,
      content: content,
      actions: <Widget>[
        demo.button(
          label: 'Recolor',
          onPressed: () {
            changeColor(demo, (color) async {
              demo = await BeautifulPopup(
                context: context,
                template: demo.template!,
              ).recolor(color!);
              // NOTE: use_build_context_synchronously
              if (!context.mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.of(context).popUntil((route) {
                if (route.settings.name == '/') return true;
                return false;
              });
              openDemo(demo: demo);
            });
          },
        ),
        demo.button(
          label: 'Show more',
          outline: true,
          onPressed: () {
            Navigator.of(context).pop();
            if (title is Widget) {
              openDemo(demo: demo);
              return;
            }
            getTitle() {
              return Opacity(
                opacity: 0.95,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '[Widget]',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: demo.primaryColor,
                        backgroundColor: Colors.white70,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Icon(
                        Icons.star,
                        color: demo.primaryColor?.withOpacity(0.75),
                        size: 10,
                      ),
                    )
                  ],
                ),
              );
            }

            getContent() {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                ),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CupertinoButton(
                          child: const Text('Remove all buttons'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            demo = BeautifulPopup(
                              context: context,
                              template: demo.template!,
                            );
                            demo.show(
                              title: getTitle(),
                              content: getContent(),
                              actions: [],
                            );
                          },
                        ),
                        CupertinoButton(
                          child: const Text('Keep one button'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            demo = BeautifulPopup(
                              context: context,
                              template: demo.template!,
                            );
                            demo.show(
                              title: getTitle(),
                              content: getContent(),
                              actions: [
                                demo.button(
                                  label: 'One button',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        CupertinoButton(
                          child: const Text('Remove Close button'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            demo = BeautifulPopup(
                              context: context,
                              template: demo.template!,
                            );
                            demo.show(
                              title: getTitle(),
                              content: getContent(),
                              close: Container(),
                              barrierDismissible: true,
                              actions: [
                                demo.button(
                                  label: 'Close',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        CupertinoButton(
                          child: const Text('Change button direction'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            demo = BeautifulPopup(
                              context: context,
                              template: demo.template!,
                            );
                            demo.show(
                              title: getTitle(),
                              content: Flex(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                direction: Axis.vertical,
                                children: <Widget>[
                                  const Text('1. blabla... \n2. blabla...'),
                                  const Spacer(),
                                  demo.button(
                                    label: 'Accpet',
                                    onPressed: () {},
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        // primary: Colors.red, // foreground
                                        foregroundColor:
                                            WidgetStateProperty.all<Color>(
                                                Colors.red),
                                        overlayColor:
                                            WidgetStateProperty.resolveWith(
                                                (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.focused)) {
                                            return Colors.red;
                                          }
                                          // hoverColor
                                          if (states
                                              .contains(WidgetState.hovered)) {
                                            return Colors.transparent;
                                          }
                                          // highlightColor
                                          if (states
                                              .contains(WidgetState.pressed)) {
                                            return Colors.transparent;
                                          }
                                          return null; // Defer to the widget's default.
                                        }),
                                      ),
                                      onPressed: Navigator.of(context).pop,
                                      child: const Text('Close'),
                                    ),
                                  ),
                                ],
                              ),
                              barrierDismissible: true,
                              actions: [],
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            }

            openDemo(
              demo: demo,
              title: getTitle(),
              content: getContent(),
            );
          },
        )
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    Uri urlParsed = Uri.parse(url);
    await canLaunchUrl(urlParsed)
        ? await launchUrl(urlParsed)
        : throw 'Could not launch $urlParsed';
  }
}
