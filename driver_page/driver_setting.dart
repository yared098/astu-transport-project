// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, prefer_final_fields

import 'package:astu_tms/account_setting/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  TextEditingController _name_controler = TextEditingController();
  TextEditingController _mobile_controler = TextEditingController();
  TextEditingController _station_name_controler = TextEditingController();
  TextEditingController _address_controler = TextEditingController();
  TextEditingController _car_capacity_controler = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  var current_email = FirebaseAuth.instance.currentUser!.email;
  var current_uuid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext contect) =>
                                  login_page())));
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 250.0,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(130),
                            bottomRight: Radius.circular(1))),
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: <Widget>[
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.arrow_back)),
                                Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: Text('Profile Setting ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0,
                                          fontFamily: 'sans-serif-light',
                                          color: Colors.black)),
                                )
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Stack(fit: StackFit.loose, children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                    width: 100.0,
                                    height: 100.0,
                                    // ignore: prefer_const_constructors
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: ExactAssetImage(
                                            'assets/image2.jpeg'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 90.0, right: 100.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 25.0,
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                )),
                          ]),
                        )
                      ],
                    ),
                  ),
                  my_files("Drivers", current_uuid),
                  //show_my_setting()
                ],
              ),
            ],
          ),
        ));
  }

  Container show_my_setting(Map<String, dynamic> data) {
    return Container(
      color: Color(0xffFFFFFF),
      child: Padding(
        padding: EdgeInsets.only(bottom: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'Parsonal Information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _status ? _getEditIcon() : Container(),
                      ],
                    )
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'Name',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        controller: _name_controler,
                        decoration: const InputDecoration(
                          hintText: "Enter Your Name",
                        ),
                        enabled: !_status,
                        autofocus: !_status,
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'Car Capacity',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        controller: _car_capacity_controler,
                        decoration:
                            const InputDecoration(hintText: "Car Capacity"),
                        enabled: !_status,
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'Mobile',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        controller: _mobile_controler,
                        decoration: const InputDecoration(
                            hintText: "Enter Mobile Number"),
                        enabled: !_status,
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          'Station name ',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          'Address ',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                )),
            Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: TextField(
                          controller: _station_name_controler,
                          decoration: const InputDecoration(
                              hintText: "Enter station name "),
                          enabled: !_status,
                        ),
                      ),
                      flex: 2,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _address_controler,
                        decoration: const InputDecoration(
                            hintText: "Enter your address"),
                        enabled: !_status,
                      ),
                      flex: 2,
                    ),
                  ],
                )),
            !_status ? _getActionButtons(current_uuid) : Container(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons(String current_uuid) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                    Map<String, dynamic> update_mystatus = {
                      "name": _name_controler.text,
                      "address": _address_controler.text,
                      "station_name": _station_name_controler.text,
                      "car_capacity": _car_capacity_controler.text
                    };
                    var snk_bar = SnackBar(
                      content: Text("successfully update your satatus"),
                    );
                    FirebaseFirestore.instance
                        .collection("Drivers")
                        .doc(current_uuid)
                        .update(update_mystatus)
                        .then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(snk_bar));
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> my_files(
      String database_location, String current_uuid) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection(database_location)
          .doc(current_uuid)
          .get(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          print(snapshot);
          var data = snapshot.data!.data();
          var value = data?['name'];
          _mobile_controler.text = data!["phone"].toString();
          _name_controler.text = data['name'].toString();
          _station_name_controler.text = data["station_name"].toString();
          _address_controler.text = data["address"].toString();
          _car_capacity_controler.text = data["car_capacity"].toString();
          //var car_seat_number = int.parse(data["car_capacity"]);
          //var reserved_seat = int.parse(data["reserved_seats"]);
          return show_my_setting(data);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
