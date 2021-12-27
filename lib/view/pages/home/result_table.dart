import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:mahjong_sharing_app/constants.dart';
import 'package:mahjong_sharing_app/view/helper/methods/score_color.dart';
import 'package:mahjong_sharing_app/view_model/collection_results_view_model.dart';

class ResultTable extends ConsumerWidget {
  final ScrollController controller;

  const ResultTable({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(collectionResultsProvider);

    return HorizontalDataTable(
      horizontalScrollController: controller,
      leftHandSideColumnWidth: provider.leftSideColumnWidth,
      rightHandSideColumnWidth:
          (provider.playerHeader.length) * provider.rightSideColumnWidth,
      headerWidgets: [
        _leftHeaderItem(
            'Round', provider.leftSideColumnWidth, provider.tableItemHeight),
        for (var header in provider.playerHeader) header.header,
      ],
      isFixedHeader: true,
      horizontalScrollbarStyle: const ScrollbarStyle(
        thickness: 0,
      ),
      itemCount: provider.results.length,
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
          (index + 1).toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      decoration: BoxDecoration(
        color: (index + 1).isEven ? ThemeColor.tableZebra : Colors.white,
        border: const Border(
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
        for (var player in provider.players)
          if (provider.results[index].findUserScore(player) != null)
            Container(
              child: Stack(
                children: [
                  if (provider.results[index].findUserScore(player)!.rank == 1)
                    Center(
                      child: Icon(
                        Icons.emoji_events_outlined,
                        color: Colors.lightBlue.withOpacity(0.2),
                        size: 40,
                      ),
                    ),
                  Center(
                    child: Text(
                      provider.results[index]
                          .findUserScore(player)!
                          .formattedTotalScore
                          .toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: scoreColor(provider.results[index]
                            .findUserScore(player)!
                            .formattedTotalScore),
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color:
                    (index + 1).isEven ? ThemeColor.tableZebra : Colors.white,
                border: const Border(
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
              decoration: BoxDecoration(
                color:
                    (index + 1).isEven ? ThemeColor.tableZebra : Colors.white,
                border: const Border(
                  right: BorderSide(
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
