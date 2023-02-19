import 'dart:collection';

import 'package:cred_xp/podo/OfferDetail.dart';

class UserCreditCardOfferDetails {
  HashSet<String> offersSet;
  HashMap<String, OfferDetails> offerDetailsMap;

  UserCreditCardOfferDetails(
      {required this.offersSet, required this.offerDetailsMap});

  factory UserCreditCardOfferDetails.fromJson(Map<String, dynamic> json) {
    return UserCreditCardOfferDetails(
        offersSet: json["offersSet"], offerDetailsMap: json["cardOfferMap"]);
  }
}
