import 'package:flutter/material.dart';

import '../../../constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('ユーザー管理'),
          onTap: () {
            Navigator.of(context).pushNamed(RouteName.manageUsers);
          },
        ),
        ListTile(
          leading: Icon(Icons.apartment),
          title: Text('大会管理'),
          onTap: () {
            print('tap 大会管理');
          },
        ),
        ListTile(
          leading: Icon(Icons.addchart_sharp),
          title: Text('ウマオカ設定'),
          onTap: () {
            print('tap 馬丘設定');
          },
        ),
      ],
    );
  }
}
