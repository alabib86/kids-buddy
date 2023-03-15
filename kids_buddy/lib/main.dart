import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:kids_buddy/contact_us_page.dart';
import 'academies_page.dart';
import 'news_page.dart';
import 'school_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      theme: ThemeData(
          fontFamily: "Mochiy",
          brightness: Brightness.light,
          primaryColor: const Color(0xffda8067),
          splashColor: const Color(0xffebaf81),
          shadowColor: const Color(0xfff7e39c),
          canvasColor: const Color(0xfff7ffba)),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  var selectedArea;

  List<Widget> widgetPages = [
    NewsPage(),
    const SchoolsPage(),
    const AcademiesPage(),
    const ContactUsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Image.asset("images/kb1.png"),
        title: const Text('Kids Buddy'),
        backgroundColor: Theme.of(context).splashColor,
      ),
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              selectedItemColor: Colors.white,
              selectedLabelStyle: const TextStyle(fontSize: 15,),
              unselectedLabelStyle: const TextStyle(fontSize: 9),
              currentIndex: selectedIndex,
              backgroundColor: Theme.of(context).splashColor,
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              items:  [
                BottomNavigationBarItem(
                    icon: Icon(Icons.newspaper), label: "News",backgroundColor:Theme.of(context).splashColor),
                BottomNavigationBarItem(
                    icon: Icon(Icons.school), label: "Schools",backgroundColor:Theme.of(context).splashColor),
                BottomNavigationBarItem(
                    icon: Icon(Icons.sports), label: "Academies",backgroundColor:Theme.of(context).splashColor),
                BottomNavigationBarItem(
                    icon: Icon(Icons.contact_phone), label: "Contact Us",backgroundColor:Theme.of(context).splashColor),
              ],
            ),
          )),
      body: widgetPages.elementAt(selectedIndex),
    );
  }
}
