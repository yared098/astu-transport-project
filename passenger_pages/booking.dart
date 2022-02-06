// ignore_for_file: prefer_const_constructors, camel_case_types, use_key_in_widget_constructors, unused_element, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class passenger_booking extends StatelessWidget {
  final Color color;

  passenger_booking(this.color);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final CollectionReference _drivers_lists =
      FirebaseFirestore.instance.collection('Drivers');

  Future<void> _createOrUpdate(BuildContext context,
      [DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['reserved_seats'].toString();
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
                // prevent the soft keyboard from covering text fields
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
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? name = _nameController.text;
                    final double? price =
                        double.tryParse(_priceController.text);
                    if (name != null && price != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _drivers_lists
                            .add({"name": name, "price": price});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _drivers_lists
                            .doc(documentSnapshot!.id)
                            .update({"name": name, "price": price});
                      }

                      // Clear the text fields
                      _nameController.text = '';
                      _priceController.text = '';

                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _buy_ticket_online(
    BuildContext context,
    String productId,
    DocumentSnapshot<Object?> documentSnapshot,
  ) async {
    var c = int.parse(documentSnapshot["reserved_seats"]);
    var d = c + 1;
    await _drivers_lists.doc(productId).update({
      "reserved_seats": "$d",
    });
    var date_now = DateTime.now();
    FirebaseFirestore.instance.collection("tour_history").doc(productId).set({
      "tour_id": productId,
      "tour_time": date_now,
      "tour_driver": documentSnapshot["name"],
      "seat_number": documentSnapshot["reserved_seats"]
    }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' successfully  buy tickets  '))));

    // Show a snackbar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fetch_drivers_list(),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> fetch_drivers_list() {
    return StreamBuilder(
      stream: _drivers_lists.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              var no_seats = int.parse(documentSnapshot["car_capacity"]);
              var capacity_seats =
                  int.parse(documentSnapshot["reserved_seats"]);
              return Card(
                margin: const EdgeInsets.all(10),
                child: Container(
                  height: 200,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: Icon(Icons.car_rental),
                          ),
                          Column(
                            children: [
                              Text(documentSnapshot["name"]),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("phone "),
                                  Text(
                                    documentSnapshot['phone'],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Text(documentSnapshot["car_capacity"]),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.place),
                          Text(
                            "start",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text("name"),
                          Icon(Icons.place_outlined),
                          Text(
                            "end",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(documentSnapshot["name"]),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "left seats",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.yellow,
                            radius: 10,
                            child: Text(documentSnapshot["reserved_seats"]),
                          ),
                          Text("Station name"),
                          Text(documentSnapshot['station_name']),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: Icon(Icons.production_quantity_limits),
                                onPressed: () {
                                  no_seats >= capacity_seats
                                      ? _buy_ticket_online(context,
                                          documentSnapshot.id, documentSnapshot)
                                      : null;
                                },
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
