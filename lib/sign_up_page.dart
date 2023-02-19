import 'dart:convert';

import 'package:cred_xp/offers_search.dart';
import 'package:cred_xp/storage/UserSecureStorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'verify_otp_page.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  .then((_) => {
  runApp(const BaseApp()
  )});

}
TextEditingController emailController = TextEditingController();

class BaseApp extends StatelessWidget {
  const BaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: SignUp(),
      initialRoute: 'signUp',
      routes: {
        // When navigating to the "homeScreen" route, build the HomeScreen widget.
        'signUp': (context) => const SignUp(),
        // When navigating to the "secondScreen" route, build the SecondScreen widget.
        'offerSearch': (context) => const OfferSearch(),
      },
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUp createState() => _SignUp();
}
class _SignUp extends State<SignUp>{

  @override
  initState() {
   _checkToken();
    // super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: const Text('CredXp'),
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.center,
                  width: 300,
                  child: const Text(
                      "Please enter your mobile number. Don't worry, we also hate spam calls.",
                    style: TextStyle(fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
                  )
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  height: 40,
                  width: 300,
                  child: TextField(
                    controller: emailController,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ]),
                ),
              ),
              Builder(
                builder: (context) => TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.blue)),
                child: const Text(
                  "Next",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => {sendOtp(context)},
              ),
              )
            ],
          ),
        ));
  }

  sendOtp(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:9020/isUserRegistered'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'loginId': emailController.text,
        'countryCode': '91',
        'loginType': 'MOBILE'
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print(response.body.toString());
      _showToast(context, jsonResponse['message'] + emailController.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyOtp(loginId:emailController.text, isUserRegStatusCode: jsonResponse['statusCode'])),
      );
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
  Future<String?> checkToken() async{
    return await UserSecureStorage.getAuth() ?? '';
  }
  void _checkToken() async {
    var token;
    await checkToken().then((value) => {token = value, print(value)});
    if (token != null || !token.isEmpty) {
      Future.delayed(Duration.zero, () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const OfferSearch(),
          ),
        );
      });
    }
  }


}
