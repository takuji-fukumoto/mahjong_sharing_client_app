import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserModel {
  late String name;
  late String createdAt;
  late String avatarPath;

  UserModel({
    required this.name,
    required this.createdAt,
    this.avatarPath = '',
  });

  UserModel.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          createdAt: json['created_at']! as String,
          avatarPath: json['avatar']! as String? ?? '',
        );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'created_at': createdAt,
      'avatar': avatarPath,
    };
  }

  Future<String> downloadAvatarPath() async {
    try {
      if (avatarPath.isEmpty) {
        return '';
      }
      var storage = FirebaseStorage.instance;
      var path = await storage.ref(avatarPath).getDownloadURL();

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
