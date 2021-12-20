class ResultModel {
  late int round;
  late String leagueName;
  late List<Map<String, int>> score;

  ResultModel({
    required this.round,
    this.leagueName = '',
    required this.score,
  });
}
