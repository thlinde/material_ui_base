// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'model/store.dart';
import 'model/utility.dart';
import 'widgets/top_bar.dart';
import 'pages/settings.dart';
import 'pages/page01.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await GetStorage.init();
  final ProgController prog = Get.put(ProgController());
  final StoreController store = Get.put(StoreController());

  windowManager.waitUntilReadyToShow().then((_) async{
    store.setTodayStr(todayDate());
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setSize(Size(prog.width, prog.height));
    await windowManager.setPosition(Offset(prog.xPos, prog.yPos));
    await windowManager.setPreventClose(true);
    await windowManager.show();
    await windowManager.setSkipTaskbar(false);
  });

  runApp(const ThlindeApp());
}

class ThlindeApp extends StatelessWidget {
  const ThlindeApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'thlinde App'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WindowListener {
  final ProgController prog = Get.find();
  PageController page = PageController();
  // Initialize Items for NavigatenSideBar
  final navList = initNavList();

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: WindowCaption(
          brightness: Theme.of(context).brightness,
          title: const Text(
            // todo thlinde: change window title
            'Testprogramm',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          ),
          backgroundColor: Colors.grey[500],
        ),
        preferredSize: const Size.fromHeight(kWindowCaptionHeight),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TopBar(),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // thlinde:SideBar
                  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: SizedBox(
                        width: 250.0,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: navList.length,
                          itemBuilder: (context, index) => Card(
                            elevation: 0.0,
                            color: Colors.grey[200],
                            key: ValueKey(navList[index].index),
                            child: ListTile(
                              onTap: () {
                                page.jumpToPage(navList[index].index);
                              },
                              title: Text(
                                navList[index].title,
                                style: const TextStyle(fontSize: 14),
                              ),
                              leading: Icon(navList[index].icon),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 250,
                          height: 145,
                          child: ListView(
                            padding: const EdgeInsets.all(8),
                            children: [
                              const Divider(),
                              Card(
                                elevation: 0.0,
                                color: Colors.grey[200],
                                child: ListTile(
                                  onTap: () {
                                    // thlinde:Settings is last Page: length+1
                                    page.jumpToPage(navList.length + 1);
                                  },
                                  title: const Text(
                                    "Einstellungen",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  leading: const Icon(
                                    Icons.settings,
                                  ),
                                ),
                              ),
                              Card(
                                elevation: 0.0,
                                color: Colors.red[300],
                                child: ListTile(
                                  textColor: Colors.grey[100],
                                  onTap: () {
                                    windowManager.close();
                                  },
                                  title: const Text(
                                    "Programm beenden",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  leading: Icon(Icons.exit_to_app,
                                      color: Colors.grey[100]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // thlinde:Pages
                Expanded(
                    // Todo here comes the pages
                    child: PageView(
                      controller: page,
                      children: const [
                        GeneralPage(title: 'Testseite 1'),
                        GeneralPage(title: 'Testseite 2'),
                        GeneralPage(title: 'Testseite 3'),
                        SettingsPage(title: 'Einstellungen'),
                      ],
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      Get.defaultDialog(
        title: 'Beendigung des Programms',
        titleStyle: const TextStyle(fontWeight: FontWeight.w700),
        middleText: 'Soll das Programm wirklich beendet werden?',
        middleTextStyle: const TextStyle(fontWeight: FontWeight.w400),
        textCancel: 'Nein',
        textConfirm: 'Ja',
        cancelTextColor: Colors.grey[800],
        confirmTextColor: Colors.grey[100],
        buttonColor: Colors.red[300],
        backgroundColor: Colors.grey[300],
        radius: 4,
        onConfirm: () async {
          await saveProgSettings();
          windowManager.destroy();
          // thlinde:closes Dialog, here not neccessary because of destroying
          // Get.back();
        },
      );
    }
  }

  saveProgSettings() async {
    final pos = await windowManager.getPosition();
    prog.setXPos(pos.dx);
    prog.setyPos(pos.dy);
    final size = await windowManager.getSize();
    prog.setHeight(size.height);
    prog.setWidth(size.width);
  }
}
