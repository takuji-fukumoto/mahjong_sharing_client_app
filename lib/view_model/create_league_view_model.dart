// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

final createLeagueProvider =
    ChangeNotifierProvider((ref) => CreateLeagueViewModel());

class CreateLeagueViewModel extends ChangeNotifier {
  final form = FormGroup({
    'name': FormControl<String>(
      value: '',
      validators: [Validators.required, Validators.maxLength(10)],
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

  Future<bool> createLeagueToRemote() async {
    try {
      // リーグ登録
      DateTime now = DateTime.now();
      DateFormat createdAtFormat = DateFormat('yyyy-MM-dd-Hm');
      DateFormat periodFormat = DateFormat('yyyy-MM-dd');
      String createdAt = createdAtFormat.format(now);
      String startAt = '';
      String endAt = '';

      if (form.control('start_at').value != null) {
        startAt = periodFormat.format(form.control('start_at').value);
      }
      if (form.control('end_at').value != null) {
        endAt = periodFormat.format(form.control('end_at').value);
      }

      var store = FirebaseFirestore.instance;
      await store.collection('leagues').doc().set({
        'name': form.control('name').value,
        'created_at': createdAt,
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
}
