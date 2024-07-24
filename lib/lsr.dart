import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Color progressColor;

  const AnimatedProgressBar({
    Key? key,
    required this.progress,
    required this.progressColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 3,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: progress),
        duration: Duration(seconds: 2),
        builder: (context, value, child) {
          return ClipRRect( 
            borderRadius: BorderRadius.circular(10.0),
            child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
           ),
          );
        },
      ),
    );
  }

}