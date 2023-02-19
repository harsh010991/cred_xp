import 'dart:convert';

import 'package:cred_xp/item_list.dart';
import 'package:cred_xp/offers_search.dart';
import 'package:cred_xp/secure_storage.dart';
import 'package:cred_xp/storage/UserSecureStorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;

class VerifyOtp extends StatelessWidget {
  VerifyOtp(
      {super.key, required this.loginId, required this.isUserRegStatusCode});

  final String loginId;
  final int isUserRegStatusCode;
  late String otp;
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      fieldWidth: 50,
                      style: const TextStyle(fontSize: 17),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.underline,
                      onCompleted: (otp) {
                        print("Completed : " + otp);
                        this.otp = otp;
                        verifyOtp(context, loginId, isUserRegStatusCode, otp);
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
                    onPressed: () =>
                    {
                      verifyOtp(context, loginId, isUserRegStatusCode, otp)
                    },
                  )
                ],
              ),
            )));
  }

  verifyOtp(BuildContext context, String loginId,
      int isUserRegStatusCode, String otp) async {
    late String otpType;
    if (isUserRegStatusCode == 4200) {
      otpType = "LOGIN";
    }
    else if (isUserRegStatusCode == 4404) {
      otpType = "SIGN_UP";
    }
    final response = await http.post(
      Uri.parse('http://10.0.2.2:9020/verify/otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'loginId': loginId,
        'countryCode': '91',
        'otpType': otpType,
        'otp': otp
      }),
    );
    if (response.statusCode == 200) {
      print(response.body.toString());
      await UserSecureStorage.setAuth(
          jsonDecode(response.body)['data']['token']);
      if (otpType == "SIGN_UP") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CreditCardList()),
        );
      }
      else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const OfferSearch()),
        );
      }
    }
      else {
      _showToast(context, 'Failed to verify OTP. Please try again!!');
    }
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
