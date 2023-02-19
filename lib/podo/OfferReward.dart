class OfferReward{
  double amount;
  double rewardPoint;

  OfferReward({
    required this.amount,
    required this.rewardPoint
});

  factory OfferReward.fromJson(Map<String, dynamic> json){
    return OfferReward(
      amount: json["amount"],
      rewardPoint: json["rewardPoint"]
    );
  }
}