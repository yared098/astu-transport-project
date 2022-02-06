// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, camel_case_types, deprecated_member_use, prefer_final_fields, non_constant_identifier_names, unused_local_variable
import 'package:astu_tms/account_setting/login_page.dart';
import 'package:astu_tms/officer_page/officer_page.dart';
import 'package:astu_tms/driver_page/test_page_driver.dart';
import 'package:astu_tms/passenger_pages/test_passenger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class sign_up_page extends StatefulWidget {
  const sign_up_page({Key? key}) : super(key: key);

  @override
  _sign_up_pageState createState() => _sign_up_pageState();
}

class _sign_up_pageState extends State<sign_up_page> {
  bool valuefirst = false;
  bool valuesecond = false;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController _emailcontroler = TextEditingController();
  TextEditingController _passwordcontroler = TextEditingController();
  TextEditingController _fullname = TextEditingController();
  TextEditingController _phone = TextEditingController();

  bool driver = false;
  bool passenger = false;
  bool officer = false;
  late String catagort_type = "null";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "         Login Page",
          style: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _emailcontroler,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as rediet@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: _passwordcontroler,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.vpn_key),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.vpn_key),
                    labelText: 'Password again',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: _fullname,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    labelText: 'full name',
                    hintText: 'Enter full name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                controller: _phone,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                    labelText: 'phone',
                    hintText: 'Enter phone number'),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text("choose your position"),
            Row(children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Text(
                'Driver : ',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              Checkbox(
                value: driver,
                onChanged: (bool? value) {
                  setState(() {
                    driver = value!;
                    catagort_type = "Drivers";
                  });
                },
              ),
              Text(
                'Passenger : ',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              Checkbox(
                value: passenger,
                onChanged: (bool? value) {
                  setState(() {
                    passenger = value!;
                    catagort_type = "Passengers";
                  });
                },
              ),
              Text(
                'Officer : ',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              Checkbox(
                value: officer,
                onChanged: (bool? value) {
                  setState(() {
                    officer = value!;
                    catagort_type = "Officers";
                  });
                },
              ),
            ]),
            FlatButton(
              onPressed: () {},
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async {
                  try {
                    if (catagort_type != "null") {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: _emailcontroler.text,
                              password: _passwordcontroler.text)
                          .then((value) =>
                              add_data(catagort_type, value.user!.uid));
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                    } else if (e.code == 'email-already-in-use') {}
                  } catch (e) {}
                },
                child: Text(
                  'sign up',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 60,
            ),
            GestureDetector(
              child: Text('if u have account?  login'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => login_page()));
              },
            )
          ],
        ),
      ),
    );
  }

  add_data(String catagory, String uuid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uuid)
        .set({}).then((userInfoValue) {});

    CollectionReference add_file =
        FirebaseFirestore.instance.collection(catagory);
    Map<String, dynamic> my_map = {
      "name": _fullname.text,
      "phone": _phone.text,
      "email": _emailcontroler.text,
    };
    Map<String, dynamic> account = {
      "name": "null",
      "address": "null",
      "age": "null",
      "phone": "null",
      "email": "null",
      "gender": "male",
      "berthdate": "null"
    };
    Map<String, dynamic> account_officer = {
      "uuid": uuid,
      "name": _fullname.text,
      "address": "Ethiopia",
      "age": "24",
      "phone": _phone.text,
      "email": _emailcontroler.text,
      "gender": "male",
      "berthdate": "null",
      "duty": "null",
      "station_name": "null",
      "account_type": "officer"
    };
    Map<String, dynamic> account_driver = {
      "uuid": uuid,
      "name": _fullname.text,
      "address": "Ethiopia",
      "age": "25",
      "phone": _phone.text,
      "email": _emailcontroler.text,
      "gender": "male",
      "berthdate": "00-01-2000",
      "driver_id": "1111",
      "qualification": "4",
      "card_id": "null",
      "station_name": "null",
      "car_capacity": "24",
      "amount_seat": "0",
      "account_type": "driver",
      "start": "null",
      "end": "null",
      "reserved_seats": "0"
    };
    Map<String, dynamic> account_passenger = {
      "name": _fullname.text,
      "address": "null",
      "age": "null",
      "phone": _phone.text,
      "email": _emailcontroler.text,
      "gender": "male",
      "berthdate": "null",
      "passenger_id": "null",
      "qualification": "null",
      "account_type": "passenger",
      "uuid": uuid,
      "station_name": "null",
      "balance": "null"
    };
    Map<String, dynamic> user_account = {
      "name": _fullname.text,
      "email": _emailcontroler.text,
      "catagory": catagory,
      "uuid": uuid
    };
    FirebaseFirestore.instance.collection("users").doc(uuid).set(user_account);

    if (catagory == "Officers") {
      FirebaseFirestore.instance
          .collection(catagory)
          .doc(uuid)
          .set(account_officer)
          .then((userInfoValue) => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => officer_page(
                        email: _emailcontroler.text,
                      ))));
    } else if (catagory == "Passengers") {
      FirebaseFirestore.instance
          .collection(catagory)
          .doc(uuid)
          .set(account_passenger)
          .then((userInfoValue) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => test_passenger_page(
                      email: _emailcontroler.text,
                    )));
      });
    } else if (catagory == "Drivers") {
      FirebaseFirestore.instance
          .collection(catagory)
          .doc(uuid)
          .set(account_driver)
          .then((userInfoValue) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => driver_page_test(
                      email: _emailcontroler.text,
                    )));
      });
    }
  }
}
