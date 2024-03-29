import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:cred_xp/offers_search.dart';
import 'package:cred_xp/storage/SecureStorage.dart';
import 'package:cred_xp/sign_up_page.dart';

import 'google/auth_service.dart';

class CreditCardList extends StatefulWidget {
  late String email;
  late String accessToken;

  CreditCardList({Key? key, required this.email, required this.accessToken})
      : super(key: key);

  @override
  _CreditCardList createState() => _CreditCardList();
}

class _CreditCardList extends State<CreditCardList> {
  late List<Map<String, dynamic>> _allUsers;

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
  var selectedIndexes = [];
  late Future<dynamic> _creditCardListFututre;
  late String token = "";
  List<dynamic> selectedCardList = [];

  @override
  initState() {
    super.initState();
    // AuthService().appSocialLogin(widget.email, widget.accessToken).whenComplete(() => null);
    // _checkToken();
    _creditCardListFututre =
        getCreditCardList(widget.email, widget.accessToken);
    // super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
      setState(() {
        _foundUsers = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Credit Card List'), actions: [
          TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue)),
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => {
              _showToast(context, 'Successfully Saved Details.'),
              updateUserCCList(this.widget.email).then((value) => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OfferSearch(
                                email: widget.email,
                                accessToken: widget.accessToken,
                              )),
                    )
                  }),
            },
          ),
        ]),
        body: FutureBuilder(
            future: _creditCardListFututre,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                          onChanged: (value) => _runFilter(value),
                          decoration: const InputDecoration(
                              labelText: 'Search',
                              suffixIcon: Icon(Icons.search))),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: _foundUsers.isNotEmpty
                            ? ListView.builder(
                                itemCount: _foundUsers.length,
                                itemBuilder: (context, index) => Card(
                                    key: ValueKey(_foundUsers[index]["id"]),
                                    color: Colors.blue,
                                    elevation: 4,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      children: [
                                        CheckboxListTile(
                                          value: _foundUsers[index]
                                                  ["isCheck"] ??
                                              false,
                                          title: Text(
                                              _foundUsers[index]["name"]
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                          onChanged: (_) {
                                            setState(() {
                                              _foundUsers[index]["isCheck"] =
                                                  !_foundUsers[index]
                                                      ["isCheck"];
                                              selectedCardList.add({
                                                "cardId": _foundUsers[index]
                                                    ["id"]
                                              });
                                            });
                                          },
                                        )
                                      ],
                                    )),
                              )
                            : const Text(
                                'No result found',
                                style: TextStyle(fontSize: 24),
                              ),
                      )
                    ],
                  ),
                );
              }
              return const Center(
                child: SpinKitDualRing(
                  color: Colors.blue,
                ),
              );
            }));
  }

  Future<dynamic> getCreditCardList(String email, String accessToken) async {
    try {
      // await SecureStorage.readSecureData('token')
      //     .then((value) => {token = value!});
      final response = await http.post(
        Uri.parse('http://ec2-65-2-31-153.ap-south-1.compute.amazonaws.com/getCardList'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'auth_token': token.toString(),
          'email': email,
          'accessToken': accessToken
        }),
      );
      print(response);
      if (response.statusCode == 200) {
        print(response.body.toString());
        setState(() {
          final creditCardList =
              jsonDecode(response.body)['data'].cast<Map<String, dynamic>>();
          _foundUsers = creditCardList;
          _allUsers = creditCardList;
          return json.decode(utf8.decode(response.bodyBytes));
        });
      } else {
        _showToast(context, 'Failed to send OTP. Please try again!!');
      }
    } catch (e) {
      print(e.toString());
      print(e);
    }
  }

  Future<dynamic> updateUserCCList(String email) async {
    final response = await http.post(
      Uri.parse('http://ec2-65-2-31-153.ap-south-1.compute.amazonaws.com/user/card'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth_token': token.toString()
      },
      body: jsonEncode(
          <String, dynamic>{"email": email, "userCardList": selectedCardList}),
    );
    if (response.statusCode == 200) {
      _showToast(context, 'Successfully saved card details.');
    } else {
      _showToast(context, 'Unable to save card details.!!');
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

  _checkToken() async {
    await SecureStorage.containsKeyInSecureData('token').then((value) => {
          if (!value)
            {
              AuthService().signOut(),
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const SignUp(),
              //   ),
              // )
            }
        });
  }
}
