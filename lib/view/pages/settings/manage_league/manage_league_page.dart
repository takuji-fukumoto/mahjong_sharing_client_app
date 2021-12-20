import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:mahjong_sharing_app/model/league_model.dart';
import 'package:mahjong_sharing_app/view_model/league_view_model.dart';

import '../../../../constants.dart';

class ManageLeaguePage extends StatelessWidget {
  const ManageLeaguePage({Key? key}) : super(key: key);

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
        title: const Text('リーグ管理'),
        elevation: 0,
      ),
      body: _pageBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => jumpToCreateLeaguePage(context),
        child: const Icon(Icons.add),
      ),
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
          child: ListTile(
            title: Text(league.name),
            subtitle: _LeaguePeriod(league: league),
            trailing: SizedBox(
              width: 80,
              child: Text(
                league.description,
                style: const TextStyle(
                  color: Colors.black54,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(RouteName.editLeague,
                  arguments: {'league': league});
            },
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
