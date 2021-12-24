import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mahjong_sharing_app/model/setting_model.dart';

import '../constants.dart';

class SettingsRepository {
  static final SettingsRepository _instance = SettingsRepository._internal();

  factory SettingsRepository() => _instance;
  SettingsRepository._internal();

  final _storage = const FlutterSecureStorage();
  SettingModel? _settings;

  SettingModel get currentSettings => _settings!;

  // must call in main.dart
  Future initializeSettings() async {
    var bonusByRanking =
        await _storage.read(key: LocalStorageKey.bonusByRanking) ??
            DefaultSetting.bonusByRanking;
    var originPoints = await _storage.read(key: LocalStorageKey.originPoints) ??
        DefaultSetting.originPoints;
    var topPrize = await _storage.read(key: LocalStorageKey.topPrize) ??
        DefaultSetting.topPrize;

    _settings = SettingModel(
      bonusByRanking: bonusByRanking,
      originPoints: int.parse(originPoints),
      topPrize: int.parse(topPrize),
    );
  }

  Future _saveLocalStorage(Map<String, String> keyValues) async {
    keyValues.forEach((key, value) async {
      await _storage.write(key: key, value: value);
    });
  }

  // ウマ************************************************
  String get bonusByRanking => _settings!.bonusByRanking;

  set bonusByRanking(String value) {
    _settings!.bonusByRanking = value;
    _saveLocalStorage({LocalStorageKey.bonusByRanking: value});
  }

  // 配給原点*********************************************
  int get originPoints => _settings!.originPoints;

  set originPoints(int value) {
    _settings!.originPoints = value;
    _saveLocalStorage({LocalStorageKey.originPoints: value.toString()});
  }

  // オカ************************************************
  int get topPrize => _settings!.topPrize;

  set topPrize(int value) {
    _settings!.topPrize = value;
    _saveLocalStorage({LocalStorageKey.topPrize: value.toString()});
  }
}
