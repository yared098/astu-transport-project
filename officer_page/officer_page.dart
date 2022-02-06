// ignore_for_file: override_on_non_overriding_member, non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, duplicate_ignore, must_be_immutable, camel_case_types, use_key_in_widget_constructors, unnecessary_string_interpolations, unused_local_variable, avoid_returning_null_for_void

import 'package:astu_tms/officer_page/setting_officer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class officer_page extends StatelessWidget {
  String email;
  officer_page({required this.email});

  @override
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _email_controler = TextEditingController();
  final TextEditingController _phone_controler = TextEditingController();
  final TextEditingController _star_destinetion = TextEditingController();
  final TextEditingController _car_number = TextEditingController();

  final CollectionReference _add_drivers =
      FirebaseFirestore.instance.collection('Drivers');

  Future<void> _createOrUpdate(BuildContext context,
      [DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'].toString();
      _phone_controler.text = documentSnapshot['phone'].toString();
      _email_controler.text = documentSnapshot['email'].toString();
      _star_destinetion.text = documentSnapshot['start'].toString();
      _car_number.text = documentSnapshot['end'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _email_controler,
                  decoration: const InputDecoration(
                    labelText: 'email',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _phone_controler,
                  decoration: const InputDecoration(
                    labelText: 'phone',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _star_destinetion,
                  decoration: const InputDecoration(
                    labelText: 'start destinetion',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _car_number,
                  decoration: const InputDecoration(
                    labelText: 'end destinetion ',
                  ),
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? name = _nameController.text;
                    final String? email = _email_controler.text;
                    final String? phone = _phone_controler.text;
                    final String? car_id = _star_destinetion.text;
                    final String? car_number = _car_number.text;
                    if (name != null &&
                        email != null &&
                        car_number != null &&
                        car_id != null) {
                      if (action == 'create') {
                        await _add_drivers.add(
                          {
                            "name": name,
                            "email": email,
                            "phone": phone,
                            "car_id": car_id,
                            "car_number": car_number
                          },
                        );
                      }

                      if (action == 'update') {
                        // Update the driver ststus
                        await _add_drivers.doc(documentSnapshot!.id).update(
                          {
                            //"name": name,
                            // "email": email,
                            // "phone": phone,
                            "start": car_id,
                            "end": car_number
                          },
                        );
                      }

                      _nameController.text = '';
                      _email_controler.text = '';
                      _phone_controler.text = '';
                      _star_destinetion.text = '';
                      _car_number.text = '';

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _deleteProduct(BuildContext context, String productId,
      DocumentSnapshot<Object?> documentSnapshot) async {
    await _add_drivers
        .doc(productId)
        .update({"end": "null", "start": "null", "station_name": "null"});
    DocumentReference<Map<String, dynamic>> _driver_history =
        FirebaseFirestore.instance.collection("Driver_history").doc(productId);
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    _driver_history.set({
      "start": documentSnapshot["start"],
      "end": documentSnapshot["end"],
      "uuid": productId,
      "drive_name": documentSnapshot["name"],
      "date": date,
      "officer_name": "null",
      "officer_id": "null"
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(' successfully update  star and end destinetion ')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var email = FirebaseAuth.instance.currentUser!.email;
          var uu_id = FirebaseAuth.instance.currentUser!.uid;
        },
      ),
      drawer: setting_officer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: const Text(
          'Officer page ',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          //IconButton(
          // onPressed: () {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (BuildContext ctx) => ()));
          // },
          // icon: Icon(
          //   Icons.logout,
          //   color: Colors.white,
          // ))
        ],
      ),
      body: my_profile_status(),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> show_my_dirver_lists(station_name) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Drivers")
          .where("station_name", isEqualTo: station_name)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return display_driver_info(documentSnapshot, context);
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> my_profile_status() {
    String primery_id = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('Officers')
          .doc('$primery_id')
          .get(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          var data = snapshot.data!.data();
          var value = data!['name'];
          var station_name = data["station_name"]; //
          return show_my_dirver_lists(station_name);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Card display_drivers(
      DocumentSnapshot<Object?> documentSnapshot, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(documentSnapshot['name']),
        subtitle: Text(documentSnapshot['email'].toString()),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _createOrUpdate(context, documentSnapshot)),
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteProduct(
                      context, documentSnapshot.id, documentSnapshot)),
            ],
          ),
        ),
      ),
    );
  }

  Card display_driver_info(
      DocumentSnapshot<Object?> documentSnapshot, BuildContext context) {
    int car_capacity = int.parse(documentSnapshot['car_capacity']);
    int reserved_seats = int.parse(documentSnapshot["reserved_seats"]);
    return Card(
      margin: const EdgeInsets.all(10),
      child: Container(
        margin: EdgeInsets.all(10),
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: car_capacity == reserved_seats ? Colors.pink : Colors.amber,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person),
                  backgroundColor: Colors.white,
                ),
                Text(
                  documentSnapshot['name'],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blue),
                ),
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  radius: 20,
                  child: Text(
                    documentSnapshot['reserved_seats'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  radius: 20,
                  child: Text(
                    documentSnapshot['car_capacity'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "car  id",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(documentSnapshot["card_id"])
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("phone",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text(documentSnapshot["phone"])
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Driver id"),
                Text(documentSnapshot["driver_id"]),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _createOrUpdate(context, documentSnapshot);
                    },
                    child: Text("set schedule")),
                ElevatedButton(
                    onPressed: () {
                      _deleteProduct(
                          context, documentSnapshot.id, documentSnapshot);
                    },
                    child: Text("Enterance ")),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "start",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontSize: 18),
                ),
                Text("addis ababa"),
                Text(
                  "end",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                      fontSize: 18),
                ),
                Text("adama")
              ],
            )
          ],
        ),
      ),
    );
  }
}

/////////////// display your profile drawer page
Container my_profile_display_indrawer(String email) {
  return Container(
    child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Officers")
          .where("email", isEqualTo: email)
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          doc_d["name"],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Address",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(doc_d['address']),
                            Text(
                              "phone",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(doc_d['phone'])
                          ],
                        )
                      ],
                    ),
                    Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text("*station name"),
                        subtitle: Text(doc_d['station_name'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              // IconButton(
                              //     icon: const Icon(Icons.edit),
                              //     onPressed: () => null),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text("duty"),
                        subtitle: Text(doc_d['duty'].toString()),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              // IconButton(
                              //     icon: const Icon(Icons.edit),
                              //     onPressed: () => null),
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
