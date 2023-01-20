import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import '../provider/auth_provider.dart';


class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String Pin='';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Consumer(builder: (context, ref, _){
        final _authh = ref.watch(authenticationProvider);

        Future<void> _onPressedFunction() async {
          await _authh.verifyCode(context, Pin)
              .whenComplete(
                  () =>
                  _authh.authStateChange.listen((event) async {
                    if (event == null) {
                      return;
                    }
                    if (event!=null){Navigator.pushNamedAndRemoveUntil(context, '/second', (route) => false);}
                  }));
        }

        return Container(
          color: Colors.black87,
          child: Container(

            margin: EdgeInsets.fromLTRB(25,0,25,0),
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img1.png',
                    width: 200,
                    height: 200,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.green.withOpacity(0),
                      width: 0,
                      height: 80,
                    ), //Container
                  ),
                  Text(
                    "Phone Verification",
                    style: TextStyle(fontSize: 40, fontFamily: 'latob', color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.green.withOpacity(0),
                      width: 0,
                      height: 10,
                    ), //Container
                  ),
                  Text(
                    "Please enter OTP to continue",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'lato',
                        color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.green.withOpacity(0),
                      width: 0,
                      height: 20,
                    ), //Container
                  ),
                  Pinput(
                    length: 6,
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'latob'),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    focusedPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'latob'),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    submittedPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'latob'),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onCompleted: (pin) => Pin=pin,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      color: Colors.green.withOpacity(0),
                      width: 0,
                      height: 30,
                    ), //Container
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          _onPressedFunction();
                        },
                        child: Text("Verify Phone Number")),
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/');
                          },
                          child: Text(
                            "Edit Phone Number ?",
                            style: TextStyle(color: Colors.white, fontFamily: 'lato', fontSize: 12),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        );}
      ),
    );
  }
}
