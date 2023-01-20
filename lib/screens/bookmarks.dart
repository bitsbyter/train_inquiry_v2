import 'package:flutter/material.dart';
import 'bookmarkTrains.dart';
import 'bookmarkStations.dart';

class bookmrk extends StatefulWidget {
  const bookmrk({Key? key}) : super(key: key);

  @override
  State<bookmrk> createState() => _bookmrkState();
}

class _bookmrkState extends State<bookmrk> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text("Bookmarks", style: TextStyle(fontFamily: 'latob'),),
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black45,
              tabs: [
                Tab(icon: Icon(Icons.train),
                child: Text("Trains", style: TextStyle(fontFamily: 'lato' ),),),
                Tab(icon: Icon(Icons.home_filled), child: Text("Stations", style: TextStyle(fontFamily: 'lato' ),),)
              ],
            ),
          ),
          body: TabBarView(
            children: [
              bookmarkTrains(),
              bookmarkStations(),
            ],
          ),
        ),
      );
  }

}
