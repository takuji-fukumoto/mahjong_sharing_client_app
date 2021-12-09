import 'package:flutter/material.dart';
import 'package:mahjong_sharing_app/model/navigation_bar_item_model.dart';
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
  String title = 'Home';

  final _navBarItems = [
    NavigationBarItemModel(
      title: 'Home',
      page: const HomePage(),
      item: const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'home',
      ),
    ),
    NavigationBarItemModel(
      title: 'History',
      page: const HistoryPage(),
      item: const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard),
        label: 'history',
      ),
    ),
    NavigationBarItemModel(
      title: 'Record',
      page: const RecordPage(),
      item: const BottomNavigationBarItem(
        icon: Icon(Icons.dangerous),
        label: 'record',
      ),
    ),
    NavigationBarItemModel(
      title: 'Settings',
      page: const SettingsPage(),
      item: const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'settings',
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: _navBarItems.map((e) => e.page).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: _navBarItems.map((e) => e.item).toList(),
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
      controller.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
      title = _navBarItems[index].title;
    });
  }
}
