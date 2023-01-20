import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/auth_provider.dart';

class bookmarkStations extends ConsumerWidget {
  @override
  Map bookmarks={};
  String UiD='';
  final databaseReference = FirebaseDatabase.instance.ref("stations");
  Future<void> _onPressed(String num)async{
    await databaseReference.child(num).remove();
  }
  Widget build(BuildContext context, watch) {
    return Consumer(builder: (BuildContext context, ref, _){
      final _auth = ref.watch(authenticationProvider);
      UiD=_auth.getUser();
      return Container(
        padding: EdgeInsets.all(15),
        child: Center(
            child: StreamBuilder(
                stream: databaseReference.child('${UiD}').onValue,
                builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){

                  if(!snapshot.hasData){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else{
                    if(snapshot.data!.snapshot.value==null){
                      return Center(
                        child: Text("No Bookmarks to display!", style: TextStyle(fontFamily: 'latob', fontSize: 32), textAlign: TextAlign.center,),
                      );
                    }
                    else{
                      Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                      Map uidmap=map;
                      List<dynamic> list = [];
                      list.clear();
                      list=uidmap.values.toList();
                      return ListView.builder(
                          padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
                          itemCount:list.length,
                          itemBuilder:(context, index) {
                            Map perTrain = list[index];
                            return Container(
                              height: 130,
                              child: Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(padding: EdgeInsets.fromLTRB(0,0,0,0)),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Text(("Name: ${perTrain["name"]}"), style: TextStyle(fontSize: 13, fontFamily: 'latob'),),
                                        Text(("Station Code: ${perTrain["code"]}"), style: TextStyle(fontSize: 13, fontFamily: 'latob'),),
                                        Text(("State: ${perTrain["state"]}"), style: TextStyle(fontSize: 13, fontFamily: 'latob'),),
                                        Text(("Longitude: ${perTrain["longitude"]}"), style: TextStyle(fontSize: 13, fontFamily: 'latob'),),
                                        Text(("Latitude: ${perTrain["latitude"]}"), style: TextStyle(fontSize: 13, fontFamily: 'latob'),)
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: (){_onPressed('${UiD}/${perTrain['code']}');},
                                      child:
                                      Icon(
                                        Icons.delete_forever,
                                        color: Colors.white,
                                        size: 25,
                                      ),


                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        shape: CircleBorder(),
                                        //padding: EdgeInsets.fromLTRB(9, 8, 8, 11)
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.fromLTRB(0,0,0,0))
                                  ],
                                ),
                              ),
                            );
                          } );
                    }

                  };}
            )
        ),
      );


    }
    );
  }
}


