// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flip_card/flip_card.dart';

//Node structure containing reinforce vocabulary
class ReinforceVocab {
  String english;
  String spanish;

  ReinforceVocab(this.english, this.spanish);
}


// should add constants for sizes ( figure out how to use phone ratios for sizing? (scale factor))

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  // root of application
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Language learning app';
    return MaterialApp(
      // sets the style for the entire project (colors font etc)
        title: appTitle,
        theme: ThemeData(
          // primarySwatch: Colors.brown,
          // elevatedButtonTheme:
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late PageController _pageViewController;
  List<ReinforceVocab> reinforceList = [];


  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();


    //List creation - Currently all words in SampleReinforce
    getNextData(reinforceList);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  /*  ^^ DONT MESS WITH THE ABOVE! ^^  */

  //Read SampleReinforce.txt into the list
  List<String> reinforceDisplayText = ['Empty', 'Empty', 'Empty', 'Empty', 'Empty'];
  Future<void> getNextData(List<ReinforceVocab> reinforceList) async {
    String response = await rootBundle.loadString('assets/SampleReinforce');
    List<String> lines = response.split('\n');
    for (String line in lines) {
      List<String> parts = line.split('.');
      if (parts.length == 2) {
        reinforceList.add(ReinforceVocab(parts[0].trim(), parts[1].trim()));
      }
    }
    reinforceDisplayText[0] = reinforceList[0].english;
    reinforceDisplayText[1] = reinforceList[1].english;
    reinforceDisplayText[2] = reinforceList[2].english;
    reinforceDisplayText[3] = reinforceList[3].english;
    reinforceDisplayText[4] = reinforceList[4].english;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, // setting style for home page (bg color)
        appBar: AppBar(
          title: const Text('Home'), // remove if no title is to displayed
        ),
        body: Stack(alignment: Alignment.center, children: [
          Column(
              key: GlobalKey(),
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 200, child: staticHomePage())
              ]),
          Expanded(
            child: PageView(
              // sets "swippeable widgets"
              controller: _pageViewController,
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 150.0),
                    height: 500,
                    child: homePage1()),
                Container(
                    margin: const EdgeInsets.only(top: 150.0),
                    height: 500,
                    child: homePage2()),
                Container(
                    margin: const EdgeInsets.only(top: 150.0),
                    height: 500,
                    child: homePage3()),
                Container(
                    margin: const EdgeInsets.only(top: 150.0),
                    height: 500,
                    child: homePage4()),
              ],
            ),
          ),


          /// will controll the PageView
          GestureDetector(onPanUpdate: (details) {
            // Swiping in right direction.
            if (details.delta.dx > 0) {
              _pageViewController.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn);
            }

            // Swiping in left direction.
            if (details.delta.dx < 0) {
              _pageViewController.previousPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut);
            }
          }),
          Container(
            margin: const EdgeInsets.only(top: 145.0),
          child: const Padding(
            padding: EdgeInsets.only(left: 8, top: 40),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reinforce Phrases',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                )),
          ),
    ),
    Container(
    margin: const EdgeInsets.only(top: 460.0),
            child: SizedBox(
              width: 390,
              height: 200,
              child: _ReinforcePhrasesPageView(Color.fromARGB(255, 175, 244, 198)),
            ),
          )
        ]));
  }

  Widget staticHomePage() {
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: 395,
                  height: 70,
                  child: banner('Search',
                      backgroundColor: Color.fromARGB(255, 230, 230, 230))),
              const Padding(
                  padding: EdgeInsets.only(left: 15, right: 290, top: 30),
                  child: Text('Modules',
                      style:
                      TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)))
            ]
        )
    );
  }

  Widget homePage1() {
    const h30_spacer = SizedBox(height: 20);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 390,
              height: 114,
              child: banner('General',
                  backgroundColor: Color.fromARGB(255, 175, 244, 198),
                  subtext:
                  'Learn common phrases for greetings, directions, and more!')),

          h30_spacer, // spacer

          SizedBox(
            child: moduleButtonWidget(
                context,
                'Directions',
                'Greetings',
                'Pass',
                'assets\\directions_icon.png',
                'assets\\greetings_icon.png',
                'assets\\osvaldo_icon.png',
                color1: Color.fromARGB(255, 175, 244, 198),
                color2: Color.fromARGB(255, 135, 212, 161),
                color3: Color.fromARGB(255, 95, 170, 120)),
          ),
        ],
      ),
    );
  }





  Widget homePage2() {
    const h30_spacer = SizedBox(height: 20);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 390,
              height: 114,
              child: banner('Food',
                  backgroundColor: Color.fromARGB(255, 252, 209, 156),
                  subtext: 'Learn the basics for working with food!')),

          h30_spacer, // spacer

          SizedBox(
              child: moduleButtonWidget(
                  context,
                  'Ingredients',
                  'Cooking Tools',
                  'Taking Orders',
                  'assets\\directions_icon.png',
                  'assets\\greetings_icon.png',
                  'assets\\osvaldo_icon.png',
                  color1: Color.fromARGB(255, 252, 209, 156),
                  color2: Color.fromARGB(255, 237, 183, 133),
                  color3: Color.fromARGB(255, 206, 153, 104))),
        ],
      ),
    );
  }

  Widget homePage3() {
    const h30_spacer = SizedBox(height: 20);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 390,
              height: 114,
              child: banner('Beauty',
                  backgroundColor: Color.fromARGB(255, 210, 244, 248),
                  subtext: 'Learn sentences related to styling!')),

          h30_spacer, // spacer

          SizedBox(
              child: moduleButtonWidget(
                  context,
                  'Hair Care',
                  'Nail Care',
                  'Spa',
                  'assets\\directions_icon.png',
                  'assets\\greetings_icon.png',
                  'assets\\osvaldo_icon.png',
                  color1: Color.fromARGB(255, 210, 244, 248),
                  color2: Color.fromARGB(255, 186, 231, 236),
                  color3: Color.fromARGB(255, 167, 214, 220))),
        ],
      ),
    );
  }

  Widget homePage4() {
    const h30_spacer = SizedBox(height: 20);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 390,
              height: 114,
              child: banner('Travel',
                  backgroundColor: Color.fromARGB(255, 252, 250, 207),
                  subtext: 'Learn sentences related to travel!')),

          h30_spacer, // spacer

          SizedBox(
              child: moduleButtonWidget(
                  context,
                  'Rentals',
                  'Airport',
                  'Hotels',
                  'assets\\directions_icon.png',
                  'assets\\greetings_icon.png',
                  'assets\\osvaldo_icon.png',
                  color1: Color.fromARGB(255, 252, 250, 207),
                  color2: Color.fromARGB(255, 245, 242, 170),
                  color3: Color.fromARGB(255, 236, 232, 144))),

        ],
      ),
    );
  }

  Widget banner(String text,
      {required Color backgroundColor,
        String subtext = '',
        Color textColor = Colors.black}) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor),
              )),
          if (subtext.isNotEmpty)
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  subtext,
                  style: TextStyle(fontSize: 16, color: textColor),
                )),
        ],
      ),
    );
  }

/*
  Widget banner(text, {subtext = ''}){
    const colors = Color(0xFFB0F9D4);

    return Container(
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(15.0), // Set the radius here
      ),
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
   /*       Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          )),
  */        Text(
            text,
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtext.trim().isNotEmpty)
            Text(
              subtext,
              style: const TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }
*/


  Widget _ReinforcePhrasesPageView(Color containerColor) {
    return Expanded(
      child: PageView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Center(
            child: FlipCard(
              direction: FlipDirection.VERTICAL,
              front: Container(
                width: 340,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    left: BorderSide(
                      color: Color.fromARGB(255, 230, 230, 230),
                      width: 3,
                    ),
                    bottom: BorderSide(
                    color: Color.fromARGB(255, 230, 230, 230),
                    width: 6,
                    )
                  ),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    reinforceList[index].english,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              back: Container(
                width: 340,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      left: BorderSide(
                        color: Color.fromARGB(255, 230, 230, 230),
                        width: 3,
                      ),
                      bottom: BorderSide(
                        color: Color.fromARGB(255, 230, 230, 230),
                        width: 6,
                      )
                  ),
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    reinforceList[index].spanish,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget moduleButtonWidget(
      BuildContext context, submod1, submod2, submod3, image1, image2, image3,
      {required Color color1, required Color color2, required Color color3}) {
    // style for all buttons. (current holding size and shape)
    final ButtonStyle btnStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(110, 125),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
    );

    // colours for first, second, and third
    final ButtonStyle fStyle =
    ElevatedButton.styleFrom(backgroundColor: color1);
    final ButtonStyle sStyle =
    ElevatedButton.styleFrom(backgroundColor: color2);
    final ButtonStyle tStyle =
    ElevatedButton.styleFrom(backgroundColor: color3);

    // text style, (bold, font, color, etc)
    const TextStyle texStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );

    return Stack(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          // submodule 1
          FilledButton.tonal(
            style: (btnStyle.merge(fStyle)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return _ModulePageState();
              }));
            }, // what happens when the button is pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  image1,
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text(submod1, style: texStyle),
              ],
            ),
          ),
          const SizedBox(width: 25), // spacer

          // submodule 2
          FilledButton.tonal(
            style: (btnStyle.merge(sStyle)),
            onPressed: () {}, // what happens when the button is pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  image2,
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text(submod2, style: texStyle),
              ],
            ),
          ),
          const SizedBox(width: 25), // spacer

          //submode 3
          FilledButton.tonal(
            style: (btnStyle.merge(tStyle)),
            onPressed: () {}, // what happens when the button is pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  image3,
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10),
                Text(submod3, style: texStyle),
              ],
            ),
          ),
        ]),
      ],
    );
  }
}

class _ModulePageState extends StatelessWidget {
  //functions for main page would go here
  void module() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Directions'), // remove if no title is to displayed
      ),
      body: Column(
        children: <Widget>[
          // all widgets on home page
          const SizedBox(
              width: 400,
              height: 50,
              child: Text(
                  'module')), // change the dimensions to be phone dim dependent (ratio)
          const SizedBox(height: 5), // spacer
          const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 340, height: 50, child: Text('module')),
                SizedBox(width: 60, height: 50, child: Text('module'))
              ]),
          const Padding(
              padding: EdgeInsets.only(right: 300, top: 30),
              child: Text('Modules',
                  style:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))),
          const SizedBox(width: 400, height: 100, child: Text('module')),

          const SizedBox(height: 15), // spacer

          lsrButtons(context, 1)
        ],
      ),
    );
  }

  Widget lsrButtons(BuildContext context, int id) {
    const spacer = SizedBox(height: 10);
    final ButtonStyle btnStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(250, 60),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
    );
    const TextStyle tStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );

    return Stack(children: <Widget>[
      Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        spacer,
        // LISTENING BUTTON
        FilledButton.tonal(
            style: btnStyle,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return _ListeningState();
              }));
            },
            child: const Text(
              'Listening',
              style: tStyle,
            )),
        spacer,
        // SPEAKING BUTTON
        FilledButton.tonal(
            style: btnStyle,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return _ListeningState();
              }));
            },
            child: const Text(
              'Speaking',
              style: tStyle,
            )),
        spacer,
        // READING BUTTON
        FilledButton.tonal(
            style: btnStyle,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return _ReadingState();
              }));
            },
            child: const Text(
              'Reading',
              style: tStyle,
            )),
      ])
    ]);
  }
}

class _ListeningState extends StatelessWidget {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
              'Listening! - *submodule*'), // remove if no title is to displayed
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
                onPressed: () {
                  player.play(AssetSource('audio/Page16-Ask-for-Help.mp3'));
                },
                child: const Text('Listen'))
          ],
        ));
  }
}

class _ReadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
              'Reading! - *submodule*'), // remove if no title is to displayed
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets\\osvaldo.png',
              height: 200,
              width: 200,
            ),
          ],
        ));
  }
}