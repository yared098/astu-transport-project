// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, use_key_in_widget_constructors, must_be_immutable, camel_case_types, avoid_unnecessary_containers, deprecated_member_use

import 'package:astu_tms/passenger_pages/booking.dart';
import 'package:astu_tms/passenger_pages/live_booking.dart';
import 'package:astu_tms/passenger_pages/setting_passenger.dart';
import 'package:astu_tms/passenger_pages/tour_histort.dart';
import 'package:astu_tms/search_page/search_diver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class test_passenger_page extends StatelessWidget {
  String email;

  test_passenger_page({required this.email});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // Remove the debug banner
      body: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current_index = 0;
  void on_bottom_click(int index) {
    setState(() {
      _current_index = index;
    });
  }

  final List _children = [
    passenger_live_booking(Colors.white),
    passenger_booking(Colors.deepOrange),
    passenger_tour_history(Colors.green)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: setting_passengers(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => search_driver_page()));
              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.nature,
                color: Colors.white,
                size: 30,
              ))
        ],
        elevation: 0,
        backgroundColor: Colors.blue,
        title: const Text(
          ' Passenger page',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: _children[_current_index], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: on_bottom_click, // new
        currentIndex: _current_index, // new
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.live_help_outlined),
            title: Text('live'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('booking'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('history'))
        ],
      ),
    );
  }

  profile_drawer(String my_email) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
              child: CircleAvatar(
            radius: 50,
            child: Icon(Icons.ac_unit_outlined),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text("name"), Text("yared")],
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Passengers")
                  .where("email", isEqualTo: my_email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  DocumentSnapshot data = snapshot.data!.docs[0];
                  return Container(
                    height: 200,
                    margin: EdgeInsets.all(4),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "phone",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(data["phone"])
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "phone",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(data["phone"])
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'User Name',
                                  hintText: 'Enter Your Name',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("update status"),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text("no file is found"),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
