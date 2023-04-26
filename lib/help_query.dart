import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HelpQuery extends StatelessWidget {
  final TextEditingController textarea = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String email;

  HelpQuery({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('CredRp'),
            ),
            body: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Contact Us',
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 30,
                  ),
              Form(
                key: _formKey,
                  child:TextFormField(
                    controller: textarea,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '*Required';
                      }
                      return null;
                    },
                    maxLines: 5,
                    decoration: const InputDecoration(
                        hintText: "Enter Query..",
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 1, color: Colors.redAccent))),
                  )),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print(textarea.text);
                      if (_formKey.currentState!.validate()) {
                        final response = await sendEmail(
                            textarea.value.text, email);
                        if (response == 200) {
                          textarea.clear();
                          _showToast(context, "Message Sent!");
                        }
                      }
                    },
                    child: const Text(
                      "Send",
                      style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(140, 50),
                        backgroundColor: Colors.blue),
                  ),
                ],
              ),
            )));
  }

  Future sendEmail(String message, String email) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_efxfouc';
    const templateId = 'template_9o21w8o';
    const userId = '4sTzwjlAyQkdOc1yH';
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json','origin':'android'},
        //This line makes sure it works for all platforms.
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'from_email': email,
            'message': message,
            // 'from_name':'abc',
            // 'to_name':'harsh'
          }
        }));
    return response.statusCode;
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