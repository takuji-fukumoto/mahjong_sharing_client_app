import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:mahjong_sharing_app/constants.dart';
import 'package:mahjong_sharing_app/view/pages/home/result_table.dart';
import 'package:mahjong_sharing_app/view/pages/home/total_score_table.dart';
import 'package:mahjong_sharing_app/view_model/collection_results_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  var _controllers = LinkedScrollControllerGroup();
  var _dataTableController = ScrollController();
  var _totalTableController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _dataTableController = _controllers.addAndGet();
    _totalTableController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _dataTableController.dispose();
    _totalTableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        _pageBody(),
        const Positioned(
          left: 15,
          top: 15,
          child: _Description(),
        ),
        Positioned(
          bottom: 80,
          child: TotalScoreTable(controller: _totalTableController),
        ),
        Positioned(
          left: 15,
          bottom: 15,
          child: _settingButtons(),
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
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 130),
      child: ResultTable(controller: _dataTableController),
    );
  }

  Widget _settingButtons() {
    return Row(
      children: [
        _setPlayerButton(),
        _setLeagueButton(),
      ],
    );
  }

  Widget _setPlayerButton() {
    return Container(
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ThemeColor.mainTheme.withOpacity(0.7),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteName.setPlayers);
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

  Widget _setLeagueButton() {
    return Container(
      margin: const EdgeInsets.only(right: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ThemeColor.mainTheme.withOpacity(0.7),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteName.setLeague);
        },
        child: const Text(
          'リーグ設定',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _Description extends ConsumerWidget {
  const _Description({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(collectionResultsProvider);
    final dateFormat = DateFormat('yyyy-MM-dd');

    return Text(
      '${provider.startAt != null ? dateFormat.format(provider.startAt!.toDate()) : ''}  '
      '${provider.targetLeague != null ? provider.targetLeague!.name : ''}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
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
