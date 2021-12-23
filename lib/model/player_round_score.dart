import 'package:mahjong_sharing_app/model/user_model.dart';
import 'package:mahjong_sharing_app/repository/settings_repository.dart';

class PlayerRoundScoreModel {
  late UserModel user;
  late int score;
  late int rank;

  PlayerRoundScoreModel({
    required this.user,
    required this.score,
    required this.rank,
  });

  int get formattedTotalScore {
    var formattedScore = 0;
    // 5捨6入
    var fraction = int.parse(score.toString()[2]);
    var rounding = (fraction >= 6 && fraction <= 9) ? 1 : 0;
    formattedScore = (score ~/ 1000) + rounding;

    var settings = SettingsRepository().currentSettings;
    var bonusPointsList = settings.bonusPointsEachRanks();

    // ウマ
    formattedScore = formattedScore + bonusPointsList[rank - 1];

    // オカ
    if (rank == 1) {
      var topPrizePoints = (settings.topPrize - settings.originPoints) ~/ 1000;
      formattedScore = formattedScore + (topPrizePoints * 4);
    }
    formattedScore = formattedScore - (settings.topPrize ~/ 1000);
    return formattedScore;
  }
}
