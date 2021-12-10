import 'package:flutter/material.dart';

import '../../../../constants.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text('ユーザー管理'),
      ),
      body: Center(child: Text('manage users')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => jumpToCreateUserPage(context),
        child: Icon(Icons.add),
      ),
    );
  }
}

void jumpToCreateUserPage(BuildContext context) {
  Navigator.of(context).pushNamed(RouteName.createUser);
}
