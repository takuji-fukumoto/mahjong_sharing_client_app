// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mahjong_sharing_app/model/setting_model.dart';

import '../constants.dart';

final settingsProvider = ChangeNotifierProvider((ref) => SettingsViewModel());

class SettingsViewModel extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  late SettingModel? _settings;

  Future<SettingModel> currentSettings() async {
    _settings ??= await initializeSettings();

    return _settings!;
  }

  Future initializeSettings() async {
    var bonusByRanking =
        await _storage.read(key: LocalStorageKey.bonusByRanking) ?? '';
    var originPoints =
        await _storage.read(key: LocalStorageKey.originPoints) ?? '25000';
    var topPrize =
        await _storage.read(key: LocalStorageKey.topPrize) ?? '25000';

    _settings = SettingModel(
      bonusByRanking: bonusByRanking,
      originPoints: int.parse(originPoints),
      topPrize: int.parse(topPrize),
    );
  }

  // ウマ*************************************************************
  String get bonusByRanking {
    return _settings!.bonusByRanking;
  }

  Future setBonusByRanking(String bonus) async {
    var settings = await currentSettings();
    settings.bonusByRanking = bonus;
    _storage.write(key: LocalStorageKey.bonusByRanking, value: bonus);
    notifyListeners();
  }

  // 配給原点*************************************************************
  int get originPoints {
    return _settings!.originPoints;
  }

  Future setOriginPoints(int points) async {
    var settings = await currentSettings();
    settings.originPoints = points;
    _storage.write(key: LocalStorageKey.originPoints, value: points.toString());
    notifyListeners();
  }

  // オカ*************************************************************
  int get topPrize {
    return _settings!.topPrize;
  }

  Future setTopPrize(int points) async {
    var settings = await currentSettings();
    settings.topPrize = points;
    _storage.write(key: LocalStorageKey.topPrize, value: points.toString());
    notifyListeners();
  }
}
