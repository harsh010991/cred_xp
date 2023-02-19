import 'dart:collection';
import 'dart:convert';

import 'package:cred_xp/podo/CreditCardDetails.dart';
import 'package:cred_xp/podo/OfferDetail.dart';
import 'package:cred_xp/podo/OfferTableData.dart';
import 'package:cred_xp/podo/StorageItem.dart';
import 'package:cred_xp/podo/UserCreditCardOfferDetails.dart';
import 'package:cred_xp/sign_up_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:json_table/json_table.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cred_xp/storage/SecureStorage.dart';

class OfferSearch extends StatefulWidget {
  const OfferSearch({Key? key}) : super(key: key);

  @override
  _OfferSearch createState() => _OfferSearch();
}

class _OfferSearch extends State<OfferSearch> {
  late Future<dynamic> _existingOfferFuture;
  List<dynamic> _existingOfferList = [];
  Map<String, List<OfferDetails>> cashbackDetailsMap = Map();
  String? selectedOffer;
  var cbDetailsJson;
  var offerCb;
  var offerCC;
  var ccOfferLink;
  late Uri _url;

  var columns = [
    JsonTableColumn("name", label: "Name"),
    JsonTableColumn("cashback", label: "Cash")
  ];
  var secureStorage = SecureStorage();

  @override
  initState() {
    _checkToken();
    _existingOfferFuture = getExistingOffersList();
    // super.initState();
  }

  String? _selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController amountEditingController = TextEditingController();
  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            title: const Text('CredXp'),
            automaticallyImplyLeading: false,
            actions: [
              TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue)),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => {
                  SecureStorage.deleteSecureData(StorageItem('token', 'value'))
                      .then((value) => {
                            _showToast(context, 'Successfully Logged Out'),
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()),
                            )
                          }),
                },
              ),
            ]),
        body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(10, 20, 5, 10),
                        alignment: Alignment.center,
                        child: const Text("Enter amount : ",
                            style:
                                TextStyle(fontSize: 22, color: Colors.black))),
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: SizedBox(
                        height: 40,
                        width: 150,
                        child: TextField(
                            controller: amountEditingController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                      ),
                    ),
                  ],
                ),
                FutureBuilder(
                    future: _existingOfferFuture,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Container(
                            margin: const EdgeInsets.fromLTRB(10, 20, 5, 10),
                            child: Center(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  // buttonPadding: const EdgeInsets.all(10),
                                  buttonHighlightColor: Colors.lightBlue,
                                  hint: const Text(
                                    'Select existing offer',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  items: _existingOfferList
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: _selectedValue,
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      _selectedValue = value as String?;
                                    });
                                  },
                                  buttonHeight: 60,
                                  buttonWidth: 380,
                                  itemHeight: 40,
                                  searchController: textEditingController,
                                  searchInnerWidget: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 5,
                                      right: 10,
                                      left: 10,
                                    ),
                                    child: TextFormField(
                                      controller: textEditingController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 12,
                                        ),
                                        hintText:
                                            'Search for an existing offer...',
                                        hintStyle:
                                            const TextStyle(fontSize: 12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    print(searchValue);
                                    return (item.value
                                        .toString()
                                        .contains(searchValue));
                                  },
                                  //This to clear the search value when you close the menu
                                  onMenuStateChange: (isOpen) {
                                    if (!isOpen) {
                                      textEditingController.clear();
                                    }
                                  },
                                ),
                              ),
                            ));
                      }
                      return const Center(
                        child: SpinKitDualRing(
                          color: Colors.blue,
                        ),
                      );
                    }),
                SizedBox(
                    height: 60,
                    width: 100,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue)),
                        child: const Text(
                          "Calculate",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => {getCashBack()},
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: toggle
                        ? Column(
                            children: [
                              SizedBox(
                                  width: double.infinity,
                                  child: JsonTable(
                                    cbDetailsJson,
                                    columns: columns,
                                    tableHeaderBuilder: (header) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 0.5),
                                            color: Colors.grey[300]),
                                        child: Text(
                                          header!,
                                          textAlign: TextAlign.center,
                                          // style: Theme.of(context).textTheme.display1.copyWith(fontWeight: FontWeight.w700,
                                          //     fontSize: 14.0,color: Colors.black87),
                                        ),
                                      );
                                    },
                                    tableCellBuilder: (value) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 2.0),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.5,
                                                color: Colors.grey
                                                    .withOpacity(0.5))),
                                        child: Text(
                                          value,
                                          textAlign: TextAlign.center,
                                          //style: Theme.of(context).textTheme.display1.copyWith(fontSize: 14.0, color: Colors.grey[900]),
                                        ),
                                      );
                                    },
                                  )),
                              Container(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 20, 5, 10),
                                alignment: Alignment.center,
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text:
                                            'Get $offerCb cashback if you had $offerCC credit card.',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                    TextSpan(
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            decorationStyle:
                                                TextDecorationStyle.wavy),
                                        text: " Apply by clicking here",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            if (!await launchUrl(_url)) {
                                              throw 'Could not launch $_url';
                                            }
                                          })
                                  ]),
                                ),
                                // Text("Get $offerCb cashback if you had $offerCC credit card. Apply here : $ccOfferLink", style: TextStyle(fontSize: 15))),
                              )
                            ],
                          )
                        : const Center())
              ]),
            )));
    throw UnimplementedError();
  }

  Future<dynamic> getExistingOffersList() async {
    String? token = "";
    await SecureStorage.readSecureData('token')
        .then((value) => {token = value});
    final response = await http.post(
      Uri.parse('http://10.0.2.2:9020/user/offerDetails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth_token': token.toString()
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        print(jsonDecode(response.body)['data']);
        final existingOfferList = jsonDecode(response.body)['data']['offerSet'];
        _existingOfferList = existingOfferList;
        Map<String, List<dynamic>> map =
            Map.from(jsonDecode(response.body)['data']['cardOfferMap']);

        map.forEach((k, v) {
          List<OfferDetails> offerDetailsList = List.empty(growable: true);
          for (int i = 0; i < v.length; i++) {
            offerDetailsList.add(OfferDetails.fromJson(v[i]));
          }
          if (offerDetailsList.isNotEmpty) {
            cashbackDetailsMap.putIfAbsent(k, () => offerDetailsList);
          }
        });
        ccOfferLink = jsonDecode(response.body)['data']['referralLink'];
        offerCC = jsonDecode(response.body)['data']['referralCardName'];
        offerCb = jsonDecode(response.body)['data']['cashBackPercentage'];
        _url = Uri.parse(ccOfferLink);
        return json.decode(response.body);
      });
    } else {
      _showToast(context, 'Unable to get existing offers. Please refresh!!');
    }
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'DONE',
        onPressed: scaffold.hideCurrentSnackBar,
      ),
    ));
  }

  getCashBack() async {
    List<OfferDetails>? offerDetails = cashbackDetailsMap[_selectedValue];
    List<dynamic> offerTableDataList = List.empty(growable: true);
    if (offerDetails != null) {
      for (var i = 0; i < offerDetails.length; i++) {
        double totalCashback = (offerDetails[i].cashBack *
            int.parse(amountEditingController.text) /
            offerDetails[i].amount);
        OfferTableData offerTableData = OfferTableData();
        offerTableData.cardName = offerDetails[i].cardName;
        offerTableData.cashBack = totalCashback;
        offerTableDataList.add(offerTableData.toJson());
      }
    }
    List<CreditCardOffersDetails> list;
    setState(() {
      cbDetailsJson = offerTableDataList;
      toggle = true;
      offerCb = int.parse(amountEditingController.text) * offerCb / 100;
    });
  }

  void _checkToken() async {
    await SecureStorage.containsKeyInSecureData('token').then((value) => {
          if (!value)
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUp(),
                ),
              )
            }
        });
  }
}
