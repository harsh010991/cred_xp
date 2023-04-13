class OfferDetails{
  double amount;
  double rewardPoint;
  String cardName;
  String currency;
  double cashBack;
  bool gift;
  double totalSaving;
  String bankName;

  OfferDetails({
    required this.amount,
    required this.rewardPoint,
    required this.cardName,
    required this.currency,
    required this.cashBack,
    required this.gift,
    required this.totalSaving,
    required this.bankName
});

  factory OfferDetails.fromJson(Map<String, dynamic> json){
    return OfferDetails(
        amount:json["amount"],
        rewardPoint: json["rewardPoint"],
        cardName:json["cardName"],
        currency: json["currency"],
        cashBack: json["cashBack"],
        bankName: json["bankName"],
        gift: json["gift"],
        totalSaving : json["totalSaving"]
    );
  }
}