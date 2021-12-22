import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:mahjong_sharing_app/constants.dart';
import 'package:mahjong_sharing_app/view_model/collection_results_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        _pageBody(),
        // TODO: リーグ選択ボックス追加
        Positioned(
          left: 15,
          bottom: 15,
          child: _addUserButton(context),
        ),
        const Positioned(
          right: 15,
          bottom: 15,
          child: _AddResultsButton(),
        ),
      ],
    );
  }

  Widget _pageBody() {
    return const Padding(
      padding: EdgeInsets.only(top: 15, bottom: 50),
      child: _ResultTable(),
    );
  }

  Widget _addUserButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ThemeColor.mainTheme.withOpacity(0.7),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteName.addPlayers);
        },
        child: const Text(
          '参加者設定',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _AddResultsButton extends ConsumerWidget {
  const _AddResultsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(collectionResultsProvider);
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ThemeColor.mainTheme.withOpacity(0.7),
      ),
      child: IconButton(
        color: Colors.white,
        onPressed: () {
          if (provider.players.length < 4) {
            // TODO: アラートダイアログ出す
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text("集計"),
                  content: const Text("参加プレイヤーを4人以上選択して下さい"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            );
          } else {
            Navigator.of(context).pushNamed(RouteName.inputScore,
                arguments: {'players': provider.players});
          }
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _ResultTable extends ConsumerWidget {
  const _ResultTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(collectionResultsProvider);

    return HorizontalDataTable(
      leftHandSideColumnWidth: provider.leftSideColumnWidth,
      rightHandSideColumnWidth:
          (provider.playerHeader.length) * provider.rightSideColumnWidth,
      headerWidgets: [
        _leftHeaderItem(
            'Round', provider.leftSideColumnWidth, provider.tableItemHeight),
        for (var header in provider.playerHeader) header.header,
      ],
      isFixedHeader: true,
      itemCount: provider.results.length, // TODO: データの数に変更する
      rowSeparatorWidget: const Divider(
        color: Colors.black54,
        height: 1.0,
        thickness: 0.0,
      ),
      htdRefreshController: provider.tableController,
      leftSideItemBuilder: _leftSideItemBuilder,
      rightSideItemBuilder: _rightSideItemBuilder,
      enablePullToRefresh: true,
      refreshIndicator: const WaterDropHeader(),
      refreshIndicatorHeight: 60,
      onRefresh: () async {
        //Do sth
        await Future.delayed(const Duration(milliseconds: 500));
        provider.tableController.refreshCompleted();
      },
    );
  }

  Widget _leftHeaderItem(String label, double width, double height) {
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
            color: Colors.black38,
            width: 0.8,
          ),
        ),
      ),
      width: width,
      height: height,
    );
  }

  Widget _leftSideItemBuilder(BuildContext context, int index) {
    return LeftSideItem(index: index);
  }

  Widget _rightSideItemBuilder(BuildContext context, int index) {
    return RightSideItem(index: index);
  }
}

class LeftSideItem extends ConsumerWidget {
  final int index;
  const LeftSideItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(collectionResultsProvider);

    return Container(
      child: Center(
        child: Text(
          '${index + 1}'.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.black38,
            width: 0.8,
          ),
        ),
      ),
      width: provider.leftSideColumnWidth,
      height: provider.tableItemHeight,
    );
  }
}

class RightSideItem extends ConsumerWidget {
  final int index;
  const RightSideItem({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(collectionResultsProvider);

    return Row(
      children: [
        for (int i = 0; i < provider.players.length; i++)
          if (provider.results[index].playerScores
              .where(
                  (element) => element.user.docId == provider.players[i].docId)
              .isNotEmpty)
            Container(
              child: Center(
                child: Text(
                  provider.results[index].playerScores
                      .firstWhere((element) =>
                          element.user.docId == provider.players[i].docId)
                      .score
                      .toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.black12,
                    width: 0.8,
                  ),
                ),
              ),
              width: provider.rightSideColumnWidth,
              height: provider.tableItemHeight,
            )
          else
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.black12,
                    width: 0.8,
                  ),
                  bottom: BorderSide(
                    color: Colors.black12,
                    width: 0.8,
                  ),
                ),
              ),
              width: provider.rightSideColumnWidth,
              height: provider.tableItemHeight,
            ),
      ],
    );
  }
}
