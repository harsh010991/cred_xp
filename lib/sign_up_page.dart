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
    );
  }
}

class SignUp extends StatelessWidget {
  SignUp({super.key});

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
    final response = await http.get(
        Uri.parse("https://mocki.io/v1/262125f4-a49a-4dce-92c0-fbe3c03b3bca"));
    print(response);
    if (response.statusCode == 200) {
      print(response.body.toString());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyOtp(loginId:emailController.text)),
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
}
