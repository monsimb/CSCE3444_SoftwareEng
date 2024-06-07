import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // root of your application.
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    const String appTitle = 'layout demo';
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(primarySwatch: Colors.lightGreen),
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Language App'),
          ),
          body: const Center(
            child: HomePage(),
          )),
    );
  }
}

class HomePage extends StatefulWidget {
  // homepage
  const HomePage({super.key});
  final String title = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //functions for main page would go here
  void module() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // all widgets on home page
            SizedBox(
                width: 400,
                height: 50,
                child: customButtonWidget(
                    'Bar with guy, progress bar?')), // change the dimensions to be phone dim dependent (ratio)
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                      width: 300,
                      height: 50,
                      child: customButtonWidget('search')),
                  SizedBox(
                      width: 100, height: 50, child: customButtonWidget('gear'))
                ]),
            Padding(
                padding: const EdgeInsets.only(right: 300),
                child: Text('Modules',
                    style: new TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold))),
            SizedBox(
                width: 400, height: 100, child: customButtonWidget('General')),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: customButtonWidget('pass')),
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: customButtonWidget('pass')),
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: customButtonWidget('pass')),
                ]),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed:
      //       module, // replace with the function for the specific module it leads to
      //   tooltip: 'Increment',
      //   child: Ink(
      //     height: 100,
      //     width: 100,
      //     decoration: BoxDecoration(
      //       image: DecorationImage(
      //         image: AssetImage('assets\\weetabix.jpg'),
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget customButtonWidget(text) {
    const colors = Colors.lightGreen;
    return Stack(
      children: [
        // round box
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(50 * 0.19, 0, 0, 0),
          child: Container(
              decoration: BoxDecoration(
                  color: colors,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0),
                    bottomRight: const Radius.circular(40.0),
                    bottomLeft: const Radius.circular(40.0),
                  )),
              child: Center(
                child: Text(
                  text,
                  textScaleFactor: 1.5,
                ),
              )),
        ),
      ],
    );
  }
}
