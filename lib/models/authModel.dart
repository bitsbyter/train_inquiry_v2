import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static String ID="";
  GoogleSignInAccount? usr;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email']
  );
  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<void> signInWithPhoneNumber(String phno, BuildContext context) async {
    try{
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${'+91'+phno}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {},
        codeSent: (String verificationId, int? resendToken) {
          Authentication.ID=verificationId;
          Navigator.pushNamedAndRemoveUntil(context, '/third', (route) => false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("OK"))
          ],
        ),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    usr=googleUser;
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,);
    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("OK"))
          ],
        ),
      );
    }
  }

  Future<void> verifyCode(BuildContext context, String Pin) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: Authentication.ID, smsCode: Pin);
      await _auth.signInWithCredential(credential);

    } catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error Occured'),
          content: Text(e.toString()),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("OK"))
          ],
        ),
      );
    }
  }

  String getUser(){
    final User usr=_auth.currentUser!;
    final uid=usr.uid;
    return uid;
  }

  Future<void> signOut() async {
    GoogleSignInAccount? accountt;
    await _auth.signOut();
    bool usrstatus=await _googleSignIn.isSignedIn();
    if(usrstatus){await _googleSignIn;}
  }


}