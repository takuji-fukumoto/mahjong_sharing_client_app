import 'package:flutter/material.dart';
import 'package:mahjong_sharing_app/view/pages/home/home_page.dart';
import 'package:mahjong_sharing_app/view/pages/home/input_score/input_score_page.dart';
import 'package:mahjong_sharing_app/view/pages/home/set_league/set_league_page.dart';
import 'package:mahjong_sharing_app/view/pages/home/set_players/set_players_page.dart';
import 'package:mahjong_sharing_app/view/pages/root_page.dart';
import 'package:mahjong_sharing_app/view/pages/settings/edit_roles/edit_roles_page.dart';
import 'package:mahjong_sharing_app/view/pages/settings/manage_league/create_league/create_league_page.dart';
import 'package:mahjong_sharing_app/view/pages/settings/manage_league/edit_league/edit_league_page.dart';
import 'package:mahjong_sharing_app/view/pages/settings/manage_league/manage_league_page.dart';
import 'package:mahjong_sharing_app/view/pages/settings/manage_users/create_user/create_user_page.dart';
import 'package:mahjong_sharing_app/view/pages/settings/manage_users/edit_user/edit_user_page.dart';
import 'package:mahjong_sharing_app/view/pages/settings/manage_users/manage_users_page.dart';

import '../constants.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(164, 210, 44, 1),
        primarySwatch: Colors.lightGreen,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.green[400]),
      ),
      initialRoute: RouteName.home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteName.home:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.home),
              builder: (context) => const HomePage(),
            );

          // 集計ページ****************************************

          case RouteName.setPlayers:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.setPlayers),
              builder: (context) => const SetPlayersPage(),
            );
          case RouteName.setLeague:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.setLeague),
              builder: (context) => const SetLeaguePage(),
            );
          case RouteName.inputScore:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.inputScore),
              builder: (context) => InputScorePage(
                  arguments: settings.arguments as Map<dynamic, dynamic>),
            );

          // 設定ページ****************************************

          // ユーザー管理
          case RouteName.manageUsers:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.manageUsers),
              builder: (context) => const ManageUsersPage(),
            );
          case RouteName.createUser:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.createUser),
              builder: (context) => const CreateUserPage(),
            );
          case RouteName.editUser:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.editLeague),
              builder: (context) => EditUserPage(
                  arguments: settings.arguments as Map<dynamic, dynamic>),
            );

          // リーグ管理
          case RouteName.manageLeagues:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.manageLeagues),
              builder: (context) => const ManageLeaguePage(),
            );
          case RouteName.createLeague:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.createLeague),
              builder: (context) => const CreateLeaguePage(),
            );
          case RouteName.editLeague:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.editLeague),
              builder: (context) => EditLeaguePage(
                  arguments: settings.arguments as Map<dynamic, dynamic>),
            );

          // ルール設定
          case RouteName.editRoles:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.editRoles),
              builder: (context) => const EditRolesPage(),
            );

          default:
            print('unknown route');
            break;
        }
      },
      home: const RootPage(),
    );
  }
}
