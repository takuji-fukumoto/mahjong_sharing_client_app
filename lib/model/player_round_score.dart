import 'package:mahjong_sharing_app/model/user_model.dart';

class PlayerRoundScoreModel {
  late UserModel user;
  late int score;
  int rank;

  PlayerRoundScoreModel({
    required this.user,
    required this.score,
    this.rank = 0,
  });
}
