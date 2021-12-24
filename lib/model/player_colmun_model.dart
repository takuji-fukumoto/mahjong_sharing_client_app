import 'package:flutter/cupertino.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';

class PlayerColumnModel {
  late UserModel user;
  late Widget header;

  PlayerColumnModel({
    required this.user,
    required this.header,
  });
}
