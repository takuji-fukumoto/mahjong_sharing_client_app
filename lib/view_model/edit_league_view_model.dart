// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mahjong_sharing_app/model/league_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

final editLeagueProvider =
    ChangeNotifierProvider((ref) => EditLeagueViewModel());

class EditLeagueViewModel extends ChangeNotifier {
  final form = FormGroup({
    'name': FormControl<String>(
      value: '',
    ),
    'start_at': FormControl<DateTime>(
      value: null,
    ),
    'end_at': FormControl<DateTime>(
      value: null,
    ),
    'description': FormControl<String>(
      value: '',
      validators: [Validators.maxLength(100)],
    ),
  });

  void setForm(LeagueModel league) {
    final _dateFormatter = DateFormat("yyyy-MM-dd");
    var startAt = league.startAt.isEmpty
        ? null
        : _dateFormatter.parseStrict(league.startAt);
    var endAt =
        league.endAt.isEmpty ? null : _dateFormatter.parseStrict(league.endAt);

    form.updateValue({
      'name': league.name,
      'start_at': startAt,
      'end_at': endAt,
      'description': league.description,
    });
  }

  Future<bool> updateLeagueToRemote(LeagueModel league) async {
    try {
      DateFormat periodFormat = DateFormat('yyyy-MM-dd');
      String startAt = '';
      String endAt = '';

      if (form.control('start_at').value != null) {
        startAt = periodFormat.format(form.control('start_at').value);
      }
      if (form.control('end_at').value != null) {
        endAt = periodFormat.format(form.control('end_at').value);
      }

      var store = FirebaseFirestore.instance;
      await store.collection('leagues').doc(league.docId).update({
        'start_at': startAt,
        'end_at': endAt,
        'description': form.control('description').value,
      });
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> deleteLeague(LeagueModel league) async {
    try {
      var store = FirebaseFirestore.instance;
      await store.collection('leagues').doc(league.docId).delete();
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }
}
