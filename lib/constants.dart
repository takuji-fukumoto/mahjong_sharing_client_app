import 'dart:ui';

class ThemeColor {
  static const mainTheme = Color.fromRGBO(79, 179, 71, 0.8862745098039215);
}

class RouteName {
  // ホーム*************************************
  static const home = '/';
  static const setPlayers = '/players/set';
  static const setLeague = '/league/set';

  static const inputScore = '/score/input';

  // 履歴**************************************
  static const history = '/history';

  // 戦績**************************************
  static const record = '/record';

  // 設定**************************************
  static const settings = '/settings';

  static const manageUsers = '/settings/users';
  static const createUser = '/settings/user/create';
  static const editUser = '/settings/user/edit';

  static const manageLeagues = '/settings/leagues';
  static const createLeague = '/settings/league/create';
  static const editLeague = '/settings/league/edit';

  static const editRoles = '/settings/roles/edit';
}

class LocalStorageKey {
  static const bonusByRanking = 'bonus_by_ranking';
  static const originPoints = 'origin_points';
  static const topPrize = 'top_prize';
}

class DefaultSetting {
  static const bonusByRanking = '';
  static const originPoints = '25000';
  static const topPrize = '25000';
}
