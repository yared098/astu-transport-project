// ignore_for_file: prefer_const_constructors, camel_case_types, deprecated_member_use, prefer_final_fields, unused_field, unused_element, non_constant_identifier_names

import 'package:astu_tms/account_setting/signup_page.dart';
import 'package:astu_tms/officer_page/officer_page.dart';
import 'package:astu_tms/driver_page/test_page_driver.dart';
import 'package:astu_tms/passenger_pages/test_passenger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class login_page extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<login_page> {
  TextEditingController _emailcontroler = TextEditingController();
  TextEditingController _passwordcontroler = TextEditingController();

  String? _groupValue;

  ValueChanged<String?> _valueChangedHandler() {
    return (value) => setState(() => _groupValue = value!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                // ignore: sized_box_for_whitespace
                child: Container(
                  width: 200,
                  height: 150,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _emailcontroler,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
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
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                ),
                MyRadioOption<String>(
                  value: '1',
                  groupValue: _groupValue,
                  onChanged: _valueChangedHandler(),
                  label: '1',
                  text: 'Driver',
                ),
                MyRadioOption<String>(
                  value: '2',
                  groupValue: _groupValue,
                  onChanged: _valueChangedHandler(),
                  label: '2',
                  text: 'passenger',
                ),
                MyRadioOption<String>(
                  value: '3',
                  groupValue: _groupValue,
                  onChanged: _valueChangedHandler(),
                  label: '3',
                  text: 'officer',
                ),
              ],
            ),
            FlatButton(
              onPressed: () {
                show_my_dia();
              },
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
                onPressed: () {
                  if (_groupValue == '1') {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailcontroler.text,
                            password: _passwordcontroler.text)
                        .then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => driver_page_test(
                                      email: _emailcontroler.text,
                                    ))));
                  } else if (_groupValue == '2') {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailcontroler.text,
                            password: _passwordcontroler.text)
                        .then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) =>
                                    test_passenger_page(
                                      email: _emailcontroler.text,
                                    ))));
                  } else if (_groupValue == '3') {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: _emailcontroler.text,
                            password: _passwordcontroler.text)
                        .then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext ctx) => officer_page(
                                      email: _emailcontroler.text,
                                    ))));
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext ctx) => sign_up_page()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('New User? Create Account'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void show_my_dia() {
    showBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            width: 200,
            height: 200,
            color: Colors.pink,
          );
        });
  }
}

class MyRadioOption<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String label;
  final String text;
  final ValueChanged<T?> onChanged;

  const MyRadioOption({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.text,
    required this.onChanged,
  });

  Widget _buildLabel() {
    final bool isSelected = value == groupValue;

    return Container(
      width: 20,
      height: 30,
      decoration: ShapeDecoration(
        shape: CircleBorder(
          side: BorderSide(
            color: Colors.black,
          ),
        ),
        color: isSelected ? Colors.cyan : Colors.white,
      ),
      child: Center(
        child: Text(
          value.toString(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.cyan,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    return Text(
      text,
      style: const TextStyle(color: Colors.black, fontSize: 17),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () => onChanged(value),
        splashColor: Colors.cyan.withOpacity(0.5),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              _buildLabel(),
              const SizedBox(width: 10),
              _buildText(),
            ],
          ),
        ),
      ),
    );
  }
}
