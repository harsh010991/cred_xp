import 'package:flutter/material.dart';
import 'sign_up_page.dart';

void main() {
  runApp(CredXpApp());
}

class CredXpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        title: 'CredXp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SignUp(),
      ),
    );
  }
}
