import 'package:flutter/material.dart';
import 'package:mahjong_sharing_app/view/pages/history/history_page.dart';
import 'package:mahjong_sharing_app/view/pages/record/record_page.dart';
import 'package:mahjong_sharing_app/view/pages/settings/settings_page.dart';

import 'home/home_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  PageController controller = PageController(initialPage: 0);
  int currentIndex = 0;

  final _pageList = [
    const HomePage(),
    const HistoryPage(),
    const RecordPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: appバーはページごとに設定した方がいいかも（可変で行けるならこれでもいい）
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
      ),
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'history',
          ),
          BottomNavigationBarItem(
            label: 'record',
            icon: Icon(Icons.dangerous),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
      controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }
}
