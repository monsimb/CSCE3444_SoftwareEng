// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  /*  ^^ DONT MESS WITH THE ABOVE! ^^  */

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
                    height: 400,
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
          })
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
                  style: TextStyle(
                    fontSize: 25.0, 
                    fontWeight: FontWeight.bold))),
        ]));
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

          h30_spacer,   // spacer

          const Padding(
            padding: EdgeInsets.only(left: 15, top: 40),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reinforce Phrases',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                )),
          ),

          SizedBox(height: 10), //smaller spacer

          SizedBox(
              width: 380,
              height: 250,
              child: banner('Word/Phrases',
                  backgroundColor: Color.fromARGB(255, 175, 244, 198),
                  subtext: 'Definition')),
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

          h30_spacer,   // spacer

          const Padding(
            padding: EdgeInsets.only(left: 8, top: 40),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reinforce Phrases',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                )),
          ),

          SizedBox(height: 10), //smaller spacer

          SizedBox(
              width: 380,
              height: 250,
              child: banner('Word/Phrases',
                  backgroundColor: Color.fromARGB(255, 252, 209, 156),
                  subtext: 'Definition')),
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

          h30_spacer,   // spacer

          const Padding(
            padding: EdgeInsets.only(left: 8, top: 40),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reinforce Phrases',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                )),
          ),

          SizedBox(height: 10), //smaller spacer

          SizedBox(
              width: 380,
              height: 250,
              child: banner('Word/Phrases',
                  backgroundColor: Color.fromARGB(255, 210, 244, 248),
                  subtext: 'Definition')),
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

          h30_spacer,   // spacer

          const Padding(
            padding: EdgeInsets.only(left: 8, top: 40),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reinforce Phrases',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                )),
          ),

          SizedBox(height: 10), //smaller spacer

          SizedBox(
              width: 380,
              height: 250,
              child: banner('Word/Phrases',
                  backgroundColor: Color.fromARGB(255, 252, 250, 207),
                  subtext: 'Definition')),
        ],
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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return _ModulePageState();
              }));
            }, // what happens when the button is pressed
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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return _ModulePageState();
              }));
            }, // what happens when the button is pressed
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
  void module() {}    // TODO: add parameters page title (module/submodule) and color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Directions'), // remove if no title is to displayed
      ),
      body: Center( 
        child: Column(
          children: <Widget>[
            // all widgets on home page
            SizedBox(
                width: 395,
                height: 70,
                child: banner('Search', 
                  backgroundColor: Color.fromARGB(255, 230, 230, 230))), // TODO: change the dimensions to be phone dim dependent (ratio)
            // const SizedBox(height: 5), // spacer
            // const Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       SizedBox(width: 340, height: 50, child: Text('module')),
            //       SizedBox(width: 60, height: 50, child: Text('module'))
            //     ]),
            const Align( 
                alignment: Alignment.centerLeft, 
                child: Padding(
                  padding: EdgeInsets.only(left: 18, top: 50, bottom: 15),
                  child: Text('Module Title',
                      style:
                          TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold)))),
            // const SizedBox(width: 400, height: 100, child: Text('module')),
            
            lsrButtons(context, 1)
          ],
      )),
    );
  }

  Widget lsrButtons(BuildContext context, int id) {
    /* Style settings (Button/Text) */
    const spacer = SizedBox(height: 25);
    final ButtonStyle btnStyle = FilledButton.styleFrom(
      minimumSize: const Size(0, 80),
      backgroundColor:  Color.fromARGB(255, 175, 244, 198),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
    );
    const TextStyle tStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 25
    );

    /* Actual Button Implementation */
    return Stack(children: <Widget>[
      Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        // LISTENING BUTTON
        FilledButton.tonal(
          style: btnStyle,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return _ListeningState();
            }));
          },
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: 3.25,
            child: const Text(
            'Listening',
            style: tStyle,
          ))),
        spacer,
        // SPEAKING BUTTON
        FilledButton.tonal(
          style: btnStyle,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return _ListeningState();
            }));
          },
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: 3.25,
            child: const Text(
            'Speaking',
            style: tStyle,
          ))),
        spacer,
        // READING BUTTON
        FilledButton.tonal(
          style: btnStyle,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return _ReadingState();
            }));
          },
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: 3.7,
            child: const Text(
            'Reading',
            style: tStyle,
          ))),
          // PROGRESS BUTTON
          SizedBox(height: 25),
          SizedBox(
            width:390,
            height: 150,
          
          child: FilledButton.tonal(
            style: btnStyle,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) {

              return _ProgressState();
            }));
          },
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: 3.25,
            child: const Text(
            'Progress',
            style: tStyle,
          )))),
        
      ])
    ]);
  }
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

class _ListeningState extends StatelessWidget {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 35);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
              'Listening! - *submodule*'), // remove if no title is to displayed
        ),
        body: Column(   // TODO: add icon
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding( 
                  padding: EdgeInsets.only(right: 40),
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Color.fromARGB(255, 175, 244, 198)),
                    onPressed: () {
                      player.play(AssetSource('audio/Page16-Ask-for-Help.mp3'));
                    },
                    child: const Text(
                      'Listen',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18))
                  )
                ),
                Padding( 
                  padding: EdgeInsets.only(),
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Color.fromARGB(255, 175, 244, 198)),
                    onPressed: () {
                      player.play(AssetSource('audio/Page16-Ask-for-Help.mp3'));
                    },
                    child: const Text(
                      '0.5x Listen',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18))
                  )
                )
              ]),
            spacer,
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 230, 230, 230),
                borderRadius: BorderRadius.circular(35.0)),
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              width: 380,
              height: 100,
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type what you hear!',
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  contentPadding: EdgeInsets.only(left: 10)),
                // validator: (value) {
                //   if(value != 'test') {
                //     return 'Sorry, that is incorrect.';
                //   }
                // }
              )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 280),
              child: ElevatedButton(
                onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Getting feedback')),
                    );
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor:Color.fromARGB(255, 135, 212, 161)),
                child: const Text('Submit', style: TextStyle(color: Colors.black))
              ),
            ),
          ],
        ));
        // TODO: add feedback
  }
}

class _ReadingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 35);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Reading! - *submodule*'), // remove if no title is to displayed
      ),
      body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding( 
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text('Reading',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)))),
            spacer,
            Align( 
              alignment: Alignment.center, 
              child: Image.asset(
                'assets\\osvaldo.png',
                height: 250,
                width: 250,
              )),
          ],
        )
      );
  }
}


// TODO: Add Speaking State
// TODO: Add Progress State

class _ProgressState extends StatelessWidget {
  @override
 
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 35);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Progress! - *submodule*'), // remove if no title is to displayed
      ),
      body: Column(
          children: <Widget> [
            Align(
              alignment: Alignment.topLeft,
              child: Padding( 
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text('Progress',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),),),
                  spacer,
                  lvl1(context, 1),
                  SizedBox(height: 15),
                  quiz1(context, 2),
                  SizedBox(height: 60),
                  lvl2(context,2),
                  SizedBox(height: 15),
                  quiz2(context, 2),
                  SizedBox(height: 60),
                  lvl3(context,3),
                  SizedBox(height: 15),
                  quiz3(context, 2),
                  
          ],),);
  }
  Widget lvl1(BuildContext context, int id) {
  //const spacer = SizedBox(height: 25);
  return Container(
    height: 90,
    width: 375,
    padding: EdgeInsets.symmetric(vertical:10, horizontal:25),
    decoration: BoxDecoration(
      color:Color.fromARGB(255, 175, 244, 198),
      borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Row(
        
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Level 1' ,
            style: TextStyle(fontSize: 25, color: Colors.black),
            textAlign: TextAlign.left,
        ),],),);}
          
  Widget lvl2(BuildContext context, int id) {
  //const spacer = SizedBox(height: 25);
  return Container(
    height: 90,
    width: 375,
    padding: EdgeInsets.symmetric(vertical:10, horizontal:25),
    decoration: BoxDecoration(
      color:Color.fromARGB(255, 175, 244, 198),
      borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Level 2' ,
            style: TextStyle(fontSize: 25, color: Colors.black),
            textAlign: TextAlign.left,
        ),],),);}

     Widget lvl3(BuildContext context, int id) {
  //const spacer = SizedBox(height: 25);
  return Container(
    height: 90,
    width: 375,
    padding: EdgeInsets.symmetric(vertical:10, horizontal:25),
    decoration: BoxDecoration(
      color:Color.fromARGB(255, 175, 244, 198),
      borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Level 3' ,
            style: TextStyle(fontSize: 25, color: Colors.black),
            textAlign: TextAlign.left,
        ),],),);}
   Widget quiz1(BuildContext context, int id) {
  //const spacer = SizedBox(height: 25);
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(width:18),
      Container(
        height: 70,
        width: 200,
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 25),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 125, 197, 149),
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: Text(
          'Quiz 1',
          style: TextStyle(fontSize: 25, color: Colors.black),
          textAlign: TextAlign.left,
        ),
      ),
    ],
  );
}
          
  Widget quiz2(BuildContext context, int id) {
  //const spacer = SizedBox(height: 25);
  //bool ischecked = false;

  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      /*Checkbox(
        value: ischecked,
        onChanged: (bool? value) {
          //
          ischecked = value ?? false;
        },
      ),*/
      SizedBox(width: 194),
      Container(
        height: 70,
        width: 200,
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 25),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 125, 197, 149),
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: Text(
          'Quiz 2',
          style: TextStyle(fontSize: 25, color: Colors.black),
          textAlign: TextAlign.right,
        ),
      ),
    ],
  );
}

     Widget quiz3(BuildContext context, int id) {
  //const spacer = SizedBox(height: 25);
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(width:18),
      Container(
        height: 70,
        width:200,
        padding: EdgeInsets.symmetric(vertical: 17, horizontal: 25),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 125, 197, 149),
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        child: Text(
          'Quiz 3',
          style: TextStyle(fontSize: 25, color: Colors.black),
          textAlign: TextAlign.left,
        ),
      ),
    ],
  );
}
}

// TODO: Add Quiz State
