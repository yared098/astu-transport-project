// ignore_for_file: prefer_const_constructors, camel_case_types, use_key_in_widget_constructors, must_be_immutable, avoid_unnecessary_containers, non_constant_identifier_names, avoid_returning_null_for_void

import 'package:astu_tms/search_page/search_diver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class passenger_page extends StatelessWidget {
  String email;
  passenger_page({required this.email});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        drawer: Drawer(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: my_profile_display(context, email),
          ),
        ),
        appBar: AppBar(
          title: Text(
            "Passenger",
            style: TextStyle(color: Colors.blue),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext cntext) =>
                              search_driver_page()));
                },
                icon: Icon(Icons.search, color: Colors.blue))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.live_help), label: "Live"),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "booking"),
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Container my_profile_display(BuildContext context, String email_account) {
  return Container(
    child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Passengers")
          .where("email", isEqualTo: email_account)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot doc_d = streamSnapshot.data!.docs[index];
              return Container(
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    CircleAvatar(
                      child: Icon(Icons.person),
                      radius: 50,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Text(doc_d["name"]),
                        SizedBox(
                          width: 20,
                        ),
                        Text(doc_d['email']),
                        Text(doc_d['phone'])
                      ],
                    ),
                    Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(doc_d['name']),
                        subtitle: Text(doc_d['email'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => null),
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => null),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(doc_d['name']),
                        subtitle: Text(doc_d['email'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => null),
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => null),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(doc_d['name']),
                        subtitle: Text(doc_d['email'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => null),
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => null),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
              // ignore: dead_code
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    ),
  );
}
