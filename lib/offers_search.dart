import 'dart:collection';
import 'dart:convert';

import 'package:cred_xp/google/auth_service.dart';
import 'package:cred_xp/google/login_page.dart';
import 'package:cred_xp/podo/CreditCardDetails.dart';
import 'package:cred_xp/podo/OfferDetail.dart';
import 'package:cred_xp/podo/OfferTableData.dart';
import 'package:cred_xp/podo/StorageItem.dart';
import 'package:cred_xp/podo/UserCreditCardOfferDetails.dart';
import 'package:cred_xp/sign_up_page.dart';
import 'package:flutter/gestures.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:json_table/json_table.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cred_xp/storage/SecureStorage.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'google2/login_page2.dart';
import 'help_query.dart';
import 'item_list.dart';

class OfferSearch extends StatefulWidget {
  late String email;
  late String accessToken;

  OfferSearch({Key? key, required this.email, required this.accessToken})
      : super(key: key);

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
  var referralOfferCb;
  var referralCardImageName;
  var offerCC;
  var referralCardApplyLink;
  late Uri _url;
  var _referralCardList;
  Set<String> cardNameSet = {};
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var columns = [
    JsonTableColumn("name", label: "Name"),
    JsonTableColumn("cashback", label: "Cash")
  ];
  // var secureStorage = SecureStorage();
  String? _selectedValue;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController amountEditingController = TextEditingController();
  bool toggle = false;

  @override
  initState() {
    super.initState();
    // AuthService().appSocialLogin(widget.email, widget.accessToken).whenComplete(
    //         () => _checkToken()).then((value) => _asyncMethod());
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _asyncMethod();
    // });
    _existingOfferFuture =
        getExistingOffersList(widget.email, widget.accessToken);
  }

  @override
  void dispose() {
    amountEditingController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
            title: const Text('CredRp'),
            automaticallyImplyLeading: false,
            actions: [
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(value: 0, child: Text("Logout")),
                    const PopupMenuItem<int>(
                        value: 1, child: Text("Credit Cards List")),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    // SecureStorage.deleteSecureData(
                    //         StorageItem('token', 'value'))
                    //     .then((value) async => {
                    //           _showToast(context, 'Successfully Logged Out'),
                              AuthService().signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => AuthService().handleAuthState()),
                                  (Route<dynamic> route) => false);
                            }
                  else if (value == 1) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreditCardList(
                            email: widget.email,
                            accessToken: widget.accessToken,
                          ),
                        ));
                  }
                },
              ),
            ]),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: _existingOfferFuture,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                          margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                          child: Center(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                // buttonPadding: const EdgeInsets.all(10),
                                // buttonHighlightColor: Colors.lightBlue,
                                hint: const Text(
                                  'Select existing offer',
                                  style: TextStyle(fontSize: 18),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.list,
                                  ),
                                  iconSize: 24,
                                  iconEnabledColor: Colors.blue,
                                  iconDisabledColor: Colors.grey,
                                ),

                                items: _existingOfferList
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                              fontSize: 18,
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
                                buttonStyleData: ButtonStyleData(
                                  height: 60,
                                  width: 380,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                dropdownStyleData: DropdownStyleData(
                                    // offset: const Offset(-20, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    isOverButton: true,
                                    isFullScreen: true,
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness: MaterialStateProperty.all(6),
                                      thumbVisibility:
                                          MaterialStateProperty.all(true),
                                    )),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),

                                // itemHeight: 40,
                                dropdownSearchData: DropdownSearchData(
                                  searchController: textEditingController,
                                  searchInnerWidgetHeight: 150,
                                  searchInnerWidget: Container(
                                    height: 70,
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 15,
                                        right: 10,
                                        left: 10),
                                    child: TextFormField(
                                      expands: true,
                                      maxLines: null,
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
                                      validator: (value) {
                                        if (value == null || value.isEmpty)
                                          return "Please Select Anyone";
                                      },
                                    ),
                                  ),
                                  searchMatchFn: (item, searchValue) {
                                    print(searchValue);
                                    return (item.value
                                        .toString()
                                        .toLowerCase()
                                        .contains(searchValue.toLowerCase()));
                                  },
                                ),
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
              Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                  child: Form(
                      key: formKey,
                      child: TextFormField(
                        autofocus: true,
                        controller: amountEditingController,
                        decoration: InputDecoration(
                          labelText: "Enter Amount",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.blue)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.blue)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red)),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],

                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 2 ||
                              value.length > 7) return "Valid Amount Required";
                        },
                        // validator: MultiValidator([RequiredValidator(errorText: "Amount Required")]),
                      ))),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 60,
                  width: 350,
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
                      onPressed: () => {
                        if (formKey.currentState!.validate() &&
                            _selectedValue != null &&
                            _selectedValue != "")
                          {getCashBack()}
                      },
                    ),
                  )),
              const SizedBox(
                height: 80,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpQuery(
                          email: widget.email,
                        ),
                      ));
                },
                child: const Text(
                  'Suggestions? Please connect here.',
                  style: TextStyle(
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: false
                      ? Column(
                          children: [
                            Container(
                                width: double.infinity,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: cbDetailsJson.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          title: Text(
                                              cbDetailsJson[index]['name']),
                                          leading: const Icon(
                                              Icons.account_balance,
                                              color: Colors.lightBlue),
                                          trailing: Text(cbDetailsJson[index]
                                                      ['cashback']
                                                  ?.toString() ??
                                              ""),
                                        ),
                                      );
                                    })),
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 20, 5, 10),
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
          ),
        ));
    throw UnimplementedError();
  }

  List<DropdownMenuItem<String>> _addDividersAfterItems(List<dynamic> items) {
    List<DropdownMenuItem<String>> _menuItems = [];
    for (var item in items) {
      _menuItems.addAll(
        [
          DropdownMenuItem<String>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (item != items.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _menuItems;
  }

  Future<dynamic> getExistingOffersList(
      String email, String accessToken) async {
    String? token = "";
    // await SecureStorage.readSecureData('token')
    //     .then((value) => {token = value});
    final response = await http.post(
      Uri.parse(
          'http://ec2-65-2-31-153.ap-south-1.compute.amazonaws.com/user/offerDetails'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'auth_token': token.toString(),
        'email': email,
        'accessToken': accessToken
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        // print(jsonDecode(response.body)['data']);
        final existingOfferList = jsonDecode(response.body)['data']['offerSet'];
        _existingOfferList = existingOfferList;
        Map<String, List<dynamic>> map =
            Map.from(jsonDecode(response.body)['data']['cardOfferMap']);

        map.forEach((k, v) {
          List<OfferDetails> offerDetailsList = List.empty(growable: true);
          for (int i = 0; i < v.length; i++) {
            offerDetailsList.add(OfferDetails.fromJson(v[i]));
            cardNameSet.add(v[i]['cardName']);
          }
          if (offerDetailsList.isNotEmpty) {
            cashbackDetailsMap.putIfAbsent(k, () => offerDetailsList);
          }
        });
        _referralCardList =
            jsonDecode(response.body)['data']['referralCardPojoList'];
        //
        // ccOfferLink = jsonDecode(response.body)['data']['referralLink'];
        // offerCC = jsonDecode(response.body)['data']['referralCardName'];
        // referralOfferCb =
        //     jsonDecode(response.body)['data']['cashBackPercentage'];
        // _url = Uri.parse(ccOfferLink);
        return json.decode(response.body);
      });
    } else {
      //_showToast(context, 'Unable to get existing offers. Please refresh!!');
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
    // if(formKey.currentState !.validate()) {
    //   print("submit");
    // }
    List<OfferDetails>? offerDetails = cashbackDetailsMap[_selectedValue];
    List<Map<String, dynamic>> offerTableDataList = List.empty(growable: true);
    if (offerDetails != null) {
      for (var i = 0; i < offerDetails.length; i++) {
        double totalCashback = (offerDetails[i].cashBack *
            offerDetails[i].rewardPoint *
            int.parse(amountEditingController.text) /
            offerDetails[i].amount);
        OfferTableData offerTableData = OfferTableData();
        offerTableData.cardName = offerDetails[i].cardName;
        if (cardNameSet.contains(offerTableData.cardName))
          cardNameSet.remove(offerTableData.cardName);
        offerTableData.cashBack = totalCashback.ceil();
        offerTableData.totalReward = (offerDetails[i].rewardPoint *
                int.parse(amountEditingController.text) /
                offerDetails[i].amount)
            .ceil();
        offerTableDataList.add(offerTableData.toJson());
      }

      // for (int i = 0; i < cardNameSet.length; i++) {
      //   OfferTableData offerTableData = OfferTableData();
      //   offerTableData.cardName = cardNameSet.elementAt(i);
      //   offerTableData.cashBack = 0;
      //   offerTableDataList.add(offerTableData.toJson());
      // }
    }
    offerTableDataList.sort((a, b) {
      return (a["cashback"]).compareTo(b["cashback"]);
    });
    for (var i = 0; i < _referralCardList.length; i++) {
      referralCardImageName = _referralCardList[i]['referralCardName'];
      referralCardApplyLink = Uri.parse(_referralCardList[i]['referralLink']);
      break;
    }
    List<CreditCardOffersDetails> list;
    setState(() {
      cbDetailsJson = offerTableDataList;
      // offerCb = int.parse(amountEditingController.text) * referralOfferCb / 100;
      toggle = true;
      showAlertDialog(context);
    });
  }

  _checkToken() async {
    await SecureStorage.containsKeyInSecureData('token').then((value) => {
          if (!value)
            {
              AuthService().signOut(),
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const LoginPage(),
              //   ),
              // )
            }
        });
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reward Points'),
            // contentPadding: EdgeInsets.only(left: 25, right: 25),
            content: setupAlertDialogContainer(),
          );
        });
  }

  Widget setupAlertDialogContainer() {
    return Container(
        width: 400,
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: cbDetailsJson.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                          title: Text(
                            cbDetailsJson[index]['name'],
                            style: TextStyle(fontSize: 14),
                          ),
                          leading: const Icon(
                            Icons.account_balance,
                            color: Colors.blue,
                            size: 18,
                          ),
                          tileColor: Colors.white54,
                          minLeadingWidth: 1,
                          trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 70,
                                    height: 20,
                                    // color: Colors.green[300],
                                    padding: const EdgeInsets.fromLTRB(2.5, 2.5, 2.5, 2.5),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black12, width: 0.8),
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white54),
                                    child: Text(
                                        "Reward : " +
                                            cbDetailsJson[index]['totalReward']
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: index !=
                                                    cbDetailsJson.length - 1
                                                ? Colors.redAccent[800]
                                                : Colors.green))),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 60,
                                  height: 20,
                                  // color: Colors.green[300],
                                  padding: EdgeInsets.fromLTRB(10, 4, 1, 3),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black12, width: 0.8),
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white54),
                                  child: Text(
                                      "Cash : " +
                                          cbDetailsJson[index]['cashback']
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: index != cbDetailsJson.length - 1
                                            ? Colors.redAccent[800]
                                            : Colors.yellow[800],
                                      )),
                                ),
                              ])),
                    );
                  }),
              Container(
                child: Column(
                  children: [
                    for (int i = 0; i < _referralCardList.length; i++)
                      Column(children: [
                        Image.asset('assets/images/' +
                            _referralCardList[i]['referralCardName'] +
                            '.png'),
                        SizedBox(
                            height: 35,
                            width: 100,
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.blue)),
                              child: const Text(
                                "Apply Now",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => {
                                _launchURL(Uri.parse(
                                    _referralCardList[i]['referralLink']))
                              },
                            )),
                        SizedBox(
                          width: 10,
                          height: 20,
                        )
                      ])
                  ],
                ),
              )
            ])
            // Container(
            //     margin: const EdgeInsets.fromLTRB(10, 20, 5, 10),
            //     alignment: Alignment.center,
            //     height: 550,
            //     width: 400,
            //     child: ListView.builder(
            //         shrinkWrap: true,
            //         itemCount: _referralCardList.length,
            //         itemBuilder: (context, index) {
            //           return Card(
            //             child: ListTile(
            //                 title: Text(
            //                   _referralCardList[index]['referralCardName'],
            //                   style: TextStyle(fontSize: 14),
            //                 ),
            //                 leading: const Icon(
            //                   Icons.account_balance,
            //                   color: Colors.blue,
            //                   size: 18,
            //                 ),
            //                 tileColor: Colors.white54,
            //                 minLeadingWidth: 1,
            //                 trailing: Container(
            //                     margin: const EdgeInsets.fromLTRB(10, 20, 5, 10),
            //                     alignment: Alignment.center,
            //                     child: RichText(
            //                         text: TextSpan(children: [
            //                       TextSpan(
            //                           style: const TextStyle(
            //                               fontStyle: FontStyle.italic,
            //                               fontWeight: FontWeight.bold,
            //                               color: Colors.black,
            //                               decorationStyle:
            //                                   TextDecorationStyle.wavy),
            //                           text: "Apply by clicking here",
            //                           recognizer: TapGestureRecognizer()
            //                             ..onTap = () async {
            //                               if (!await launchUrl(Uri.parse( _referralCardList[index]['referralLink']))) {
            //                                 throw 'Could not launch ' + _referralCardList[index]['referralLink'];
            //                               }
            //                             })
            //                     ])))),
            //             // Text("Get $offerCb cashback if you had $offerCC credit card. Apply here : $ccOfferLink", style: TextStyle(fontSize: 15))),
            //           );
            //         }))
            ));
  }

  _launchURL(uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
// Text("Get $offerCb cashback if you had $offerCC credit card. Apply here : $ccOfferLink", style: TextStyle(fontSize: 15))),
}
