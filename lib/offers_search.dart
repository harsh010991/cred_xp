import 'dart:convert';

import 'package:cred_xp/podo/credit_card_offers_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:json_table/json_table.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cred_xp/secure_storage.dart';

class OfferSearch extends StatefulWidget {
  const OfferSearch({Key? key}) : super(key: key);

  @override
   _OfferSearch createState() =>
    _OfferSearch();
}
class _OfferSearch extends State<OfferSearch>{

  late Future<dynamic> _existingOfferFuture;
  List<dynamic> _existingOfferList = [];
  String? selectedOffer;
  var cbDetailsJson;
  var offerCb;
  var offerCC;
  var ccOfferLink;
  late Uri _url;

  var columns = [
    JsonTableColumn("name", label : "Name"),
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
            ),
            body: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Center(
                child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Row(
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 20,5, 10),
                      alignment: Alignment.center,
                      child: const Text("Enter amount : ", style: TextStyle(fontSize: 22, color: Colors.black))),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: SizedBox(
                      height: 40,
                      width: 150,
                      child: TextField(
                          controller: amountEditingController,
                          decoration: const InputDecoration(border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ]),
                    ),
                  ),
              //   Container(
              //   margin: const EdgeInsets.fromLTRB(5.0, 20,5, 10),
              //       padding: const EdgeInsets.all(10.0),
              //       child: const TextField("Enter amount : ",controller: emailController, style: TextStyle(fontSize: 22, color: Colors.black),)),
              // Container(
              //   margin: const EdgeInsets.fromLTRB(0, 10, 5, 0),
              //   child: const SizedBox(
              //     height: 40,
              //     width: 180,
              //     child: TextField(
              //         decoration: InputDecoration(border: OutlineInputBorder())),
              //   ),
              // )
              ],
            ),
            FutureBuilder(
              future: _existingOfferFuture,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
              {
                if(snapshot.connectionState == ConnectionState.done){
                  return
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 20,5, 10),
                      child:Center(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        // buttonPadding: const EdgeInsets.all(10),
                        buttonHighlightColor: Colors.lightBlue,
                        hint: const Text(
                          'Select existing offer',
                          style: TextStyle(
                            fontSize: 18
                          ),
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
                        onChanged: (value){
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
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              hintText: 'Search for an existing offer...',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return (item.value.toString().contains(searchValue));
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
              }

            ),
                    SizedBox(
                      height: 60,
                      width: 100,
                      child:
                    Container(
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
                       getCashBack()
                          },
                      ),
                    )),
                    Container(
                        margin: const EdgeInsets.only(top: 20),
                      child:toggle ?
                      Column(
                        children: [
                          SizedBox(
                            width:double.infinity,
                          child:
                          JsonTable(cbDetailsJson, columns:columns,
                            tableHeaderBuilder: (header) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
                                decoration: BoxDecoration(border: Border.all(width: 0.5),color: Colors.grey[300]),
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
                                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
                                decoration: BoxDecoration(border: Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
                                child: Text(
                                  value,
                                  textAlign: TextAlign.center,
                                  //style: Theme.of(context).textTheme.display1.copyWith(fontSize: 14.0, color: Colors.grey[900]),
                                ),
                              );
                            },
                          )),
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 20,5, 10),
                          alignment: Alignment.center,
                          child:
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:'Get $offerCb cashback if you had $offerCC credit card.', style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black)
                                    ),
                                    TextSpan(
                                      style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.black, decorationStyle: TextDecorationStyle.wavy),
                                      text: " Apply by clicking here",
                                      recognizer: TapGestureRecognizer()..onTap=() async {
                                          if (!await launchUrl(_url)) {
                                            throw 'Could not launch $_url';
                                        }
                                      }
                                    )
                                  ]
                                ),
                              ),
                          // Text("Get $offerCb cashback if you had $offerCC credit card. Apply here : $ccOfferLink", style: TextStyle(fontSize: 15))),
                        )],
                      )
                      :const Center() )   ]
                ),
                )
    ));
    throw UnimplementedError();
  }
  Future<dynamic> getExistingOffersList() async{
    final response = await http.get(Uri.parse("https://run.mocky.io/v3/cfb3bc45-75cd-4f26-b0c1-784420ed7c6a"));
    if(response.statusCode == 200){
      setState((){
        print(jsonDecode(response.body)['existing_offer_list']);
        final existingOfferList = jsonDecode(response.body)['existing_offer_list'];
        _existingOfferList= existingOfferList;
        return json.decode(response.body);
      });
    }
    else {
      _showToast(context, 'Unable to get existing offers. Please refresh!!');
    }

  }
  void _showToast(BuildContext context, String message){
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(message),
      action: SnackBarAction(label: 'DONE',onPressed: scaffold.hideCurrentSnackBar,),
    ));
  }

   getCashBack() async {
    List<CreditCardOffersDetails> list;
    final response = await http.get(Uri.parse("https://run.mocky.io/v3/6eee945d-a783-4660-b58f-b71bf0916494"));
    print(response);
    print(response);
    if (response.statusCode == 200) {
      print(response.body.toString());
      setState((){
        cbDetailsJson = jsonDecode(response.body)["data"]["credit_card_offers"];
        offerCb = jsonDecode(response.body)["data"]["cc_refferal"]["cashback"];
        offerCC = jsonDecode(response.body)["data"]["cc_refferal"]["name"];
        ccOfferLink = jsonDecode(response.body)["data"]["cc_refferal"]["referral_link"];
        toggle = true;
        _url =  Uri.parse(ccOfferLink);
      });
      // list = cbDetailsList.map<CreditCardOffersDetails>((json) => CreditCardOffersDetails.fromJson(json)).toList();
      // return list;
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => VerifyOtp(loginId:amountEditingController.text)),
      // );
    } else {
      _showToast(context, 'Failed to send OTP. Please try again!!');
    }
    return null;
  }

  Future<String?> checkToken() async{
    return await secureStorage.getToken();
  }
  void _checkToken() async {
    var token;
    await checkToken().then((value) => {token = value, print(value)});
    if (token != null && token!.isEmpty) {
      Future.delayed(Duration.zero, () async {
        Navigator.pushNamed(context, '/signUp');
      });
    }
  }
}
