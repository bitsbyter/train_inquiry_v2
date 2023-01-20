import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../provider/auth_provider.dart';


class ThirdRoute extends StatefulWidget{
  Map receivedMap;
  ThirdRoute({required this.receivedMap});
  _ThirdRoute createState() => _ThirdRoute();
}

class _ThirdRoute extends State<ThirdRoute> {
  final dbtrain = FirebaseDatabase.instance.ref("trains");
  String UiD='';
  Future<void> _addBookmark(Map _perTrain, String uid) async{
    try{
      DatabaseEvent event = await dbtrain.once();
      print(event.snapshot.value);
      Map<String, dynamic> data={};
      if(event.snapshot.value!=null){ data = jsonDecode(jsonEncode(event.snapshot.value))  as Map<String, dynamic>;}
      if(data["${uid}/${_perTrain["train_number"]}"]==null){
        dbtrain.child('${uid}/${_perTrain["train_number"]}').set({
          "train_number":_perTrain["train_number"],
          "train_name":_perTrain["train_name"],
          "train_origin_station":_perTrain["train_origin_station"],
          "train_destination_station":_perTrain["train_destination_station"],
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Train Bookmarked!", style: TextStyle(fontFamily: 'lato'),)));
      }
      else{
        await dbtrain.child('${uid}/${_perTrain["train_number"]}').update({
          "train_number":_perTrain["train_number"],
          "train_name":_perTrain["train_name"],
          "train_origin_station":_perTrain["train_origin_station"],
          "train_destination_station":_perTrain["train_destination_station"],
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Train Bookmarked!", style: TextStyle(fontFamily: 'lato'),)));
      }
    }catch(e){};
  }
  @override
  Widget build(BuildContext context) {
    List train=widget.receivedMap["data"];
    return Scaffold(
      appBar: AppBar(
          title: Text("Available Trains", style: TextStyle(fontFamily: 'latob'),),
          backgroundColor: Colors.deepPurple
      ),

      body: Consumer(builder: (BuildContext context, ref, _){
        final _auth = ref.watch(authenticationProvider);
        UiD=_auth.getUser();
        return Container(
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
                          "X-RapidAPI-Key": "bcff567158mshbf2d0064c72a687p186c82jsn0ce9c594a295",
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
                            padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                              color: Colors.transparent.withOpacity(0),
                              height: 80,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(("Train No: ${perTrain["train_number"]}"), style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'latob'),),
                                        Text(("Train Name: ${perTrain["train_name"]}"), style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'latob'),)
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: (){_addBookmark(perTrain, UiD);},
                                      child:
                                      Icon(
                                        Icons.bookmark_add_outlined,
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
                                )
                              )

                          ),
                        ),


                      )


                  )

              );
            },
          ),
        );}
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
  String UiD='';
  final dbstation = FirebaseDatabase.instance.ref("stations");
  Future<void> _addBookmark(Map _perTrain, String uid) async{
    try{
      DatabaseEvent event = await dbstation.once();
      print(event.snapshot.value);
      Map<String, dynamic> data={};
      if(event.snapshot.value!=null){ data = jsonDecode(jsonEncode(event.snapshot.value))  as Map<String, dynamic>;}

      if(data["${uid}/${_perTrain["station_code"]}"]==null){
        dbstation.child('${uid}/${_perTrain["station_code"]}').set({
          "code":_perTrain["station_code"],
          "name":_perTrain["station_name"],
          "state":_perTrain["state_name"],
          "latitude":_perTrain["lat"],
          "longitude":_perTrain["lng"],
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Station Bookmarked!", style: TextStyle(fontFamily: 'lato'),)));
      }
      else{
        await dbstation.child('${uid}/${_perTrain["station_code"]}').update({
          "code":_perTrain["station_code"],
          "name":_perTrain["station_name"],
          "state":_perTrain["state_name"],
          "latitude":_perTrain["lat"],
          "longitude":_perTrain["lng"],
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Station Bookmarked!", style: TextStyle(fontFamily: 'lato'),)));
      }
    }catch(e){};
  }
  @override
  Widget build(BuildContext context){
    Map dataa = widget.receivedMap["data"];
    List route = dataa["route"];
    return Scaffold(
      appBar: AppBar(
          title: Text("Train Details", style: TextStyle(fontFamily: 'latob'),),
          backgroundColor: Colors.deepPurple
      ),
      body: Consumer(builder: (BuildContext context, ref, _){
        final _auth = ref.watch(authenticationProvider);
        UiD=_auth.getUser();
        return Center(
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
                              height: 180,
                              padding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(("Day: ${perStation["day"]}"), style: TextStyle(fontSize: 13, fontFamily: 'latob'),),
                                          Text(("Distance from Source: ${perStation["distance_from_source"]} km"), style: TextStyle(fontSize: 13, fontFamily: 'latob'),),
                                          Text(("Station Name: ${perStation["station_name"]}"), style: TextStyle(fontSize: 13, fontFamily: 'latob'),),
                                          Text(("Station Code: ${perStation["station_code"]}"), style: TextStyle(fontSize: 13, fontFamily: 'latob'),),
                                          Text(("Platform No: ${perStation["platform_number"]}"), style: TextStyle(fontSize: 13, fontFamily: 'latob'),),
                                          Text(("Will train stop at this station? : $stp"), style: TextStyle(fontSize: 13, fontFamily: 'latob'),),
                                        ],
                                      ),
                                      ElevatedButton(
                                        onPressed: (){_addBookmark(perStation, UiD);},
                                        child:
                                        Icon(
                                          Icons.bookmark_add_outlined,
                                          color: Colors.white,
                                          size: 25,
                                        ),

                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            shape: CircleBorder(),
                                            //padding: EdgeInsets.fromLTRB(9, 8, 8, 11)
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              )

                          ),
                        ),


                      );
                    }


                )

            )
        );}
      ),
    );

  }

}