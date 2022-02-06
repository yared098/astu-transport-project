// ignore_for_file: use_key_in_widget_constructors, camel_case_types, non_constant_identifier_names, prefer_const_constructors, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class passenger_live_booking extends StatelessWidget {
  final Color color;

  passenger_live_booking(this.color);

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
                        // create  a new
                        await _drivers_lists
                            .add({"name": name, "price": price});
                      }

                      if (action == 'update') {
                        // Update the
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
  Future<void> _buying_tecketes(
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
      "seat_number": documentSnapshot["reserved_seats"],
      "tour_start": documentSnapshot["start"],
      "tour_end": documentSnapshot["end"]
    }).then((value) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(' successfully  buying teckets number '))));

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
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color:
                          no_seats == capacity_seats ? Colors.red : Colors.blue,
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
                          SizedBox(
                            width: 30,
                          ),
                          Column(
                            children: [
                              Text(
                                documentSnapshot["name"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                documentSnapshot['phone'],
                                style: TextStyle(color: Colors.white70),
                              )
                            ],
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue,
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
                          Text(documentSnapshot["start"]),
                          Icon(Icons.place_outlined),
                          Text(
                            "end",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          Text(documentSnapshot["end"]),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Address"),
                          SizedBox(
                            width: 50,
                          ),
                          Text(documentSnapshot['address']),
                          CircleAvatar(
                              child: IconButton(
                                icon: Icon(Icons.production_quantity_limits),
                                onPressed: () {
                                  _buying_tecketes(context, documentSnapshot.id,
                                      documentSnapshot);
                                },
                              ),
                              radius: 20,
                              backgroundColor: Colors.white),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "left seats",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 10,
                            child: Text(documentSnapshot["reserved_seats"]),
                          ),
                          Text("Station name"),
                          Text(documentSnapshot['station_name']),
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
