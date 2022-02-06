// ignore_for_file: camel_case_types, prefer_final_fields, non_constant_identifier_names, unused_local_variable, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class account_checking extends StatelessWidget {
  account_checking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var current_email = _auth.currentUser!.email;
    var current_uu_id = _auth.currentUser!.uid;
    return MaterialApp(
      home: my_files(current_uu_id),
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> my_files(
      String current_uuid) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(current_uuid)
          .get(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          var data = snapshot.data!.data();
          var catagory = data!["catagory"];
          if (catagory == "Drivers") {
          } else if (catagory == "Passengers") {
            print("passenger");
          } else {
            print("Officers");
          }
        } else {
          return Center(child: Text("nmnmm"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  // Future<String> get_data(current_uu_id) async {
  //   var collection = FirebaseFirestore.instance.collection('users');
  //   var docSnapshot = await collection.doc(current_uu_id).get().then((value) => print(value))

  //   if (docSnapshot.exists) {
  //     Map<String, dynamic>? data = docSnapshot.data();
  //     var value = data?['name'].toString();

  //     return value.toString();
  //   } else {
  //     return "no account";
  //   }
  // }
}
