// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/main/bottom_nav/tab_panier.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class MyCartWidget extends StatefulWidget {
  const MyCartWidget({super.key, this.size = 25, required this.color});
  final double size;
  final Color color;

  @override
  State<MyCartWidget> createState() => _MyCartWidgetState();
}

class _MyCartWidgetState extends State<MyCartWidget> {
  int cart = 0;
  late Timer main_timer;
  bool isLogged = false;

  loadCart() async {
    var utilisateur_id = prefs.getString('utilisateur_id');

    // Define the interval duration in milliseconds
    const intervalDuration = Duration(seconds: 1);

    if (utilisateur_id != null) {
      // Set up a periodic timer
      main_timer = Timer.periodic(intervalDuration, (timer) async {
        var articles =
            await ApiServices().getPanierUtilisateur(utilisateur_id.toString());

        setState(() {
          cart = articles.length;
          isLogged = true;
        });

        timer.cancel();
      });
    } else {
      setState(() {
        isLogged = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  @override
  void dispose() {
    super.dispose();
    main_timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CustomPageRoute(
          TabPanierScreen(
            canReturn: true,
          ),
          context),
      child: Stack(
        children: [
          HeroIcon(
            HeroIcons.shoppingCart,
            color: widget.color,
            size: widget.size,
          ),
          if (isLogged)
            Positioned(
                right: 0,
                child: cart < 10
                    ? Container(
                        height: 13,
                        width: 13,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: BLUE,
                            borderRadius: BorderRadius.circular(100)),
                        child: Center(
                          child: customText('$cart',
                              style: TextStyle(fontSize: 6, color: WHITE)),
                        ),
                      )
                    : Container(
                        height: 13,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: BLUE,
                            borderRadius: BorderRadius.circular(100)),
                        child: Center(
                          child: customText('$cart',
                              style: TextStyle(fontSize: 6, color: WHITE)),
                        ),
                      ))
        ],
      ),
    );
  }
}
