// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';

final createUserProvider =
    ChangeNotifierProvider((ref) => CreateUserViewModel());

class CreateUserViewModel extends ChangeNotifier {
  final form = FormGroup({
    'name': FormControl<String>(
      value: '',
      validators: [Validators.required, Validators.maxLength(10)],
    ),
  });
  File? image;

  void resetForm() {
    form.control('name').value = '';
    image = null;
  }

  void changeIconImage(String path) {
    image = File(path);
    notifyListeners();
  }

  Future<bool> createUserToRemote() async {
    var avatarPath =
        image != null ? 'users/avatar/${form.control('name').value}.png' : '';
    try {
      // アバターアップロード
      if (avatarPath.isNotEmpty) {
        var storage = FirebaseStorage.instance;

        await storage.ref(avatarPath).putFile(image!);
      }

      // ユーザー登録
      DateTime now = DateTime.now();
      DateFormat outputFormat = DateFormat('yyyy-MM-dd-Hm');
      String date = outputFormat.format(now);

      var store = FirebaseFirestore.instance;
      await store.collection('users').doc().set({
        'name': form.control('name').value,
        'avatar': avatarPath,
        'created_at': date,
      });
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }
}
