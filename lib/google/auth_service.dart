import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import '../item_list.dart';
import '../offers_search.dart';
import '../podo/StorageItem.dart';
import '../storage/SecureStorage.dart';
import 'home_page.dart';
import 'login_page.dart';

class AuthService{

  // Trigger the authentication flow
  final GoogleSignIn googleUser =  GoogleSignIn(scopes: <String>["email"]);
  String accessToken = "";
  //Determine if the user is authenticated.
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          if(snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              var metadata = snapshot.data!.metadata;
              if (metadata.creationTime.toString().split(".")[0] ==
                  (metadata.lastSignInTime.toString().split("."))[0]) {
                return CreditCardList(
                    email: snapshot.data.email, accessToken: accessToken);
              }
              return OfferSearch(
                  email: snapshot.data.email, accessToken: accessToken);
            }
            else {
              return LoginPage();
            }
          }
          return LoginPage();
        });
  }

   signInWithGoogle() async {

     final GoogleSignInAccount? gUser = await googleUser.signIn();

     final GoogleSignInAuthentication gAuth = await gUser!.authentication;
     // Obtain the auth details from the request
       // Create a new credential
       final credential = GoogleAuthProvider.credential(
         accessToken: gAuth.accessToken,
         idToken: gAuth.idToken,
       );
       accessToken = gAuth.accessToken!;
       // Once signed in, return the UserCredential
     try {
       return await FirebaseAuth.instance.signInWithCredential(credential);
     }catch(e){
       print(e.toString());
     }
   }

  //Sign out
  signOut() async{
     await googleUser.disconnect();
     await FirebaseAuth.instance.signOut();
  }
}