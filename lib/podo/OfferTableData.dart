class OfferTableData{
 late String cardName;
  late double cashBack;
//   OfferDetails({
//     required this.cardName;
//     required this.cashBack;
// });
  set setCardName(String cardname){
    this.cardName = cardname;
  }
  set setCashBack(double cashBack){
    this.cashBack = cashBack;
  }
  String get getCardName {
    return cardName;
  }
  double get getCashBack {
    return cashBack;
  }
  Map<String, dynamic> toJson() {
    return {
      'name': cardName,
      'cashback': cashBack,
    };
  }
  // @override
  // String toString() {
  //   return "{'Name':$cardName', 'cashBack': $cashBack}";
  // }
}