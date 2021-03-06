import 'package:mahjong_sharing_app/model/player_round_score.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';

class RoundScoreModel {
  late List<PlayerRoundScoreModel> playerScores;

  RoundScoreModel({
    required this.playerScores,
  }) {
    setPlayerRank();
  }

  // 各プレイヤーのランク算出
  // TODO: 事前にウマオカ計算でランク出す必要あるのでこれ必要なさそう
  void setPlayerRank() {
    playerScores.sort((a, b) => b.score.compareTo(a.score));
    for (int i = 0; i < playerScores.length; i++) {
      playerScores[i].rank = i + 1;
    }
  }

  PlayerRoundScoreModel? findUserScore(UserModel user) {
    var target =
        playerScores.where((element) => element.user.docId == user.docId);
    if (target.isNotEmpty) {
      return target.first;
    } else {
      null;
    }
  }
}
