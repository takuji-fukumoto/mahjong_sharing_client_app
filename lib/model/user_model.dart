import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserModel {
  late String docId;
  late String name;
  late String createdAt;
  late String avatarPath;
  String avatarDownloadPath = '';

  UserModel({
    required this.docId,
    required this.name,
    required this.createdAt,
    this.avatarPath = '',
  });

  UserModel.fromJson(String docId, Map<String, Object?> json)
      : this(
          docId: docId,
          name: json['name']! as String,
          createdAt: json['created_at']! as String,
          avatarPath: json['avatar']! as String? ?? '',
        );

  Map<String, dynamic> toJson() {
    return {
      'doc_id': docId,
      'name': name,
      'created_at': createdAt,
      'avatar': avatarPath,
    };
  }

  Future<String> downloadAvatarPath() async {
    if (avatarPath.isEmpty) {
      return '';
    } else if (avatarDownloadPath.isNotEmpty) {
      return avatarDownloadPath;
    }
    try {
      var storage = FirebaseStorage.instance;
      var path = await storage.ref(avatarPath).getDownloadURL();

      avatarDownloadPath = path;
      return path.toString();
    } on FirebaseException catch (e) {
      print('firebase error: $e');
      return '';
    } on Exception catch (e) {
      print('download error: $e');
      return '';
    }
  }
}
