import 'dart:ui';

class ThemeColor {
  static const mainTheme = Color.fromRGBO(79, 179, 71, 0.8862745098039215);
}

class RouteName {
  // ホーム*************************************
  static const home = '/';
  static const inputRecord = '/record/input';

  // 履歴**************************************
  static const history = '/history';

  // 戦績**************************************
  static const record = '/record';

  // 設定**************************************
  static const settings = '/settings';
  static const manageUsers = '/settings/user';
  static const createUser = '/settings/user/create';
  static const manageLeague = '/settings/league';
  static const createLeague = '/settings/league/create';
}
