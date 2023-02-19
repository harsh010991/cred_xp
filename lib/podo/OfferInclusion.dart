import 'package:cred_xp/podo/OfferReward.dart';

class OfferInclusion{
  String key;
  OfferReward offerReward;

  OfferInclusion({
    required this.key,
    required this.offerReward
  });

  factory OfferInclusion.fromJson(Map<String, dynamic> json){
    return OfferInclusion(
        key: json["key"],
        offerReward: json["value"]
    );
  }
}