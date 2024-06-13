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
          primarySwatch: Colors.brown,
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
            // crossAxisAlignment: CrossAxisAdlignment.center,
            children: <Widget>[
          SizedBox(width: 400, height: 40, child: banner('search')),
          const Padding(
              padding: EdgeInsets.only(right: 300, top: 30),
              child: Text('Modules',
                  style:
                      TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
        ]));
  }

  Widget homePage1() {
    const h30_spacer = SizedBox(height: 30);

    return Scaffold(
      body: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 400,
              height: 100,
              child: banner('General',
                  subtext:
                      'Learn the basics like how to give and take directions')),

          h30_spacer, // spacer

          SizedBox(
            child:
                moduleButtonWidget(context, 'Directions', 'Greetings', 'pass'),
          )
        ],
      ),
    );
  }

  Widget homePage2() {
    return Scaffold(
      body: Row(children: <Widget>[
        // all widgets on home page
        SizedBox(
          width: 10,
        ),
        SizedBox(
            width: 400,
            height: 100,
            child: banner('Food',
                subtext: 'Learn the basics like how to order food!')),
      ]),
    );
  }

  Widget homePage3() {
    return Scaffold(
      body: Column(children: <Widget>[
        // all widgets on home page
        SizedBox(
            width: 400,
            height: 100,
            child:
                banner('Food', subtext: 'Learn sentences related to styling!')),
      ]),
    );
  }

  Widget banner(text, {subtext = ''}) {
    const colors = Color.fromARGB(255, 179, 230, 121);

    return Container(
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(15.0), // Set the radius here
      ),
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
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

  Widget moduleButtonWidget(BuildContext context, submod1, submod2, submod3) {
    // style for all buttons. (current holding size and shape)
    final ButtonStyle btnStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(110, 125),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
    );

    // colours for first, second, and third
    final ButtonStyle fStyle = ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 153, 219, 197));
    final ButtonStyle sStyle = ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 116, 217, 172));
    final ButtonStyle tStyle = ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 89, 241, 195));

    // text style, (bold, font, color, etc)
    const TextStyle texStyle = TextStyle(
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
                  'assets\\directions_icon.png',
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
                  'assets\\greetings_icon.png',
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
                  'assets\\osvaldo_icon.png',
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
