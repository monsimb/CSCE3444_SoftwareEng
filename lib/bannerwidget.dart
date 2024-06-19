// ignore_for_file: unused_import

import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  final String title;
  final String subtext;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  const BannerWidget({
    super.key,
    required this.title,
    this.subtext = '',
    required this.backgroundColor,
    this.textColor = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
           padding: const EdgeInsets.only(bottom: 8.0), 
            child: 
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          if (subtext.isNotEmpty)
            Text(
              subtext,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
              ),
            ),
        ],
      ),
    ),
    );
  }
}


/*class BannerWidget extends StatelessWidget {
  final String title;
  final String subtext;
  final Color backgroundColor;
  final Color textColor;

  const BannerWidget({
    super.key,
    required this.title,
    this.subtext = '',
    required this.backgroundColor,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
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
            subtext,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
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
}   
    
*/    
    
    
    /*
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          if (subtext != null)
            Text(
              subtext!,
              style: const TextStyle(fontSize: 16.0),
            ),
        ],
      ),
    );
  }
*/

