import 'Offers.dart';

class CreditCardOffersDetails {
  int id;
  String ccName;
  String status;
  String cardType;
  Offers offers;
  String bankName;
  int createdAt;
  int updatedAt;


  CreditCardOffersDetails({
     required this.id,
    required this.ccName,
    required this.status,
    required this.cardType,
    required this.offers,
    required this.bankName,
    required this.createdAt,
    required this.updatedAt
  });


  factory CreditCardOffersDetails.fromJson(Map<String, dynamic> json){
    return CreditCardOffersDetails(
      id:json["id"],
      ccName: json["name"],
        status:json["status"],
      cardType: json["cardType"],
      offers: json["offers"],
      bankName: json["bankName"],
      createdAt: json["createdAt"],
        updatedAt : json["updatedAt"]
    );
  }
}
