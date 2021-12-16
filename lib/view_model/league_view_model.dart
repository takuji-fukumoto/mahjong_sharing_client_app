import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_sharing_app/model/league_model.dart';

final leagueProvider = ChangeNotifierProvider((ref) => LeagueViewModel());

class LeagueViewModel extends ChangeNotifier {
  Query<LeagueModel> registeredLeagueQuery() {
    return FirebaseFirestore.instance
        .collection('leagues')
        .orderBy('created_at', descending: true)
        .withConverter<LeagueModel>(
          fromFirestore: (snapshot, _) {
            return LeagueModel.fromJson(snapshot.data()!);
          },
          toFirestore: (league, _) => league.toJson(),
        );
  }
}
