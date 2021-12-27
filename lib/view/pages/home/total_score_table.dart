import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:mahjong_sharing_app/view/helper/methods/score_color.dart';
import 'package:mahjong_sharing_app/view_model/collection_results_view_model.dart';

class TotalScoreTable extends ConsumerWidget {
  final ScrollController controller;

  const TotalScoreTable({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    final provider = ref.watch(collectionResultsProvider);

    return SizedBox(
      height: provider.tableItemHeight,
      width: size.width,
      child: HorizontalDataTable(
        horizontalScrollController: controller,
        leftHandSideColumnWidth: provider.leftSideColumnWidth,
        rightHandSideColumnWidth:
            (provider.playerHeader.length) * provider.rightSideColumnWidth,
        headerWidgets: const [
          _LeftSideTotalItem(),
          _RightSideTotalItem(),
        ],
        isFixedHeader: true,
        itemCount: 0,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftSideItemBuilder: _leftSideItemBuilder,
        rightSideItemBuilder: _rightSideItemBuilder,
      ),
    );
  }

  Widget _leftSideItemBuilder(BuildContext context, int index) {
    return Container();
  }

  Widget _rightSideItemBuilder(BuildContext context, int index) {
    return Container();
  }
}

class _LeftSideTotalItem extends ConsumerWidget {
  const _LeftSideTotalItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(collectionResultsProvider);

    return Container(
      child: const Center(
        child: Text(
          '合計',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.black38,
            width: 1.0,
          ),
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

class _RightSideTotalItem extends ConsumerWidget {
  const _RightSideTotalItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(collectionResultsProvider);

    return Row(
      children: [
        for (var header in provider.playerHeader)
          Container(
            child: Center(
              child: Text(
                provider.totalScore(header.user).toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: scoreColor(provider.totalScore(header.user)),
                ),
              ),
            ),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black38,
                  width: 1.0,
                ),
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
