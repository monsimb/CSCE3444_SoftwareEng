// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, duplicate_ignore, constant_identifier_names, no_leading_underscores_for_local_identifiers, unnecessary_import, use_key_in_widget_constructors

//import 'dart:collection';
import 'dart:async';
import 'dart:math';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'widget.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flip_card/flip_card.dart';

//Node structure containing reinforce vocabulary
class ReinforceVocab {
  String english;
  String spanish;
  String audio;

  ReinforceVocab(this.english, this.spanish, this.audio);
}

//Used to generated reinforce cards
int num_of_reinforce_cards = 0;
List<ReinforceVocab> reinforceList = [];

Future<List<List<String>>> readFile(int startLine, int endLine) async {
  // Load the file as a string from the assets
  String fileContent = await rootBundle.loadString('assets/Words&Phrases');

  // Split the content into lines
  List<String> lines = fileContent.split('\n');
/*
  // Print the content of the file for debugging
  print('File Content:');
  for (String line in lines) {
    print(line);
  }
*/
  // Check if startLine and endLine are within the bounds of the file lines
  if (startLine < 0 || endLine >= lines.length || startLine > endLine) {
    throw RangeError('Invalid range of lines specified');
  }

  // Process only the lines within the specified range
  List<String> selectedLines = lines.sublist(startLine - 1, endLine);

  // Split each line by commas and create a list of lists
  List<List<String>> listOfLists = selectedLines.map((line) => line.split(',')).toList();

  // Print the processed list of lists for debugging
  print('Processed List of Lists:');
  for (List<String> list in listOfLists) {
    print(list);
  }

  return listOfLists;
}

Future<void> copyAssetToLocalData(String assetName, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileName';
  final file = File(filePath);

  //Disregarding if statement for demo cards
  // if (!await file.exists()) {
    // Load the file from assets
    final byteData = await rootBundle.load('assets/$assetName');

    // Write the byte data to the new file
    await file.writeAsBytes(byteData.buffer.asUint8List());
  // }
}

int mapParameterToIndex(String parameter) {
  switch (parameter) {
    case "Listening":
      return 2;
    case "Speaking":
      return 3;
    case "Reading":
      return 4;
    default:
      throw ArgumentError('Invalid parameter. Must be "Listening," "Speaking," or "Reading".');
  }
}

Future<void> updateFile(String firstWord, String parameter) async {
  final index = mapParameterToIndex(parameter);

  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/Words&Phrases';
  final file = File(filePath);

  // Read the file as lines
  List<String> lines = await file.readAsLines();

  // Find the line that starts with the given first word
  bool lineUpdated = false;
  for (int i = 0; i < lines.length; i++) {
    List<String> parts = lines[i].split('.');
    if (parts.isNotEmpty && parts[0] == firstWord) {
      lineUpdated = true;
      if (index < parts.length && parts[index] == 'F') {
        parts[index] = 'T';
        lines[i] = parts.join('.');

        // Check if all "F"s are now "T"s
        if (!parts.sublist(2, 5).contains('F')) {
          final reinforceFilePath = '${directory.path}/SampleReinforce';
          final reinforceFile = File(reinforceFilePath);

          // Remove "T"s and append to the SampleReinforce file
          final newLine = parts.where((part) => part != 'T').join('.');
          await reinforceFile.writeAsString('\n' + newLine, mode: FileMode.append);
        }

        break;
      } else if (parts[index] == 'T') {
        // Do nothing if the character is already 'T'
        break;
      } else {
        throw ArgumentError('Invalid index; out of bounds');
      }
    }
  }

  if (lineUpdated) {
    // Write the updated lines back to the file
    await file.writeAsString(lines.join('\n'));
  } else {
    throw ArgumentError('First word not found in file');
  }
}

// should add constants for sizes ( figure out how to use phone ratios for sizing? (scale factor))

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await copyAssetToLocalData("SampleReinforce", "SampleReinforce");
  await copyAssetToLocalData("Words&Phrases", "Words&Phrases");
  await copyAssetToLocalData("SampleReinforce", "SampleReinforce");
  updateFile('Hello', 'Speaking');

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Root of application
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

class ReadingState extends StatefulWidget {
  @override
  _ReadingState createState() => _ReadingState();
}
class ListeningState extends StatefulWidget {
  @override
  _ListeningState createState() => _ListeningState();
}
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late PageController _pageViewController;
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
  

  //Read SampleReinforce into the list
  Future<void> getNextData(List<ReinforceVocab> reinforceList) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/SampleReinforce';
    final file = File(filePath);
    String response = await file.readAsString();

    List<String> lines = response.split('\n');
    for (String line in lines) {
      if (line.trim().isEmpty) continue; // Skip empty lines
      List<String> parts = line.split('.');
      if (parts.length == 3) {
        reinforceList.add(ReinforceVocab(parts[0].trim(), parts[1].trim(),parts[2].trim()));
      }
    }
    //Bounds checking, no more than five cards
    while(num_of_reinforce_cards < reinforceList.length && num_of_reinforce_cards < 5) {
      num_of_reinforce_cards++;
    }
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
              child: ReinforcePhrasesPageView(),
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
              child: banner('Happy Learning!',
                  backgroundColor: Color.fromARGB(255, 230, 230, 230))),
          const Padding(
              padding: EdgeInsets.only(left: 15, right: 290, top: 30),
              child: Text('Modules',
                  style:
                      TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))),
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
                'Common',
                'Greetings',
                'Directions',
                'assets\\osvaldo_icon.png',
                'assets\\greetings_icon.png',
                'assets\\directions_icon.png',
                color1: Color.fromARGB(255, 175, 244, 198),
                color2: Color.fromARGB(255, 135, 212, 161),
                color3: Color.fromARGB(255, 95, 170, 120),
                targetscreen1: _ModulePageState(),
                targetscreen2: GreetingsModulePageState(),
                targetscreen3: DirectionsModulePageState(),
          )),


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
                  color3: Color.fromARGB(255, 206, 153, 104),
                  targetscreen1: IngredientsModulePageState(),
                  targetscreen2: CookToolsModulePageState(),
                  targetscreen3: OrdersModulePageState(),
                  )),

          h30_spacer, // spacer
         
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
                  color3: Color.fromARGB(255, 167, 214, 220),
                  targetscreen1: HairCareModulePageState(),
                  targetscreen2: NailCareModulePageState(),
                  targetscreen3: SpaModulePageState(),
                  )),

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
                  color3: Color.fromARGB(255, 236, 232, 144),
                  targetscreen1: RentalsModulePageState(),
                  targetscreen2: AirportModulePageState(),
                  targetscreen3: HotelsModulePageState(),
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
  Widget moduleButtonWidget(
      BuildContext context, submod1, submod2, submod3, image1, image2, image3,
      {required Color color1, required Color color2, required Color color3, required Widget targetscreen1, required Widget targetscreen2, required Widget targetscreen3}) {
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
                return targetscreen1;
                //return _ModulePageState();
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
                return targetscreen2;
                //return _ModulePageState();
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
                return targetscreen3;
                //return _ModulePageState();
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

class ReinforcePhrasesPageView extends StatefulWidget {

  @override
  _ReinforcePhrasesPageViewState createState() => _ReinforcePhrasesPageViewState();
}


class _ReinforcePhrasesPageViewState extends State<ReinforcePhrasesPageView> {


  @override
  Widget build(BuildContext context) {
return Expanded(
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: reinforceList.isEmpty
            ? Center(
          child: Text(
            "Review your new words and phrases here!",
            style: TextStyle(
              fontSize: 20,
            ),
              textAlign: TextAlign.center
          ),
        )
            : PageView.builder(
          key: ValueKey<int>(reinforceList.length),
          itemCount: reinforceList.length,
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
                      ),
                    ),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      reinforceList[index].spanish,
                      style: TextStyle(
                        fontSize: 20,
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
                      ),
                    ),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        reinforceList[index].english,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final audioPlayer = AudioPlayer();
                              audioPlayer.play(AssetSource('audio/' + reinforceList[index].audio + '.mp3'));
                              // Dispose the audio player after the audio completes playing
                              audioPlayer.onPlayerComplete.listen((_) {
                                audioPlayer.dispose();
                              });
                            },
                            child: Image.asset(
                              'assets/listening.png.png',
                              // Replace with your image asset path
                              width: 75,
                              height: 75,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final directory = await getApplicationDocumentsDirectory();
                              final file = File('${directory.path}/SampleReinforce');
                              if (await file.exists()) {
                                String contents = await file.readAsString();
                                List<String> lines = contents.split('\n');
                                String matchedLine = '';
                                int matchIndex = -1;

                                for (int i = 0; i < lines.length; i++) {
                                  String line = lines[i].trim();
                                  if (line.isNotEmpty && line.split('.')[0] == reinforceList[index].english) {
                                    matchedLine = line;
                                    matchIndex = i;
                                    break;
                                  }
                                }

                                if (matchIndex != -1) {
                                  lines.removeAt(matchIndex);
                                  lines.add(matchedLine);
                                  String updatedText = lines.join('\n').trim();
                                  await file.writeAsString(updatedText);
                                }
                              }
                              setState(() {
                                reinforceList.removeAt(index);
                              });
                            },
                            child: Image.asset(
                              'assets/greetings_icon.png',
                              // Replace with your image asset path
                              width: 50,
                              height: 50,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
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
        title: const Text('Common Phrases'), // remove if no title is to displayed
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 395,
              height: 70,
              child: banner('Level 1', // TODO: insert trophy icon
                  backgroundColor: Color.fromARGB(255, 230, 230,
                      230))), // TODO: change the dimensions to be phone dim dependent (ratio)
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
                  child: Text('Common Phrases',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 175, 244, 198)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 175, 244, 198)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 175, 244, 198)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          lsrButtons(context, 1, Color.fromARGB(255, 175, 244, 198)),

          
        ],
      )),
    );
  }


  Widget lsrButtons(BuildContext context, int id, Color buttonColor) {
    /* Style settings (Button/Text) */
    const spacer = SizedBox(height: 25);
    final ButtonStyle btnStyle = FilledButton.styleFrom(
      minimumSize: const Size(0, 80),
      backgroundColor: buttonColor,
      //backgroundColor: Color.fromARGB(255, 175, 244, 198),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
    );
    const TextStyle tStyle =
        TextStyle(fontWeight: FontWeight.w700, fontSize: 25);

    /* Actual Button Implementation */
    return Stack(children: <Widget>[
      Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        // LISTENING BUTTON
        FilledButton.tonal(
            style: btnStyle,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ListeningState();
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
                return _SpeakingState();
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
                return ReadingState();
              }));
            },
            child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: 3.7,
                child: const Text(
                  'Reading',
                  style: tStyle,
                ))),
              spacer, 
        
      ])
    ]);
  }
}

Widget banner(String text, {required Color backgroundColor, String subtext = '', Color textColor = Colors.black, Widget? icon}) {
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
                  fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
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

class _ListeningState extends State<ListeningState> {
  final player = AudioPlayer();
  final List<List<String>> common = [["I","Yo","F","F","F"], 
    ["You","Tú/Usted","F","F","F"], 
    ["He/She","Él/Ella","F","F","F"], 
    ["We","Nosotros","F","F","F"], 
    ["They","Ustedes","F","F","F"], 
    ["Please","Por favor","F","F","F"], 
    ["Thank you","Gracias","F","F","F"], 
    ["You’re welcome","De nada","F","F","F"], 
    ["Excuse me","Perdon","F","F","F"], 
    ["Sorry","Disculpa","F","F","F"]];
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController control = TextEditingController();
  //_ListeningState({Key? key}) : super(key:key);
  int quesNum = 0;
 
  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 35);
    final correct = common[quesNum][0];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
            'Listening! - *submodule*'), // remove if no title is to displayed
      ),
      body: Column( 
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text('Listening',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets\\listening.png.png',
              height: 250,
              width: 250,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding( 
                padding: EdgeInsets.only(right: 40),
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Color.fromARGB(255, 175, 244, 198)),
                  onPressed: () {
                    player.setPlaybackRate(1);
                    player.play(AssetSource('audio/haveaniceday.mp3'));
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
                    player.setPlaybackRate(0.5);
                    player.play(AssetSource('audio/haveaniceday.mp3'));
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
          
          listeningCheck(_formKey, control, common, quesNum, context),

          SizedBox(height: 150), // Space between questions and next button
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    quesNum = (quesNum + 1) % common.length;
                  });
                },
                child: Text('Next',
                  style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: Size(100, 50), // Button width and height
                  backgroundColor: Color.fromARGB(255, 135, 212, 161),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}

Widget listeningCheck(GlobalKey<FormState> _formKey, TextEditingController control, List<List<String>> words, int index, BuildContext context) {
 return Form(
    key: _formKey,
    child: Column ( 
      children: [
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
            controller: control,
            validator: (value) {
              if (value != words[index][0]) {    // TODO: figure out how to not need the 'incorrect'
                return '';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          )
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 280),
          child: ElevatedButton(
            onPressed: () {     // TODO: see if we can get a feedback container to display text based on validation
              if(_formKey.currentState!.validate()) {
                words[index][2] = "T";      // set listening check to true
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("You're correct!")),
                );
              }
              else {
                String word = words[index][0];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Sorry, the right answer is $word.")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:Color.fromARGB(255, 135, 212, 161)),
            child: const Text('Submit', style: TextStyle(color: Colors.black))
          ),
        ),
        
        // feedback(incorrect)
      ]
    ),
  );
}

//Color.fromARGB(255, 135, 212, 161),


class _ReadingState extends State<ReadingState> {
  
  final List<List<String>> common = [
    ["Hello", "Hola", "F", "F", "F"],
    ["Good morning", "Buenos días", "F", "F", "F"],
    ["Good afternoon", "Buenas tardes", "F", "F", "F"],
    ["Good night", "Buenas noches", "F", "F", "F"],
    ["My name is ___", "Me llamo ___", "F", "F", "F"],
    ["What is your name?", "¿Qué está tu nombre?", "F", "F", "F"],
    ["Nice to meet you", "Mucho gusto", "F", "F", "F"],
    ["How are you?", "¿Cómo estás?", "F", "F", "F"],
    ["Have a nice day", "Tengas un buen día", "F", "F", "F"],
    ["I'm good, and you?", "Estoy bien, ¿y tú?", "F", "F", "F"]
  ];

  int questionIndex = 0;
  String selectedAnswer = "";

  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 35);
    final random = Random();
    final question = random.nextInt(common.length);
    final correctanswer = common[question][0];

    //get random incorrect answers
    List<String> incorrectAnswers = [];
    while (incorrectAnswers.length < 3) {
      String randomAnswer = common[random.nextInt(common.length)][0];
      if (randomAnswer != correctanswer && !incorrectAnswers.contains(randomAnswer)) {
        incorrectAnswers.add(randomAnswer);
      }
    }
    //combine correct & incorrect & then SHUFFLE
    final answers = [correctanswer, ...incorrectAnswers]..shuffle();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading! - *submodule*'),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                'Reading',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          spacer,
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets\\osvaldo.png',
              height: 150,
              width: 250,
            ),
          ),
          spacer,
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 230, 230, 230),
              borderRadius: BorderRadius.circular(35.0),
            ),
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            width: 380,
            height: 100,
            child: Text(
              common[question][1],
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
              ),
            ),
    
          spacer,
          Container(
            width: 380,
            height: 275,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 175, 244, 198),
              borderRadius: BorderRadius.circular(35.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Choose one:',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4.0), // Space between text and buttons
                Column(
                  children: answers.map((answer) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: Color.fromARGB(255, 135, 212, 161),// Button color
                          minimumSize: Size(300, 40), // Button width and height
                          padding: EdgeInsets.symmetric(horizontal: 20), // Padding inside the button
                          alignment: Alignment.center,                        
                          ),

                        //feedback (snack bar)
                        onPressed: () {
                          final isCorrect = answer == correctanswer;
                          final snackBar = SnackBar(
                            content: Text(isCorrect ? 'Correct!' : 'Incorrect. Try again.'),
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: Text(
                          answer,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Space between questions and next button
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    questionIndex = (questionIndex + 1) % common.length;
                    selectedAnswer = "";
                  });
                },
                child: Text('Next'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: Size(100, 50), // Button width and height
                  backgroundColor: Color.fromARGB(255, 135, 212, 161),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _SpeakingState extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    const spacer = SizedBox(height: 35);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
              'Speaking! - *submodule*'), // remove if no title is to displayed
        ),
        body: Column(   
          //mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text('Speaking',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            spacer,

            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets\\speaking.png',
                height: 250,
                width: 250,
              ),
            ),

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
                  hintText: 'Sample Sentence!',
                  hintStyle: TextStyle(fontStyle: FontStyle.italic),
                  contentPadding: EdgeInsets.only(left: 10)
                )
              )
            ),

            spacer,

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding( 
                  padding: EdgeInsets.only(right: 20), 
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 95, 170, 120),
                      borderRadius: BorderRadius.circular(35.0)),
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.center,
                    width: 140,
                    height: 140,
                    child: Image.asset(
                      'assets\\microphone.png',
                      height: 140,
                      width: 140,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 175, 244, 198),
                        borderRadius: BorderRadius.circular(35.0),),
                      width: 200,
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Recorded Statement:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14),
                          ),
                    ),
                    SizedBox(height: 15), 
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 175, 244, 198),
                        borderRadius: BorderRadius.circular(35.0),),
                      width: 200,
                      height: 50,
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Feedback:',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14),)
                    ),
              ])
              ]),
            spacer,
          ],
        ));
  }
}
// TODO: Add Speaking State
// TODO: Add Progress State
// TODO: Add Quiz State

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
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                'Progress',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          spacer,
          lvl1(context, 1),
          SizedBox(height: 15),
          quiz1(context, 2),
          SizedBox(height: 60),
          lvl2(context, 2),
          SizedBox(height: 15),
          quiz2(context, 2),
          SizedBox(height: 60),
          lvl3(context, 3),
          SizedBox(height: 15),
          quiz3(context, 2),
        ],
      ),
    );
  }

  Widget lvl1(BuildContext context, int id) {
    //const spacer = SizedBox(height: 25);
    return Container(
      height: 90,
      width: 375,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 175, 244, 198),
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Level 1',
            style: TextStyle(fontSize: 25, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget lvl2(BuildContext context, int id) {
    //const spacer = SizedBox(height: 25);
    return Container(
      height: 90,
      width: 375,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 175, 244, 198),
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Level 2',
            style: TextStyle(fontSize: 25, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget lvl3(BuildContext context, int id) {
    //const spacer = SizedBox(height: 25);
    return Container(
      height: 90,
      width: 375,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 175, 244, 198),
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Level 3',
            style: TextStyle(fontSize: 25, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget quiz1(BuildContext context, int id) {
    //const spacer = SizedBox(height: 25);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 18),
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
        SizedBox(width: 18),
        Container(
          height: 70,
          width: 200,
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

//Greeting Submodule
class GreetingsModulePageState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Greetings'), // remove if no title is to displayed
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 395,
              height: 70,
              child: banner('Level 1',
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
                  child: Text('Greetings',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 135, 212, 161)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 135, 212, 161)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 135, 212, 161)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          lsrButtons(context, 1, Color.fromARGB(255, 135, 212, 161))
        ],
      )),
    );
  }
}

class DirectionsModulePageState extends StatelessWidget {


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
              child: banner('Level 1',
                  backgroundColor: Color.fromARGB(255, 230, 230,
                      230))), // TODO: change the dimensions to be phone dim dependent (ratio)
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
                  child: Text('Directions',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 95, 170, 120)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 95, 170, 120)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 95, 170, 120)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          lsrButtons(context, 1, Color.fromARGB(255, 95, 170, 120))
        ],
      )),
    );
  }
}

//TODO: add different screens

class IngredientsModulePageState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Ingredients'), // remove if no title is to displayed
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 395,
              height: 70,
              child: banner('Level 1',
                  backgroundColor: Color.fromARGB(255, 230, 230,
                      230))), // TODO: change the dimensions to be phone dim dependent (ratio)
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
                  child: Text('Ingredients',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 252, 209, 156)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 252, 209, 156)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 252, 209, 156)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          lsrButtons(context, 1, Color.fromARGB(255, 252, 209, 156))
        ],
      )),
    );
  }
}

class CookToolsModulePageState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Cooking Tools'), // remove if no title is to displayed
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 395,
              height: 70,
              child: banner('Level 1',
                  backgroundColor: Color.fromARGB(255, 230, 230,
                      230))), // TODO: change the dimensions to be phone dim dependent (ratio)
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
                  child: Text('Cooking Tools',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 237, 183, 133)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 237, 183, 133)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 237, 183, 133)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          lsrButtons(context, 1, Color.fromARGB(255, 237, 183, 133))
        ],
      )),
    );
  }
}

class OrdersModulePageState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Taking Orders'), // remove if no title is to displayed
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 395,
              height: 70,
              child: banner('Level 1',
                  backgroundColor: Color.fromARGB(255, 230, 230,
                      230))), // TODO: change the dimensions to be phone dim dependent (ratio)
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
                  child: Text('Taking Orders',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 206, 153, 104)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 206, 153, 104)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 206, 153, 104)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        
          lsrButtons(context, 1, Color.fromARGB(255, 206, 153, 104))
        ],
      )),
    );
  }
}

class HairCareModulePageState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Hair Care'), // remove if no title is to displayed
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 395,
              height: 70,
              child: banner('Level 1',
                  backgroundColor: Color.fromARGB(255, 230, 230,
                      230))), // TODO: change the dimensions to be phone dim dependent (ratio)
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
                  child: Text('Hair Care',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 210, 244, 248)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 210, 244, 248)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 210, 244, 248)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          lsrButtons(context, 1, Color.fromARGB(255, 210, 244, 248)),
         
        ],
      )),
    );
  }
}

class NailCareModulePageState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Nail Care'), // remove if no title is to displayed
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 395,
              height: 70,
              child: banner('Level 1',
                  backgroundColor: Color.fromARGB(255, 230, 230,
                      230))), // TODO: change the dimensions to be phone dim dependent (ratio)
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
                  child: Text('Nail Care',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 186, 231, 236)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 186, 231, 236)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 186, 231, 236)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          lsrButtons(context, 1, Color.fromARGB(255, 186, 231, 236)),
          
        ],
      )),
    );
  }
}

class SpaModulePageState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Spa'), // remove if no title is to displayed
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 395,
              height: 70,
              child: banner('Level 1',
                  backgroundColor: Color.fromARGB(255, 230, 230,
                      230))), // TODO: change the dimensions to be phone dim dependent (ratio)
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
                  child: Text('Spa',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 167, 214, 220)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 167, 214, 220)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 167, 214, 220)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          lsrButtons(context, 1, Color.fromARGB(255, 167, 214, 220)),
          //lsrButtons(context, 1, Color.fromARGB(255, 237, 183, 133))
        ],
      )),
    );
  }
}

class RentalsModulePageState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Rentals'), // remove if no title is to displayed
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 395,
              height: 70,
              child: banner('Level 1',
                  backgroundColor: Color.fromARGB(255, 230, 230,
                      230))), // TODO: change the dimensions to be phone dim dependent (ratio)
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
                  child: Text('Rentals',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 252, 250, 207)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 252, 250, 207)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 252, 250, 207)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          lsrButtons(context, 1, Color.fromARGB(255, 252, 250, 207)),
          
          //lsrButtons(context, 1, Color.fromARGB(255, 237, 183, 133))
        ],
      )),
    );
  }
}

class AirportModulePageState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Airport'), // remove if no title is to displayed
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 395,
              height: 70,
              child: banner('Level 1',
                  backgroundColor: Color.fromARGB(255, 230, 230,
                      230))), // TODO: change the dimensions to be phone dim dependent (ratio)
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
                  child: Text('Airport',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 245, 242, 170)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 245, 242, 170)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 245, 242, 170)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          lsrButtons(context, 1, Color.fromARGB(255, 245, 242, 170)),
          
          //lsrButtons(context, 1, Color.fromARGB(255, 237, 183, 133))
        ],
      )),
    );
  }
}

class HotelsModulePageState extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // setting style for home page (bg color)
      appBar: AppBar(
        title: const Text('Hotels'), // remove if no title is to displayed
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          // all widgets on home page
          SizedBox(
              width: 395,
              height: 70,
              child: banner('Level 1',
                  backgroundColor: Color.fromARGB(255, 230, 230,
                      230))), // TODO: change the dimensions to be phone dim dependent (ratio)
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
                  child: Text('Hotels',
                      style: TextStyle(
                          fontSize: 35.0, fontWeight: FontWeight.bold)))),
          // const SizedBox(width: 400, height: 100, child: Text('module')),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor:AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 236, 232, 144)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/listening.png.png',
                        height: 100,
                        width: 100,
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ),
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 236, 232, 144)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/speaking.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 140,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          width: 4,
                        ), 
                      ),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 236, 232, 144)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Image.asset(
                        'assets/osvaldo.png',
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          lsrButtons(context, 1, Color.fromARGB(255, 236, 232, 144)),
          
          //lsrButtons(context, 1, Color.fromARGB(255, 237, 183, 133))
        ],
      )),
    );
  }
}
