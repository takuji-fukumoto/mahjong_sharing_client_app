import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:mahjong_sharing_app/model/player_colmun_model.dart';
import 'package:mahjong_sharing_app/model/round_score.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';

final collectionResultsProvider =
    ChangeNotifierProvider((ref) => CollectionResultsViewModel());

class CollectionResultsViewModel extends ChangeNotifier {
  final double leftSideColumnWidth = 70.0;
  final double rightSideColumnWidth = 80.0;
  final double tableItemHeight = 50.0;

  final tableController = HDTRefreshController();

  List<PlayerColumnModel> playerHeader = [];

  // 参加ユーザー
  List<UserModel> players = [];

  // 各対局結果
  List<RoundScoreModel> results = [];

  // ユーザー追加・解除
  void changePlayerStatus(UserModel user, bool isAdd) {
    if (isAdd) {
      players.add(user);
      addPlayerColumn(user);
    } else if (!isAlreadyCorrected(user)) {
      // 既に集計済みのプレイヤーだったら消さないようにする
      players.removeWhere((element) => element.docId == user.docId);
      removePlayerColumn(user);
    }
    notifyListeners();
  }

  bool isAlreadyCorrected(UserModel user) {
    for (var result in results) {
      for (var playerScore in result.playerScores) {
        if (playerScore.user.docId == user.docId) {
          return true;
        }
      }
    }
    return false;
  }

  void addPlayerColumn(UserModel user) {
    playerHeader.add(
        PlayerColumnModel(user: user, header: _rightHeaderItem(user.name)));
    notifyListeners();
  }

  void removePlayerColumn(UserModel user) {
    playerHeader.removeWhere((element) => element.user.docId == user.docId);
    notifyListeners();
  }

  // 集計結果追加
  void addRoundResults(RoundScoreModel roundScore) {
    results.add(roundScore);
    notifyListeners();
  }

  Widget _rightHeaderItem(String label) {
    return Container(
      padding: const EdgeInsets.all(1),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
      ),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.black12,
            width: 0.5,
          ),
        ),
      ),
      width: rightSideColumnWidth,
      height: tableItemHeight,
    );
  }
}
