class OfferTableData
{
  late String cardName = "";
  late int cashBack = 0;
  late int totalReward = 0;
  late bool isReferralCard = false;
  late String referralLink = "";
  late String referralCardName = "";
  late double referralCashBack = 0.0;
  late String cardImageName = "";


//   OfferDetails({
//     required this.cardName;
//     required this.cashBack;
//     required this.totalReward;
// });

  set setCardName(String cardname){
    this.cardName = cardname;
  }
  set setCardImageName(String cardImageName){
    this.cardImageName = cardImageName;
  }
  String get getCardImageName {
    return cardImageName;
  }
  set setCashBack(int cashBack){
    this.cashBack = cashBack;
  }
  set setTotalReward(int totalReward){
    this.totalReward = totalReward;
  }
  set setReferralLink(String referralLink){
    this.referralLink = referralLink;
  }
  set setReferralCardName(String referralCardName){
    this.referralCardName = referralCardName;
  }
  set setReferralCashBack(double referralCashBack){
    this.referralCashBack = referralCashBack;
  }
  set setIsReferralCard(bool isReferralCard){
    this.isReferralCard = isReferralCard;
  }
  String get getReferralLink {
    return referralLink;
  }
  String get getReferralCardName {
    return referralCardName;
  }
  double get getReferralCashBack {
    return referralCashBack;
  }
  bool get getIsReferralCard {
    return isReferralCard;
  }
  String get getCardName {
    return cardName;
  }
  int get getTotalReward {
    return totalReward;
  }
  int get getCashBack {
    return cashBack;
  }
  Map<String, dynamic> toJson() {
    return {
      'name': cardName,
      'cashback': cashBack,
      'totalReward' : totalReward,
      'isReferralCard' : isReferralCard,
      'referralLink' : referralLink,
      'referralCardName' :referralCardName,
      'referralCashBack' : referralCashBack
    };
  }
  // @override
  // String toString() {
  //   return "{'Name':$cardName', 'cashBack': $cashBack}";
  // }
}