import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';

final manageUserProvider =
    ChangeNotifierProvider((ref) => ManageUserViewModel());

class ManageUserViewModel extends ChangeNotifier {
  Query<UserModel> registeredUsersQuery() {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('created_at', descending: true)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) {
            return UserModel.fromJson(snapshot.data()!);
          },
          toFirestore: (user, _) => user.toJson(),
        );
  }

  Stream<UserModel> registerListStream(
      {required DocumentReference<UserModel> ref}) {
    return ref.snapshots().map(
          (snapshot) => snapshot.data()!,
        );
  }
}
