class SettingModel {
  late String bonusByRanking; // [１位ボーナス-２位ボーナス]の形式
  late int originPoints;
  late int topPrize;

  SettingModel({
    this.bonusByRanking = '',
    this.originPoints = 25000,
    this.topPrize = 25000,
  });

  // return each rank bonus => [1st, 2nd, 3rd, 4th]
  List<int> bonusPointsEachRanks() {
    var bonus = bonusByRanking.split('-');
    if (bonus.length < 2) {
      return [0, 0, 0, 0];
    }

    var rank1 = int.parse(bonus.last);
    var rank2 = int.parse(bonus.first);

    return [rank1, rank2, -rank2, -rank1];
  }
}
