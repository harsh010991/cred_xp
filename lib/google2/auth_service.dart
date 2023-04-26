import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../item_list.dart';
import '../offers_search.dart';
import 'home_page2.dart';
import 'login_page2.dart';

class AuthService{
  // Trigger the authentication flow
  final GoogleSignIn googleUser =  GoogleSignIn(scopes: <String>["email"]);
  //Determine if the user is authenticated.
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var metadata = snapshot.data!.metadata;
            if (metadata.creationTime.toString().split(".")[0] ==
                (metadata.lastSignInTime.toString().split("."))[0]) {
              return CreditCardList(
                  email: snapshot.data.email, accessToken: "");
            }
            return OfferSearch(
                email: snapshot.data.email, accessToken: "");
          } else {
            return const LoginPage2();
          }
        });
  }

  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? gUser = await googleUser.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await gUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    try {
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }catch(e){
      print(e.toString());
    }
  }

  signOut() async{
    await googleUser.signOut();
    await FirebaseAuth.instance.signOut();
  }

}