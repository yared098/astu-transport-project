// ignore_for_file: prefer_const_constructors, camel_case_types, use_key_in_widget_constructors, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class passenger_tour_history extends StatelessWidget {
  final Color color;

  passenger_tour_history(this.color);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final CollectionReference _productss =
      FirebaseFirestore.instance.collection('tour_history');

  Future<void> _createOrUpdate(BuildContext context,
      [DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['tour_driver'];
      _priceController.text = documentSnapshot['tour_time'].toString();
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
                        await _productss.add({"name": name, "price": price});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _productss
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
  Future<void> _deleteProduct(
    BuildContext context,
    String productId,
    DocumentSnapshot<Object?> documentSnapshot,
  ) async {
    await _productss.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(' successfully  delete tout history ')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fetch_drivers_list(),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> fetch_drivers_list() {
    return StreamBuilder(
      stream: _productss.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.hasData) {
          return ListView.builder(
            itemCount: streamSnapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Container(
                  height: 200,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.green,
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
                              Text(documentSnapshot["tour_driver"]),
                              SizedBox(
                                height: 10,
                              ),
                              Text(documentSnapshot['tour_driver'])
                            ],
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue,
                            child: Text(documentSnapshot["tour_driver"]),
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
                          Text(documentSnapshot["tour_driver"]),
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
                          Text(documentSnapshot['tour_driver']),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            color: Colors.transparent,
                            onPressed: () {
                              _deleteProduct(context, documentSnapshot.id,
                                  documentSnapshot);
                            },
                            child: Icon(Icons.delete),
                          )
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
