import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_database/firebase_database.dart';


final StationsProvider = FutureProvider<Map>((ref) async {
  final databaseReference = FirebaseDatabase.instance.ref("stations");
  final event = await databaseReference.once();
  Map<String, dynamic> data={};
  if(event.snapshot.value!=null){ data = jsonDecode(jsonEncode(event.snapshot.value))  as Map<String, dynamic>;}
  return data;
});