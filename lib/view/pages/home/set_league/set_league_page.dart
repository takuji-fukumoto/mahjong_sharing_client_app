import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:getwidget/components/checkbox_list_tile/gf_checkbox_list_tile.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:mahjong_sharing_app/model/league_model.dart';
import 'package:mahjong_sharing_app/view_model/collection_results_view_model.dart';
import 'package:mahjong_sharing_app/view_model/league_view_model.dart';

import '../../../../constants.dart';

class SetLeaguePage extends StatelessWidget {
  const SetLeaguePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor.mainTheme,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text('リーグ設定'),
        elevation: 0,
      ),
      body: _pageBody(),
    );
  }

  Widget _pageBody() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: const <Widget>[
          Expanded(child: _LeagueList()),
        ],
      ),
    );
  }
}

class _LeagueList extends ConsumerWidget {
  const _LeagueList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(leagueProvider);
    final collectionProvider = ref.watch(collectionResultsProvider);

    return FirestoreListView<LeagueModel>(
      query: provider.registeredLeagueQuery(),
      itemBuilder: (context, snapshot) {
        var league = snapshot.data();

        return Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black38),
            borderRadius: BorderRadius.circular(10),
          ),
          child: GFCheckboxListTile(
            title: SizedBox(height: 30, child: Text(league.name)),
            subTitle: _LeaguePeriod(league: league),
            size: 25,
            activeBgColor: Colors.green,
            type: GFCheckboxType.circle,
            activeIcon: const Icon(
              Icons.check,
              size: 15,
              color: Colors.white,
            ),
            onChanged: (value) {
              collectionProvider.changeLeague(league);
            },
            value: collectionProvider.targetLeague != null &&
                collectionProvider.targetLeague!.docId == league.docId,
            inactiveIcon: null,
          ),
        );
      },
    );
  }
}

class _LeaguePeriod extends StatelessWidget {
  final LeagueModel league;
  const _LeaguePeriod({Key? key, required this.league}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (league.startAt.isEmpty && league.endAt.isEmpty) {
      return Container();
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 5.0),
        child: Text('${league.startAt} ~ ${league.endAt}'),
      );
    }
  }
}

void jumpToCreateLeaguePage(BuildContext context) {
  Navigator.of(context).pushNamed(RouteName.createLeague);
}
