import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CustomTimerCountDown extends StatefulWidget {
  const CustomTimerCountDown({super.key});

  @override
  State<CustomTimerCountDown> createState() => _CustomTimerCountDownState();
}

class _CustomTimerCountDownState extends State<CustomTimerCountDown> {
  late Timer _timer;
  late int _totalDurationInSeconds = 3600 * 10;
  late String hours = '00';
  late String minutes = '00';
  late String remainingSeconds = '00';

  void _onTimerTick(Timer timer) {
    setState(() {
      if (_totalDurationInSeconds > 0) {
        _totalDurationInSeconds--;
      } else {
        _timer.cancel();
      }
    });
  }

  String _twoDigitFormatter(int n) => n.toString().padLeft(2, '0');

  void _formatDuration(int seconds) {
    setState(() {
      hours = _twoDigitFormatter(seconds ~/ 3600);
      minutes = _twoDigitFormatter((seconds % 3600) ~/ 60);
      remainingSeconds = _twoDigitFormatter(seconds % 60);
    });
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), _onTimerTick);
    hours = '00';
    minutes = '00';
    remainingSeconds = '00';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger countdown
    if (_totalDurationInSeconds > 0) _formatDuration(_totalDurationInSeconds);

    return Row(
      children: [
        customText(
          'Se termine dans',
          style: TextStyle(fontSize: 10, color: WHITE),
        ),
        espacementWidget(width: 4),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: WHITE,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: customText(
              hours,
              style: TextStyle(fontSize: 8, color: PRIMARY),
            ),
          ),
        ),
        customText(':', style: TextStyle(fontSize: 10, color: WHITE)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: WHITE,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: customText(
              minutes,
              style: TextStyle(fontSize: 8, color: PRIMARY),
            ),
          ),
        ),
        customText(':', style: TextStyle(fontSize: 10, color: WHITE)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            color: WHITE,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: customText(
              remainingSeconds,
              style: TextStyle(fontSize: 8, color: PRIMARY),
            ),
          ),
        ),
      ],
    );
  }
}
