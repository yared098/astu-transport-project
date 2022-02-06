// ignore_for_file: camel_case_types, must_be_immutable, use_key_in_widget_constructors, non_constant_identifier_names, prefer_const_constructors, unused_field, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class search_driver_page extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabLayoutExampleState();
  }
}

class _TabLayoutExampleState extends State<search_driver_page>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.animateTo(2);
  }

  static const List<Tab> _tabs = [
    Tab(icon: Icon(Icons.car_rental), child: Text('cars')),
    Tab(icon: Icon(Icons.drive_eta_rounded), text: 'drivers'),
    Tab(icon: Icon(Icons.place), text: 'station'),
    Tab(icon: Icon(Icons.book), text: 'booking'),
    Tab(icon: Icon(Icons.looks_5), text: 'ture history'),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          /* Clear the search field */
                        },
                      ),
                      hintText: 'Search...',
                      border: InputBorder.none),
                ),
              ),
            ),
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle:
                  const TextStyle(fontStyle: FontStyle.italic),
              overlayColor:
                  MaterialStateColor.resolveWith((Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.blue;
                }
                if (states.contains(MaterialState.focused)) {
                  return Colors.white;
                } else if (states.contains(MaterialState.hovered)) {
                  return Colors.pinkAccent;
                }

                return Colors.transparent;
              }),
              indicatorWeight: 10,
              indicatorColor: Colors.red,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(5),
              indicator: BoxDecoration(
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(10),
                color: Colors.pinkAccent,
              ),
              isScrollable: true,
              physics: BouncingScrollPhysics(),
              onTap: (int index) {},
              enableFeedback: true,
              tabs: _tabs,
            ),
            backgroundColor: Colors.teal,
          ),
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              get_drivers(),
              Container(),
              Container(),
              Container(),
              Container(),
            ],
          ),
        ),
      ),
    );
  }

  Container get_drivers() => Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Drivers").snapshots(),
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
                              SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  Text(documentSnapshot["name"]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(documentSnapshot['card_id'])
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
                                    color: Colors.black,
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
                            children: [
                              Text("Address"),
                              SizedBox(
                                width: 50,
                              ),
                              Text(documentSnapshot['address'])
                            ],
                          )
                        ],
                      ),
                    ),

                    // child: ListTile(
                    //   title: Text(documentSnapshot['name']),
                    //   subtitle: Text(documentSnapshot['email'].toString()),
                    //   trailing: SizedBox(
                    //     width: 100,
                    //     child: Row(
                    //       children: [
                    // IconButton(
                    //     icon: const Icon(Icons.edit),
                    //     onPressed: () =>
                    //         _createOrUpdate(context, documentSnapshot)),
                    // IconButton(
                    //     icon: const Icon(Icons.delete),
                    //     onPressed: () =>
                    //         //         _deleteProduct(context, documentSnapshot.id)),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  );
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
