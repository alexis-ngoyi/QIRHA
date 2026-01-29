import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class MissingPermissionScreen extends StatefulWidget {
  const MissingPermissionScreen({super.key});

  @override
  State<MissingPermissionScreen> createState() =>
      _MissingPermissionScreenState();
}

class _MissingPermissionScreenState extends State<MissingPermissionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customText(
              'Autorisation',
              style: TextStyle(
                color: PRIMARY,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            espacementWidget(height: 10),
            SizedBox(
              width: 250,
              child: customText(
                "Nous n'avaons pas les autorisations necessaire pour activer cette fonctionnalite",
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DARK,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            espacementWidget(height: 10),
            GestureDetector(
              onTap: () => reloadPermissions(context),
              child: Container(
                decoration: BoxDecoration(
                  color: PRIMARY,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: customText(
                  'Autoriser ?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: WHITE,
                  ),
                ),
              ),
            ),
          ],
        ).asGlass(tintColor: PRIMARY, blurX: 2.0, blurY: 2.0),
      ),
    );
  }
}
