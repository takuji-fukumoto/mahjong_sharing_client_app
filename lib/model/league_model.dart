class LeagueModel {
  late String name;
  late String createdAt;
  late String startAt;
  late String endAt;

  LeagueModel({
    required this.name,
    required this.createdAt,
    required this.startAt,
    required this.endAt,
  });

  LeagueModel.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          createdAt: json['created_at']! as String,
          startAt: json['start_at']! as String? ?? '',
          endAt: json['end_at']! as String? ?? '',
        );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'created_at': createdAt,
      'start_at': startAt,
      'end_at': endAt,
    };
  }
}
