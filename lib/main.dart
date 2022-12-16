import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

final _formKey = GlobalKey<FormState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train Inquiry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeRoute(),
          '/second': (context) => SecondRoute(),
        }
    );
  }
}

final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email']
);

class HomeRoute extends StatefulWidget{
  _HomeRoute createState() => _HomeRoute();
}

class SecondRoute extends StatefulWidget{
  _SecondRoute createState() => _SecondRoute();
}


class _HomeRoute extends State<HomeRoute> {

  GoogleSignInAccount? _currentUser;

  void initState(){
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  Future<void> signIn() async{
    try{
      await _googleSignIn.signIn();
      Future.delayed(Duration(milliseconds: 100), (){
        GoogleSignInAccount? user = _currentUser;
        if(user!=null){
          Navigator.pushNamed(context, "/second");
        };
      });


    } catch(e){
      print('Error signing in $e');
    }}



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  color: Colors.green.withOpacity(0),
                  width: 0,
                  height: 200.0,
                ), //Container
              ),
              RichText(
                textScaleFactor: 3.5,
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: 'Train Inquiry',
                  style: TextStyle(color: Colors.white, fontFamily: 'latob'),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                child: Container(
                  padding: const EdgeInsets.all(0.0),
                  color: Colors.green.withOpacity(0),
                  width: 0,
                  height: 230.0,
                ), //Container
              ),
              ElevatedButton(
                  onPressed: signIn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                        size: 25,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                        child: Container(
                          padding: const EdgeInsets.all(0.0),
                          color: Colors.green.withOpacity(0),
                          width: 10,
                          height: 0,
                        ), //Container
                      ),
                      Text("Sign in", style: TextStyle(fontFamily: 'lato'),),
                    ],
                  ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class _SecondRoute extends State<SecondRoute> {
  GoogleSignInAccount? _currentUser;
  Future<void> signOut() async{
    try{
      await _googleSignIn.disconnect();
      Future.delayed(Duration(milliseconds: 100), (){
        GoogleSignInAccount? user = _currentUser;
        if(user==null){
          Navigator.pushNamed(context, "/");
        };
      });


    } catch(e){
      print('Error signing out $e');
    }}

  TextEditingController fromStationCode = TextEditingController();
  TextEditingController toStationCode = TextEditingController();

  @override
  void dispose() {
    fromStationCode.dispose();
  toStationCode.dispose();
  super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(onPressed: signOut, child: Icon(Icons.logout), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),),
        title: Text("Train Inquiry", style: TextStyle(fontFamily: 'latob'),),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.deepPurple,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
              child: Container(
                padding: const EdgeInsets.all(0.0),
                color: Colors.green.withOpacity(0),
                width: 0,
                height: 110,
              ), //Container
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                color: Colors.black54,
                elevation: 20,
                child:Padding(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[

                          TextFormField(
                            controller: fromStationCode,
                            style: TextStyle(color: Colors.white, fontFamily: 'lato'),
                            decoration:  InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.deepPurple),
                                    borderRadius: BorderRadius.circular(15) ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.deepPurple),),
                                labelText: 'From',
                                labelStyle: TextStyle(color: Colors.white)
                            ),
                            cursorColor: Colors.deepPurple,

                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Enter something";
                              }
                              //if(value.length!=3 || value.length!=4){
                                //return "Enter correct station code";
                              //}
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
                          TextFormField(
                            controller: toStationCode,
                            style: TextStyle(color: Colors.white, fontFamily: 'lato'),
                            decoration:  InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.deepPurple),
                              borderRadius: BorderRadius.circular(15) ),
                                focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.deepPurple),),
                                labelText: 'To',
                                labelStyle: TextStyle(color: Colors.white)
                            ),
                            cursorColor: Colors.deepPurple,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "Enter something";
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                            child: Container(
                              padding: const EdgeInsets.all(0.0),
                              color: Colors.green.withOpacity(0),
                              width: 0,
                              height: 60,
                            ), //Container
                          ),
                          ElevatedButton(onPressed: (){
                            if (_formKey.currentState!.validate()){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Searching for trains")));
                              //Navigator.pushNamed(context, "/trn");
                              RegistrationUser();
                            };

                          }, child: Text("Submit", style: TextStyle(fontFamily: 'lato'),),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),),

                        ],
                      ),
                    ),
                  ), //Container
                ),

              ) //Container
            ),

          ],
        )
      ),
    );
  }

  Future RegistrationUser() async{
    Map<String, dynamic> mappeddata = {
      "fromStationCode" : fromStationCode.text,
      "toStationCode" : toStationCode.text,
    };
    var URL = Uri.https('irctc1.p.rapidapi.com', '/api/v2/trainBetweenStations', mappeddata);
    var response = await http.get(URL,  headers: {
      "X-RapidAPI-Key": "b81d0ee084mshb098e6b41ed9a5fp16b875jsn855312bcfa49",
      "X-RapidAPI-Host": "irctc1.p.rapidapi.com"
    });
    var data = jsonDecode(response.body);
    print("$data");
    Future.delayed(Duration(milliseconds: 100), (){
      if (data["status"]==true){
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ThirdRoute(receivedMap: data,)));}
      if (data["status"]==null){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("API Monthly Limit Reached!")));}
      else if(data["status"]==false){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No trains available between the given stations")));
      }
    });
  }
}

class ThirdRoute extends StatefulWidget{
  Map receivedMap;
  ThirdRoute({required this.receivedMap});
  _ThirdRoute createState() => _ThirdRoute();
}

class _ThirdRoute extends State<ThirdRoute> {
  @override
  Widget build(BuildContext context) {
    List train=widget.receivedMap["data"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Available Trains", style: TextStyle(fontFamily: 'latob'),),
          backgroundColor: Colors.deepPurple
      ),

      body: Container(
        color: Colors.deepPurple,
        child: ListView.builder(
          itemCount: train.length,
          itemBuilder: (context, index){
            Map perTrain = train[index];
            return Padding(
              padding: const EdgeInsets.all(0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0), shadowColor: Colors.transparent),
                  onPressed: ()async{
                    Map<String, dynamic> mapdata = {
                      "trainNo" : perTrain["train_number"],
                    };
                    var URL = Uri.https('irctc1.p.rapidapi.com', '/api/v1/getTrainSchedule', mapdata);
                    var response = await http.get(URL,  headers: {
                      "X-RapidAPI-Key": "b81d0ee084mshb098e6b41ed9a5fp16b875jsn855312bcfa49",
                      "X-RapidAPI-Host": "irctc1.p.rapidapi.com"
                    });
                    var trainSchedule = jsonDecode(response.body);
                    print("$trainSchedule");
                    if(trainSchedule["data"].length==0){
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Train schedule not available")));
                    }
                    else if (trainSchedule["data"].length!=0){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => FourthRoute(receivedMap: trainSchedule,)));
                    }

                    },
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                      child: Card(
                        color: Colors.black54,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 10,
                        child: Container(
                            color: Colors.transparent.withOpacity(0),
                            height: 100,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(("Train No: ${perTrain["train_number"]}"), style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'lato'),),
                                  Text(("Train Name: ${perTrain["train_name"]}"), style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'lato'),)
                                ],
                              ),
                            )

                        ),
                      ),


                  )


              )

            );
          },
        ),
        ),
      );

  }
}

class FourthRoute extends StatefulWidget{
  Map receivedMap;
  FourthRoute({required this.receivedMap});
  _FourthRoute createState() => _FourthRoute();
}

class _FourthRoute extends State<FourthRoute>{
  @override
  Widget build(BuildContext context){
    Map dataa = widget.receivedMap["data"];
    List route = dataa["route"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Train Details", style: TextStyle(fontFamily: 'latob'),),
          backgroundColor: Colors.deepPurple
      ),
      body: Center(
        child: Container(
          child: ListView.builder(
                    itemCount: route.length,
                    itemBuilder: (context, index){
                      Map perStation = route[index];
                      String stp;
                      if(perStation["stop"]==true){
                        stp="Yes";
                      }
                      else{
                        stp="No";
                      };
                      return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                                child: Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  elevation: 10,
                                  child: Container(
                                      color: Colors.transparent.withOpacity(0),
                                      height: 200,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Text(("Day: ${perStation["day"]}"), style: TextStyle(fontSize: 20, fontFamily: 'lato'),),
                                              Text(("Distance from Source: ${perStation["distance_from_source"]} km"), style: TextStyle(fontSize: 20, fontFamily: 'lato'),),
                                              Text(("Station Name: ${perStation["station_name"]}"), style: TextStyle(fontSize: 20, fontFamily: 'lato'),),
                                              Text(("Station Code: ${perStation["station_code"]}"), style: TextStyle(fontSize: 20, fontFamily: 'lato'),),
                                              Text(("Platform No: ${perStation["platform_number"]}"), style: TextStyle(fontSize: 20, fontFamily: 'lato'),),
                                              Text(("Will train stop at this station? : $stp"), style: TextStyle(fontSize: 20, fontFamily: 'lato'),),
                                            ],
                                          ),
                                        ),
                                      )

                                  ),
                                ),


                              );
                              }


                          )

                      )
                  ),
                );

  }

}

