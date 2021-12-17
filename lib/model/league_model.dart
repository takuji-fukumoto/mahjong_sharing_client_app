class LeagueModel {
  late String docId;
  late String name;
  late String createdAt;
  late String startAt;
  late String endAt;
  late String description;

  LeagueModel({
    required this.docId,
    required this.name,
    required this.createdAt,
    required this.startAt,
    required this.endAt,
    required this.description,
  });

  LeagueModel.fromJson(String docId, Map<String, Object?> json)
      : this(
          docId: docId,
          name: json['name']! as String,
          createdAt: json['created_at']! as String,
          startAt: json['start_at'] as String? ?? '',
          endAt: json['end_at'] as String? ?? '',
          description: json['description'] as String? ?? '',
        );

  Map<String, dynamic> toJson() {
    return {
      'doc_id': docId,
      'name': name,
      'created_at': createdAt,
      'start_at': startAt,
      'end_at': endAt,
      'description': description,
    };
  }
}
