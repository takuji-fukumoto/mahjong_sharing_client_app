// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

final editUserProvider = ChangeNotifierProvider((ref) => EditUserViewModel());

class EditUserViewModel extends ChangeNotifier {
  final form = FormGroup({
    'name': FormControl<String>(
      value: '',
    ),
  });
  File? image;

  void setForm(UserModel user) {
    form.updateValue({
      'name': user.name,
    });
  }

  Future<bool> deleteUser(UserModel user) async {
    try {
      // アバター削除
      if (user.avatarPath.isNotEmpty) {
        var storage = FirebaseStorage.instance;
        await storage.ref(user.avatarPath).delete();
      }

      var store = FirebaseFirestore.instance;
      await store.collection('users').doc(user.docId).delete();
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }
}
