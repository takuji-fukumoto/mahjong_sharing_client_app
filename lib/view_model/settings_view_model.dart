// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_sharing_app/repository/settings_repository.dart';

final settingsProvider = ChangeNotifierProvider((ref) => SettingsViewModel());

class SettingsViewModel extends ChangeNotifier {
  final _repository = SettingsRepository();

  // ウマ*************************************************************
  String get bonusByRanking {
    return _repository.bonusByRanking;
  }

  set bonusByRanking(String value) {
    _repository.bonusByRanking = value;
    notifyListeners();
  }

  // 配給原点*************************************************************
  int get originPoints {
    return _repository.originPoints;
  }

  set originPoints(int value) {
    _repository.originPoints = value;
    notifyListeners();
  }

  // オカ*************************************************************
  int get topPrize {
    return _repository.topPrize;
  }

  set topPrize(int value) {
    _repository.topPrize = value;
    notifyListeners();
  }
}
