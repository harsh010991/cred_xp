class CreditCardOffersDetails {
  CreditCardOffersDetails({
     required this.cashback,
  });

  double cashback;

  factory CreditCardOffersDetails.fromJson(Map<String, dynamic> json){
    return CreditCardOffersDetails(
      cashback:json["cashback"]
    );
  }
}
