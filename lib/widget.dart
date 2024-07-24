// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
              spacer, 
        /*
        // PROGRESS BUTTON
        FilledButton.tonal(
          style : FilledButton.styleFrom(
          minimumSize: const Size(0, 175),
          backgroundColor: Color.fromARGB(255, 135, 212, 161),
          shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40),),),),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return _ProgressState ();
              }));
            },
            child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: 3.4,
                child: const Text(
                  'Progress',
                  style: tStyle,
                ))),
      */
      ])
    ]);
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
            spacer,

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
            
            spacer,

            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 175, 244, 198),
                borderRadius: BorderRadius.circular(35.0),
              ),
              width: 200,
              height: 50,
              child: const Text(
                'Feedback:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  
                ),
              ),
            )
          ],
        ));
        
        
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
                    hintText: 'Statement/Passage display.',
                    hintStyle: TextStyle(fontStyle: FontStyle.italic),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                ),
              
            ),
            spacer,

            Positioned(
              bottom: 20,
              child: Container(
                width: 380,
                height: 200,
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 175, 244, 198),
                  borderRadius: BorderRadius.circular(35.0),
                ),
                child: Text(
                  'Question Prompt',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  //textAlign: TextAlign.left,
                ),
              ),
            ),
            
          ],
        )
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

class FoodProgressState extends StatelessWidget {
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

class BeautyProgressState extends StatelessWidget {
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

class TravelProgressState extends StatelessWidget {
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