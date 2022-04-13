// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'model/store.dart';
import 'model/ui.dart';
import 'widgets/top_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await GetStorage.init();
  final ProgController prog = Get.put(ProgController());

  windowManager.waitUntilReadyToShow().then((_) async{
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
          title: Text(
              'Testprogramm',
            style: TextStyle(color: Colors.grey[200]),
          ),
          backgroundColor: Colors.grey[700],
        ),
        preferredSize: const Size.fromHeight(kWindowCaptionHeight),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const TopBar(),
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
                              title: Text(navList[index].title),
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
                                  title: const Text("Einstellungen"),
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
                                  title: const Text("Programm beenden"),
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
                      children: [
                        Container(
                          color: Colors.white,
                          child: const Center(
                            child: Text(
                              'Item1',
                              style: TextStyle(fontSize: 35),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: const Center(
                            child: Text(
                              'Item2',
                              style: TextStyle(fontSize: 35),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: const Center(
                            child: Text(
                              'Item3',
                              style: TextStyle(fontSize: 35),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: const Center(
                            child: Text(
                              'Einstellungen',
                              style: TextStyle(fontSize: 35),
                            ),
                          ),
                        ),
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
