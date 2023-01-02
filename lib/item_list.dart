import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:cred_xp/offers_search.dart';
import 'package:cred_xp/secure_storage.dart';
import 'package:cred_xp/sign_up_page.dart';

class CreditCardList extends StatefulWidget {
  const CreditCardList({Key? key}) : super(key: key);

  @override
  _CreditCardList createState() => _CreditCardList();
}

class _CreditCardList extends State<CreditCardList> {
   List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "Flipkart Axis Bank", "isCheck": false},
    {"id": 2, "name": "Money Back HDFC", "isCheck": false},
    {"id": 3, "name": "Smart SC", "isCheck": false},
    {"id": 4, "name": "HDFC Infinia", "isCheck": false},
    {"id": 5, "name": "RBL Platinum", "isCheck": false},
    {"id": 6, "name": "SBI Gold", "isCheck": false},
    {"id": 7, "name": "Axis Bank Freedom", "isCheck": false},
    {"id": 8, "name": "BOB Lavish", "isCheck": false},
    {"id": 9, "name": "SC Caversky",  "isCheck": false},
    {"id": 10, "name": "Axis Becky", "isCheck": false},
  ];

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
  var selectedIndexes = [];
  late Future<dynamic> _creditCardListFututre;
   var secureStorage = SecureStorage();

  @override
  initState() {
    super.initState();
    _checkToken();
    _creditCardListFututre = getCreditCardList();
    // super.initState();
  }
  Future<String?> checkToken() async{
    return await secureStorage.getToken();
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
      appBar: AppBar(
        title: const Text('Credit Card List'),
        actions:[
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.blue)),
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () => {
            _showToast(context, 'Successfuly Saved Details.'),
          Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => const OfferSearch()),
          )
          },
        ),
    ]),
      body:
      FutureBuilder(
        future: _creditCardListFututre,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
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
                          labelText: 'Search', suffixIcon: Icon(Icons.search))),
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
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child:
                          Column(
                            children: [
                              CheckboxListTile(
                                value: _foundUsers[index]["isCheck"],
                                title: Text(_foundUsers[index]["name"].toString(),
                                    style: const TextStyle(color: Colors.white)),
                                onChanged: (_){
                                  setState(() {
                                    _foundUsers[index]["isCheck"] = !_foundUsers[index]["isCheck"];
                                  });
                                },)
                            ],
                          )
                      ),
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
        }
    )

    );
  }

  Future<dynamic> getCreditCardList() async {
    final response = await http.get(
        Uri.parse("https://run.mocky.io/v3/bd9dd3a8-1b93-449d-bab4-fcbf6d85170f"));
    print(response);
    if (response.statusCode == 200) {
      print(response.body.toString());
      setState(() {
        final creditCardList = jsonDecode(response.body)['credit_card_list'].cast<Map<String, dynamic>>();
        _foundUsers = creditCardList;
        _allUsers = creditCardList;
        return json.decode(utf8.decode(response.bodyBytes));
      });
    } else {
      _showToast(context, 'Failed to send OTP. Please try again!!');
    }
  }
  void _showToast(BuildContext context, String message){
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(content: Text(message),
      action: SnackBarAction(label: 'DONE',onPressed: scaffold.hideCurrentSnackBar,),
    ));
  }
  void _checkToken() async{
    String? token = "";
    await checkToken().then((value) => {token= value, print(value)});
    if( token != null && token!.isEmpty){
      Future.delayed(Duration.zero, () async {
        Navigator.pushNamed(context, '/signUp');
      });
    }
  }
}
