// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers, camel_case_types, prefer_const_constructors, unused_local_variable, non_constant_identifier_names

import 'package:astu_tms/driver_page/driver_setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class driver_page_test extends StatelessWidget {
  String email;
  driver_page_test({required this.email});

  Future<Container> fetchDoc() async {
    late String name;
    DocumentSnapshot pathData = await FirebaseFirestore.instance
        .collection('Drivers')
        .doc("HEeII6EY5cQAYRgM0ZiCNFWV1JY2")
        .get();

    if (pathData.exists) {
      Map<String, dynamic>? fetchDoc = pathData.data() as Map<String, dynamic>?;

      name = fetchDoc?['name'];
    }
    return Container(
      child: Center(
        child: Text(name),
      ),
    );
  }

  Future getThreshold() async {
    await FirebaseFirestore.instance
        .collection('Drivers')
        .doc('HEeII6EY5cQAYRgM0ZiCNFWV1JY2')
        .get()
        .then((DocumentSnapshot document) {});
  }

  var current_id = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ProfilePage(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfilePage()));
              },
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ))
        ],
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(
          "Driver page",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: my_files(current_id),
    );
  }

  // ignore: non_constant_identifier_names
  GridView custom_gridview(int car_seat_number, int reserved_seat) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20),
        itemCount: car_seat_number,
        itemBuilder: (BuildContext ctx, index) {
          return Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            // color: index <= reserved_seat ? Colors.green : Colors.red,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: index <= reserved_seat ? Colors.black : Colors.yellow,
                borderRadius: BorderRadius.circular(9)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          index <= reserved_seat ? Colors.blue : Colors.red,
                      radius: 20,
                      child: Text("$index"),
                    ),
                    CircleAvatar(
                        radius: 20,
                        child: index <= reserved_seat
                            ? Icon(Icons.person)
                            : Icon(Icons.no_accounts))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    index <= reserved_seat
                        ? Text(
                            "reserved",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        : Text("non   "),
                    CircleAvatar(
                        radius: 20,
                        child: index <= reserved_seat
                            ? Icon(Icons.check_circle)
                            : Text("..."))
                  ],
                ),
              ],
            ),
          );
        });
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> my_files(
      String current_id) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('Drivers')
          .doc(current_id)
          .get(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          var data = snapshot.data!.data();
          var value = data!['name'];
          var ph = data["email"]; //
          var name = data["name"];
          var car_seatnum = ["car_capacity"];
          var car_seat_number = int.parse(data["car_capacity"]);
          var reserved_seat = int.parse(data["reserved_seats"]);
          return custom_gridview(car_seat_number, reserved_seat);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

// Future<String> get_data(current_id) async {
//   var collection = FirebaseFirestore.instance.collection('Drivers');
//   var docSnapshot = await collection.doc(current_id).get();
//   if (docSnapshot.exists) {
//     Map<String, dynamic>? data = docSnapshot.data();
//     var value = data?['name'].toString();
//     // <-- The value you want to retrieve.
//     // Call setState if needed.

//     return value.toString();
//   } else {
//     return "no account";
//   }
// }
