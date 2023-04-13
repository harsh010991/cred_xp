import 'dart:convert';

import 'package:cred_xp/offers_search.dart';
import 'package:cred_xp/storage/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'verify_otp_page.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => {runApp(const BaseApp())});
}

class BaseApp extends StatelessWidget {
  const BaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(home: SignUp());
  }
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUp createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    _checkToken();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('CredXp'), automaticallyImplyLeading: false),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 300,
                child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autofocus: true,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Enter Mobile Number",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red)),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],

                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w400),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length != 10) return "Mobile Number Required";
                      },
                      // validator: MultiValidator([RequiredValidator(errorText: "Amount Required")]),
                    )),
                //   Form(
                //     key: _formKey,
                //     child:
                //     SizedBox(
                //       width: 300,
                //       height: 60,
                //       child:
                //     TextFormField(
                //       style: TextStyle(height: 0.5),
                //       controller: emailController,
                //       cursorHeight: 10,
                //       decoration:  InputDecoration(
                //           border: OutlineInputBorder(),
                //       ),
                //       keyboardType: TextInputType.phone,
                //       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                //         validator: (value) {
                //           if (value == null || value.isEmpty || value.length <10 ) {
                //             return 'Please enter some text';
                //           }
                //           return null;
                //         }
                //     ),
                // )),
              ),
              Builder(
                builder: (context) => SizedBox(
                    height: 50,
                    width: 300,
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue)),
                      child: const Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => {
                        if (_formKey.currentState!.validate())
                          {sendOtp(context)}
                      },
                    )),
              )
            ],
          ),
        ));
  }

  sendOtp(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://152.70.77.99:8080/isUserRegistered'),
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
        MaterialPageRoute(
            builder: (context) => VerifyOtp(
                loginId: emailController.text,
                isUserRegStatusCode: jsonResponse['statusCode'])),
      );
    } else {
      _showToast(context, 'Failed to send OTP. Please try again!!');
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

  void _checkToken() async {
    await SecureStorage.containsKeyInSecureData('token').then((value) => {
          if (value)
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OfferSearch(
                    email: "",
                    accessToken: "",
                  ),
                ),
              )
            }
        });
  }
}
