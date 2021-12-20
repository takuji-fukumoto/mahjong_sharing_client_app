import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizontal_data_table/refresh/hdt_refresh_controller.dart';
import 'package:mahjong_sharing_app/model/result_model.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';

final collectionResultsProvider =
    ChangeNotifierProvider((ref) => CollectionResultsViewModel());

class CollectionResultsViewModel extends ChangeNotifier {
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
    players[user.name] = isAdd;
    if (isAdd) {
      addPlayerColumn(user);
    } else {
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
    return SizedBox(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      width: 50,
      height: 30,
    );
  }

  Widget _rightHeaderItem(String label) {
    return SizedBox(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      width: 60,
      height: 30,
    );
  }

// 集計結果追加

}
