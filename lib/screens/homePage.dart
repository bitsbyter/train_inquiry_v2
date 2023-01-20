import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../provider/auth_provider.dart';
import 'trainSearch.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';

final _formKey = GlobalKey<FormState>();

class SecondRoute extends StatefulWidget{
  _SecondRoute createState() => _SecondRoute();
}

class _SecondRoute extends State<SecondRoute> {
  String UiD='';
  int q=1;
  String url='https://firebasestorage.googleapis.com/v0/b/train-inquiry-61c3e.appspot.com/o/images%2Floading-gif.gif?alt=media&token=b432a3ba-84b3-432e-9e04-204cf46e1e31';
  final dbreference = FirebaseDatabase.instance.ref("profilePictures");
  TextEditingController fromStationCode = TextEditingController();
  TextEditingController toStationCode = TextEditingController();

  String newimgurl='';

  Future<void> insertData(String uid, String URL)async{
    DatabaseEvent event = await dbreference.once();
    print(event.snapshot.value);
    Map<String, dynamic> data={};
    if(event.snapshot.value!=null){ data = jsonDecode(jsonEncode(event.snapshot.value))  as Map<String, dynamic>;}

    if(data["${UiD}"]==null){
      dbreference.child('${UiD}').set({
        "url":URL
      });
    }
    else{
      await dbreference.child('${UiD}').update({
        "url":URL,
      });
    }
  }

  Future<void> changeImg()async{
    DatabaseEvent event = await dbreference.once();
    Map<String, dynamic> data={};
    Map<String, dynamic> dataURL={};
    print(event.snapshot.value);
    if(event.snapshot.value!=null){ data = jsonDecode(jsonEncode(event.snapshot.value))  as Map<String, dynamic>;}
    if(data['${UiD}']!=null){ dataURL = data['${UiD}'];
    setState(() {
      url=dataURL["url"];
    });}
    else{
    setState(() {
      url="https://firebasestorage.googleapis.com/v0/b/train-inquiry-61c3e.appspot.com/o/images%2Fdef.png?alt=media&token=9bd33d8c-7620-49b6-b76c-c8424a95d22f";
    });}
  }

  @override
  void dispose() {
    fromStationCode.dispose();
    toStationCode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context, ref, _){
      final _auth = ref.watch(authenticationProvider);

      UiD=_auth.getUser();
      while(q==1){
        changeImg();
        q=0;
      };

      Future<void> _onPressedFunction() async {
        q=0;
        await _auth.signOut();
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }

      Future<void> uid()async{
        UiD=_auth.getUser();
      }

      Future<void> _onPressed() async {
        Navigator.pushNamed(context, '/bookmark');
      }
      return Scaffold(
        appBar: AppBar(
          leading: ElevatedButton(onPressed: _onPressedFunction, child: Icon(Icons.logout), style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),),
          title: Text("Train Inquiry", style: TextStyle(fontFamily: 'latob'),),
          backgroundColor: Colors.deepPurple,
            actions: <Widget>[
        Padding(
        padding: EdgeInsets.only(right: 18.0),
          child: GestureDetector(
            onTap: () {_onPressed();},
            child: Icon(
              Icons.bookmark_outlined,
              size: 24.0,
            ),
          )
      ),],
        ),
        body: Container(
            color: Colors.deepPurple,
            child: ListView(
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0)),

                Card(
                  color: Colors.black54,
                  shape: CircleBorder(),
                  elevation: 20,
                  child: ElevatedButton(
                    child: Center(
                      child: Consumer(builder: (BuildContext context, ref, _){
                        return Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage('${url}'),
                                //AssetImage('assets/def.png'),
                                fit: BoxFit.fill
                            ),
                          ));}
                      ),
                    ),
                    onPressed: ()async{
                      ImagePicker img=ImagePicker();
                      XFile? file=await img.pickImage(source: ImageSource.gallery);
                      if(file==null) return;
                      Reference root=FirebaseStorage.instance.ref();
                      Reference imgdir=root.child('images');
                      Reference newimg=imgdir.child('${file?.name}');
                      try{
                        await newimg.putFile(File(file!.path));
                        newimgurl= await newimg.getDownloadURL();
                        print(newimgurl);
                        await uid();
                        print(UiD);
                        await insertData(UiD, newimgurl);
                        int q=1;
                        while(q==1){
                          await changeImg();
                          q=0;
                        };

                      }catch(e){}
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: CircleBorder(),
                    ),
                ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(1, 0, 1, 0),
                  child: Container(
                    padding: const EdgeInsets.all(0.0),
                    color: Colors.green.withOpacity(0),
                    width: 0,
                    height: 25,
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
      );}
    );
  }

  Future RegistrationUser() async{
    Map<String, dynamic> mappeddata = {
      "fromStationCode" : fromStationCode.text,
      "toStationCode" : toStationCode.text,
    };
    var URL = Uri.https('irctc1.p.rapidapi.com', '/api/v2/trainBetweenStations', mappeddata);
    var response = await http.get(URL,  headers: {
      "X-RapidAPI-Key": "bcff567158mshbf2d0064c72a687p186c82jsn0ce9c594a295",
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