class UserModel {
  String name;
  String? iconPath; // TODO: ここでデフォルトのアイコンパス入れちゃった方がいいかも

  UserModel({
    required this.name,
    this.iconPath,
  });
}
