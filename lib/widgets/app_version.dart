import 'package:flutter/material.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class qirhaVersion extends StatelessWidget {
  const qirhaVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return customText('Version 1.0.0',
        style: TextStyle(color: LIGHT, fontSize: 12));
  }
}
