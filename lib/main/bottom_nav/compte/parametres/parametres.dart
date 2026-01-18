// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/widgets/app_version.dart';
import 'package:qirha/main/bottom_nav/compte/parametres/accessibilite.dart';
import 'package:qirha/main/bottom_nav/compte/parametres/compte.dart';
import 'package:qirha/main/bottom_nav/compte/parametres/mentions_legales.dart';
import 'package:qirha/main/bottom_nav/compte/parametres/qui_sommes_nous.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class CompteParametres extends StatefulWidget {
  const CompteParametres({super.key});

  @override
  State<CompteParametres> createState() => _CompteParametresState();
}

class _CompteParametresState extends State<CompteParametres> {
  late String? utilisateur_id;
  bool? needToLogin;
  late Timer main_timer;

  authGuard() {
    // Define the interval duration in milliseconds
    const intervalDuration = Duration(seconds: 1);

    // Set up a periodic timer
    main_timer = Timer.periodic(intervalDuration, (timer) async {
      if (utilisateur_id == null) {
        setState(() {
          needToLogin = true;
        });
      } else {
        setState(() {
          needToLogin = false;
        });
      }
      timer.cancel();
    });
  }

  @override
  void initState() {
    super.initState();
    utilisateur_id = prefs.getString('utilisateur_id');
    authGuard();
  }

  @override
  void dispose() {
    super.dispose();
    main_timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      appBar: AppBar(
        backgroundColor: WHITE,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const HeroIcon(
            HeroIcons.chevronLeft,
            size: 25,
          ),
        ),
        title: customText(
          'Parametres',
          style:
              TextStyle(fontSize: 17, color: DARK, fontWeight: FontWeight.bold),
        ),
        actions: [
          espacementWidget(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (needToLogin == false) espacementWidget(height: 8),
            if (needToLogin == false)
              listLinkItem(context,
                  label: 'Mon Compte',
                  actions: [],
                  route: const CompteParametresMonCompte()),
            espacementWidget(height: 8),
            listLinkItem(context,
                label: 'Pays',
                trailingLabel: 'Republique du Congo',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: 'Langue',
                trailingLabel: 'Francais',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: 'Monnaie',
                trailingLabel: 'XAF',
                actions: [],
                route: Placeholder()),
            espacementWidget(height: 8),
            listLinkItem(context,
                label: 'Evaluer qirha',
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: 'Suivez-nous',
                trailingLabel: '',
                actions: [
                  roundedImageContainer(
                      image: whatsapp, width: 21, height: 21, http: false),
                  roundedImageContainer(
                      image: facebook, width: 21, height: 21, http: false)
                ],
                route: Placeholder()),
            espacementWidget(height: 8),
            listLinkItem(context,
                label: 'Accessibilite',
                trailingLabel: '',
                actions: [],
                route: const CompteParametresAccessibilite()),
            listLinkItem(context,
                label: 'Qui sommes-nous',
                trailingLabel: '',
                actions: [],
                route: const CompteParametresQuiSommesNous()),
            listLinkItem(context,
                label: 'Mentions legales',
                trailingLabel: '',
                actions: [],
                route: const CompteParametresMentionLegale()),
            listLinkItem(context,
                label: 'Politique des retours',
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: "Conditions d'utilisation",
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: "Politique de confidentialite",
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: "Droit de propriete intellectuelle",
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            espacementWidget(height: 20),
            if (needToLogin == false)
              GestureDetector(
                onTap: () {
                  prefs.remove('utilisateur_id');
                  Navigator.of(context).popAndPushNamed('/');
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.all(12.0),
                  color: WHITE,
                  child: const Center(
                    child: Text('Deconnexion'),
                  ),
                ),
              ),
            espacementWidget(height: 7),
            const Center(
              child: qirhaVersion(),
            ),
            espacementWidget(height: 20),
          ],
        ),
      ),
    );
  }
}
