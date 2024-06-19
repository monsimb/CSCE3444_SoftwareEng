// ignore_for_file: unused_import, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'bannerwidget.dart'; //import banner widget
import 'package:logger/logger.dart';

class FifthPage extends StatelessWidget {
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice Skills', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 400,
            height: 100,
            child: BannerWidget(
              title: 'Practice your Listening',
              subtext: 'Improve your Listening Skills!',
              backgroundColor: Color.fromARGB(250, 175, 244, 198),
              onTap: () {
                //Navigator.push(
                  //context,
                  //MaterialPageRoute(builder: (context) => SecondScreen()),
                //);
                logger.d('Banner tapped!');
              },
            ),
          ),
          
          const SizedBox(height:16),

          SizedBox(
            width: 400,
            height: 100,
            child: BannerWidget(
              title: 'Practice your Speaking',
              subtext: 'Work on Speaking Skills!',
              backgroundColor: Color.fromARGB(250, 175, 244, 198),
            ),
          ),

          const SizedBox(height:16),

          SizedBox(
            width: 400,
            height: 100,
            child: BannerWidget(
              title: 'Practice your Reading',
              subtext: 'Practice your Reading Skills!',
              backgroundColor: Color.fromARGB(250, 175, 244, 198),
            ),
          ),

          const SizedBox(height:20),

          SizedBox(
            width: 400,
            height: 200,
            child: BannerWidget(
              title: 'Progress',
              subtext: 'Check on your recent progress!',
              backgroundColor: Color.fromARGB(255, 135, 212, 161),
            ),
          ),
        ],
      ),
    );
  }
}




/*
class Fifthpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example Module'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300,
            height: 70,
            child: BannerWidget(
              title: 'Practice your Listening',
              backgroundColor: Colors.brown),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Fifth page',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      );
    }
  }
  */