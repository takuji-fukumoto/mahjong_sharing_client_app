import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahjong_sharing_app/model/league_model.dart';
import 'package:mahjong_sharing_app/model/round_score.dart';

class ResultModel {
  late LeagueModel? league;
  late Timestamp startAt;
  late List<RoundScoreModel> scores;

  ResultModel({
    this.league,
    required this.startAt,
    required this.scores,
  });

  Map<String, int> totalPlayerScore() {
    Map<String, int> playerScores = {};
    // スコア集計
    for (var score in scores) {
      for (var playerScore in score.playerScores) {
        playerScores[playerScore.user.name] =
            (playerScores[playerScore.user.name] ?? 0) + playerScore.score;
      }
    }

    return playerScores;
  }
}
