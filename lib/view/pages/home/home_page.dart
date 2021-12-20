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
        Positioned(
          right: 15,
          bottom: 15,
          child: _addResultsButton(context),
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
        // border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(10),
        color: ThemeColor.mainTheme.withOpacity(0.7),
      ),
      child: TextButton(
        onPressed: () {
          print('add user');
          Navigator.of(context).pushNamed(RouteName.addPlayers);
          // TODO: 参加者設定ページに遷移する
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

  Widget _addResultsButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ThemeColor.mainTheme.withOpacity(0.7),
      ),
      child: IconButton(
        color: Colors.white,
        onPressed: () {
          print('add');
          // TODO: 集計ページに遷移する
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
      leftHandSideColumnWidth: CollectionResultsViewModel.leftSideColumnWidth,
      rightHandSideColumnWidth: (provider.header.length - 1) *
          CollectionResultsViewModel.leftSideColumnWidth,
      headerWidgets: provider.header,
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

  Widget _leftSideItemBuilder(BuildContext context, int index) {
    return Text('aaa');
  }

  Widget _rightSideItemBuilder(BuildContext context, int index) {
    return Text('bbb');
  }
}
