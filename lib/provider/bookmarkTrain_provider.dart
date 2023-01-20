import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';


final TrainsProvider = FutureProvider<Map>((ref) async {
  Map<String, dynamic> data={};
  Map<String, dynamic> temptdata={};

  final databaseReference = FirebaseDatabase.instance.ref("trains");
  DatabaseEvent event = await databaseReference.once();
  if(event.snapshot.value!=null){ data = jsonDecode(jsonEncode(event.snapshot.value))  as Map<String, dynamic>;}
  Stream<DatabaseEvent> stream = await databaseReference.onValue;
  await stream.listen((DatabaseEvent event) {
    print('Event Type: ${event.type}'); // DatabaseEventType.value;
    print('Snapshot: ${event.snapshot.value}');
    //if(event.snapshot.value!=null){ temptdata = jsonDecode(jsonEncode(event.snapshot.value))  as Map<String, dynamic>;
    data = jsonDecode(jsonEncode(event.snapshot.value))  as Map<String, dynamic>;// DataSnapshot
  });
  Future.delayed(Duration(milliseconds: 1000), ()async{
    data={};
  });
  //data=temptdata;
  return data;
});

final databaseProvider = StreamProvider<DatabaseEvent>((ref) {
return FirebaseDatabase.instance.ref('trains').onValue;});