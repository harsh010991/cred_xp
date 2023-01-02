import 'dart:convert';

import 'package:cred_xp/item_list.dart';
import 'package:cred_xp/secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;

class VerifyOtp extends StatelessWidget {
  VerifyOtp({super.key, required this.loginId});

  final String loginId;
  var secureStorage = SecureStorage();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
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
                      child: Text(
                          "Please enter OTP to verify mobile : " + loginId)),
                  Container(
                    child: OTPTextField(
                      length: 4,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 50,
                      style: const TextStyle(fontSize: 17),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (pin) {
                        print("Completed : " + pin);
                      },
                    ),
                    padding: const EdgeInsets.all(30),
                    // child: SizedBox(
                    //   height: 40,
                    //   width: 300,
                    //   child: TextField(
                    //       decoration:
                    //       InputDecoration(border: OutlineInputBorder()),
                    //       keyboardType: TextInputType.phone,
                    //       inputFormatters: [
                    //         FilteringTextInputFormatter.digitsOnly
                    //       ]),
                    // ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.blue)),
                    child: const Text(
                      "Next",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => {verifyOtp(context)},
                  )
                ],
              ),
            )));
  }

  verifyOtp(BuildContext context) async {
    final response = await http.get(
        Uri.parse("https://run.mocky.io/v3/cfbde6a0-715b-40b4-81b3-6d9fe428f08a"));

    print(response);
    if (response.statusCode == 200) {
      print(response.body.toString());
      secureStorage.updateToken(jsonDecode(response.body)['auth']);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const CreditCardList()),
      );
    } else {
      _showToast(context, 'Failed to verify OTP. Please try again!!');
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
}
