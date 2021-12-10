import 'package:flutter/material.dart';
import 'package:mahjong_sharing_app/view/pages/home/home_page.dart';
import 'package:mahjong_sharing_app/view/pages/root_page.dart';
import 'package:mahjong_sharing_app/view/pages/settings/manage_users/create_user/create_user_page.dart';
import 'package:mahjong_sharing_app/view/pages/settings/manage_users/manage_users_page.dart';

import '../constants.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      theme: ThemeData(
          // textTheme: GoogleFonts.montserratTextTheme(textTheme).copyWith(
          //   headline1: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontSize: 18,
          //         fontWeight: FontWeight.w700,
          //         color: Colors.white,
          //         letterSpacing: 0.15,
          //       )),
          //   headline2: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.w400,
          //         color: Colors.white,
          //         letterSpacing: 0.15,
          //       )),
          //   headline3: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontSize: 14,
          //         fontWeight: FontWeight.w700,
          //         color: Colors.white,
          //         letterSpacing: 0.15,
          //       )),
          //   headline4: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontSize: 12,
          //         fontWeight: FontWeight.w700,
          //         color: Colors.white,
          //         letterSpacing: 0.15,
          //       )),
          //   headline5: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontSize: 13,
          //         fontWeight: FontWeight.w500,
          //         color: Colors.white,
          //         letterSpacing: 0.15,
          //       )),
          //   headline6: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontWeight: FontWeight.w200,
          //         letterSpacing: 0.15,
          //       )),
          //   subtitle1: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontSize: 12,
          //         fontWeight: FontWeight.w400,
          //         color: Colors.white,
          //         letterSpacing: 0.15,
          //       )),
          //   subtitle2: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontWeight: FontWeight.w200,
          //         letterSpacing: 0.15,
          //       )),
          //   bodyText1: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontSize: 12.0,
          //         fontWeight: FontWeight.w400,
          //         color: Colors.white,
          //         letterSpacing: 0.15,
          //       )),
          //   bodyText2: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontSize: 10,
          //         fontWeight: FontWeight.w400,
          //         color: Colors.white,
          //         letterSpacing: 0.15,
          //       )),
          //
          //   caption: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontWeight: FontWeight.w200,
          //         letterSpacing: 0.15,
          //       )),
          //   overline: GoogleFonts.montserrat(
          //       textStyle: const TextStyle(
          //         fontWeight: FontWeight.w200,
          //         letterSpacing: 0.15,
          //       )),
          // ),
          ),
      initialRoute: RouteName.home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case RouteName.home:
            return MaterialPageRoute(
              settings: const RouteSettings(name: RouteName.home),
              builder: (context) => const HomePage(),
            );

          // 設定ページ****************************************
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

          default:
            print('unknown route');
            break;
        }
      },
      home: const RootPage(),
    );
  }
}
