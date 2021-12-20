import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:mahjong_sharing_app/model/result_model.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';

final collectionResultsProvider =
    ChangeNotifierProvider((ref) => CollectionResultsViewModel());

class CollectionResultsViewModel extends ChangeNotifier {
  static const double leftSideColumnWidth = 70.0;
  static const double rightSideColumnWidth = 80.0;
  static const double tableItemHeight = 50.0;

  final tableController = HDTRefreshController();

  List<Widget> header = [
    _leftHeaderItem('Round'),
  ];
  Map<String, int> playerColumnIndex = {}; // プレイヤー名 -> カラムのindex

  // 参加ユーザー
  Map<String, bool> players = {};

  // リザルト（リスト）
  List<ResultModel> results = [];

  // ユーザー追加・解除
  void changePlayerStatus(UserModel user, bool isAdd) {
    if (isAdd) {
      players[user.name] = isAdd;
      addPlayerColumn(user);
    } else {
      players.remove(user.name);
      removePlayerColumn(user);
    }
    notifyListeners();
  }

  void addPlayerColumn(UserModel user) {
    header.add(_rightHeaderItem(user.name));
    playerColumnIndex[user.name] = header.length - 1;
    notifyListeners();
  }

  void removePlayerColumn(UserModel user) {
    header.removeAt(playerColumnIndex[user.name]!);
    notifyListeners();
  }

  static Widget _leftHeaderItem(String label) {
    return Container(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
      width: leftSideColumnWidth,
      height: tableItemHeight,
    );
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

// 集計結果追加

}
