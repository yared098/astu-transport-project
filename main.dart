// ignore_for_file: unused_local_variable, prefer_const_constructors, deprecated_member_use, unnecessary_null_comparison, non_constant_identifier_names, unused_element
import 'package:astu_tms/account_setting/account_checking.dart';
import 'package:astu_tms/account_setting/login_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth users = FirebaseAuth.instance;

    return MaterialApp(
      title: ' Astu Transport Mangemnet system',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: "welcome to astu transport"),
      // home: _auth != null
      //     ? account_checking()
      //     : MyHomePage(title: "welcome to astu transport"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  get kIsWeb => null;

  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    late var pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topRight,
        child: SafeArea(
          child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: RaisedButton(
                onPressed: () {},
                color: Colors.white,
                child: Text("skip"),
              )),
        ),
      ),
      pages: [
        PageViewModel(
          title: "እንኳን ደህና መጡ",
          body: " Astu Transport Manegment System ",
          image: Image.asset(
            "assets/image1.jpeg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          decoration: const PageDecoration(),
        ),
        PageViewModel(
          title: "Paassenger",
          body:
              "Passengers can simply view and see the schedul of thier station as well as some other futur.",
          image: Image.asset(
            "assets/image4.jpeg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          decoration: PageDecoration(),
        ),
        PageViewModel(
          title: "Drivers",
          body: " Drivers can si",
          image: Image.asset(
            "assets/image3.jpeg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          decoration: PageDecoration(),
        ),
        PageViewModel(
          title: "Authority",
          body: "transport managemnet system project astu.",
        ),
        PageViewModel(
          title: "Another title page",
          body: "Transport manegment system onboarding",
          image: Image.asset(
            "assets/image1.jpeg",
            height: double.infinity,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          footer: ElevatedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'FooButton',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          decoration: PageDecoration(),
        ),
        PageViewModel(
          title: "Transport Manegment System",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "WELCOME ",
              ),
              Icon(Icons.car_rental),
            ],
          ),
          decoration: PageDecoration().copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: Image.asset(
            "assets/image4.jpeg",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          reverse: true,
        ),
      ],
      onDone: () => Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext ctx) => login_page())),
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done:
          const Text('finish ', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.pink,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
