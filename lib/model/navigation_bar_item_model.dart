import 'package:flutter/cupertino.dart';

class NavigationBarItemModel {
  String title;
  Widget page;
  BottomNavigationBarItem item;

  NavigationBarItemModel({
    required this.title,
    required this.page,
    required this.item,
  });
}
