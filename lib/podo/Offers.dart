import 'package:cred_xp/podo/OfferInclusion.dart';

class Offers{
  bool gift;
  double cashBack;
  String currency;
  int minRewardPointRedeem;
  OfferInclusion offerInclusion;

  Offers({
    required this.gift,
    required this.cashBack,
    required this.currency,
    this.minRewardPointRedeem = 0,
    required this.offerInclusion
  });

  factory Offers.fromJson(Map<String, dynamic> json){
    return Offers(
        gift: json["gift"],
        cashBack: json["cashBack"],
      currency: json["currency"],
      minRewardPointRedeem: json["minRewardPointRedeem"],
      offerInclusion: json["inclusion"]
    );
  }
}