import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:train_inquiry/provider/auth_provider.dart';

final _Key = GlobalKey<FormState>();

class HomeRoute extends StatefulWidget{
  static const routename = '/';
  _HomeRoute createState() => _HomeRoute();
}

class _HomeRoute extends State<HomeRoute> {
  String phno='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, _) {

        final _auth = ref.watch(authenticationProvider);

        Future<void> _loginWithGoogle() async {
          await _auth.signInWithGoogle(context).whenComplete(() =>
              _auth.authStateChange.listen((event) async {
                if (event == null) {}
                if (event!=null){Navigator.pushNamedAndRemoveUntil(context, '/second', (route) => false);}
              }));
        }

        Future<void> _onPressedFunction() async {
          if (!_Key.currentState!.validate()) {
            return;
          }
          await _auth.signInWithPhoneNumber(
              phno, context)
              .whenComplete(
                  () =>
                  _auth.authStateChange.listen((event) async {
                    if (event == null) {
                      return;
                    }
                  }));
        }

        return Container(
          color: Colors.black87,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  RichText(
                    textScaleFactor: 3.5,
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: 'Train Inquiry',
                      style: TextStyle(color: Colors.white,
                          fontFamily: 'latob'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.green.withOpacity(0),
                      width: 0,
                      height: 200.0,
                    ), //Container
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Form(
                      key: _Key,
                      child: Column(
                        children: <Widget>[

                          TextFormField(
                            keyboardType: TextInputType.phone,
                            //controller: phno,
                            onChanged: (value) {
                              phno = value;
                            },
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'lato'),
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple),
                                  //borderRadius: BorderRadius.circular(15)
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepPurple),),
                                labelText: 'Enter Phone Number',
                                labelStyle: TextStyle(color: Colors.white)
                            ),
                            cursorColor: Colors.deepPurple,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter something";
                              }
                              if (value.length != 10) {
                                return "Enter correct Phone Number";
                              }
                              //if(!RegExp("^[A-Z]+[A-Z]+[A-Z]").hasMatch(value)){
                              //return 'Please a valid Station Code';
                              //}
                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                            child: Container(
                              padding: const EdgeInsets.all(0.0),
                              color: Colors.green.withOpacity(0),
                              width: 0,
                              height: 45,
                            ), //Container
                          ),

                          ElevatedButton(onPressed: (){_onPressedFunction();},
                            child: Container(
                                width: 300,
                                height: 50,
                                child: Center(child: Text("Submit",
                                  style: TextStyle(fontFamily: 'lato'),))),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple),),

                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.fromLTRB(35, 35, 35, 15),
                    child: Divider(
                      thickness: 4,
                    ),
                  ),
                  RichText(
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'or',
                      style: TextStyle(color: Colors.white,
                          fontFamily: 'latob'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.green.withOpacity(0),
                      width: 0,
                      height: 15,
                    ), //Container
                  ),

                  ElevatedButton(
                    onPressed: _loginWithGoogle,
                    child:
                    Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                      size: 25,
                    ),

                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: CircleBorder(),
                        padding: EdgeInsets.fromLTRB(9, 8, 8, 11)
                    ),
                  ),


                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}