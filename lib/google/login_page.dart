import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import '../item_list.dart';
import '../podo/StorageItem.dart';
import '../storage/SecureStorage.dart';
import 'auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("CredXp"),
          backgroundColor: Colors.blue,
        ),
        body: Container(
            width: size.width,
            height: size.height,
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: size.height * 0.2,
                bottom: size.height * 0.5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Hey There..!!", style: TextStyle(fontSize: 25)),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () => {
                        AuthService().signInWithGoogle(context)
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                      ),
                      label: Text('Sign In With Google')),
                ])
        )
    );
  }

  // void authorizeUser(BuildContext context) async{
  //   Future<Tuple2<UserCredential, GoogleSignInAuthentication>> futureTuple =  AuthService().signInWithGoogle(context);
  //   String email = "", accessToken = "";
  //   await futureTuple.then((value) =>{ accessToken = value.item2.accessToken!,
  //   email = value.item1.user!.email!
  //   });
  //   final response = await http.post(
  //     Uri.parse('http://10.0.2.2:8080/appSocialLogin'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'email': email,
  //       'accessToken': accessToken,
  //
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     print(response.body.toString());
  //     await SecureStorage.writeSecureData(
  //         StorageItem('token', jsonDecode(response.body)['data']['token']));
  //     // Navigator.pushReplacement(
  //     //     context,
  //     //     MaterialPageRoute(builder: (context) => const CreditCardList()),
  //     //   );
  //   } else {
  //     _showToast(context, 'Please try again!!');
  //   }
  // }
  // void _showToast(BuildContext context, String message) {
  //   final scaffold = ScaffoldMessenger.of(context);
  //   scaffold.showSnackBar(SnackBar(
  //     content: Text(message),
  //     action: SnackBarAction(
  //       label: 'DONE',
  //       onPressed: scaffold.hideCurrentSnackBar,
  //     ),
  //   ));
  // }

}
