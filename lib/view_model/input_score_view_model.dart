import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_sharing_app/model/player_round_score.dart';
import 'package:mahjong_sharing_app/model/round_score.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

final inputScoreProvider =
    ChangeNotifierProvider((ref) => InputScoreViewModel());

class InputScoreViewModel extends ChangeNotifier {
  // 集計対象ユーザー
  List<UserModel> inputTargetPlayers = [];

  final form = FormGroup({
    'player1_score': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
    'player2_score': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
    'player3_score': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
    'player4_score': FormControl<int>(
      value: null,
      validators: [Validators.required],
    ),
  });

  void checkTargetPlayer(List<UserModel> players) {
    // 集計対象のユーザーが参加者に入っていなかったら排除する
    var deleteUsers = [];
    for (var target in inputTargetPlayers) {
      if (players.where((element) => element.docId == target.docId).isEmpty) {
        deleteUsers.add(target);
      }
    }
    for (var deleteTarget in deleteUsers) {
      removeTargetPlayer(deleteTarget);
    }
  }

  void addTargetPlayer(UserModel user) {
    if (inputTargetPlayers.length < 4) {
      inputTargetPlayers.add(user);
      notifyListeners();
    }
  }

  void removeTargetPlayer(UserModel user) {
    inputTargetPlayers.remove(user);
    notifyListeners();
  }

  void choicePlayer(UserModel user) {
    if (isSelectedUser(user)) {
      removeTargetPlayer(user);
    } else {
      addTargetPlayer(user);
    }
  }

  String targetPlayerName(int playerNumber) {
    return inputTargetPlayers.length >= playerNumber
        ? inputTargetPlayers[playerNumber - 1].name
        : 'プレイヤー$playerNumber';
  }

  bool isSelectedUser(UserModel user) {
    return inputTargetPlayers
        .where((element) => element.docId == user.docId)
        .isNotEmpty;
  }

  int playerScore(UserModel user) {
    var index =
        inputTargetPlayers.indexWhere((element) => element.docId == user.docId);
    // 該当なしの場合-1
    if (index == -1) {
      return -1;
    }
    return form.control('player${index + 1}_score').value as int;
  }

  int playerRank(UserModel user) {
    var index =
        inputTargetPlayers.indexWhere((element) => element.docId == user.docId);
    // 該当なしの場合-1
    if (index == -1) {
      return -1;
    }
    var targetScore = form.control('player${index + 1}_score').value as int;
    var scores = [];
    for (int i = 1; i <= 4; i++) {
      scores.add(form.control('player${i}_score').value as int);
    }
    // TODO: 同点の場合席順を考慮する（変数追加するか）
    scores.sort((a, b) => b.compareTo(a));
    return scores.indexWhere((element) => element == targetScore) + 1;
  }

  bool validateInput() {
    // 集計対象が4名揃っているか
    if (inputTargetPlayers.length != 4) {
      return false;
    }

    var totalScore = 0;
    for (int i = 1; i <= 4; i++) {
      totalScore += form.control('player${i}_score').value as int;
    }

    // スコアの合計が合うか
    // FIXME: settingの配給原点 * 4で算出する
    if (totalScore != 100000) {
      return false;
    }

    return true;
  }

  RoundScoreModel collectInput() {
    List<PlayerRoundScoreModel> results = [];
    for (var player in inputTargetPlayers) {
      results.add(PlayerRoundScoreModel(
          user: player, rank: playerRank(player), score: playerScore(player)));
    }

    return RoundScoreModel(playerScores: results);
  }
}
