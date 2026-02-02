// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/widgets/need_to_login.dart';
import 'package:qirha/main/compte/favoris.dart';
import 'package:qirha/main/compte/historique.dart';
import 'package:qirha/main/parametres/parametres.dart';
import 'package:qirha/main/compte/souscriptions.dart';
import 'package:qirha/main/bottom_nav/tab_mes_commandes.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class TabMonCompteScreen extends StatefulWidget {
  const TabMonCompteScreen({super.key});

  @override
  State<TabMonCompteScreen> createState() => _TabMonCompteScreenState();
}

class _TabMonCompteScreenState extends State<TabMonCompteScreen> {
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
      appBar: CompteAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (needToLogin == false)
              Container(
                color: WHITE,
                padding: const EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    iconLabelledItem(
                      icon: HeroIcons.heart,
                      text: 'Favoris',
                      onTap: () =>
                          CustomPageRoute(const CompteFavoris(), context),
                    ),
                    iconLabelledItem(
                      icon: HeroIcons.calendar,
                      text: 'Historique',
                      onTap: () =>
                          CustomPageRoute(const CompteHistorique(), context),
                    ),
                    iconLabelledItem(
                      icon: HeroIcons.gift,
                      text: 'Offrir un cadeau',
                      onTap: () {},
                    ),
                    iconLabelledItem(
                      icon: HeroIcons.banknotes,
                      text: 'Portefeuille',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            espacementWidget(height: 10),
            (needToLogin == true)
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 40),
                    child: requestLogin(context),
                  )
                : (needToLogin == false
                      ? const SizedBox()
                      : const Center(child: CircularProgressIndicator())),
            if (needToLogin == false) mesCommandeView(context),
            espacementWidget(height: 10),
            nosServicesView(context),
            espacementWidget(height: 40),
          ],
        ),
      ),
    );
  }

  Container nosServicesView(BuildContext context) {
    return Container(
      color: WHITE,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                  'Autres',
                  style: TextStyle(
                    fontSize: 15,
                    color: DARK,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: const Row(
                    children: [
                      // customText(
                      //   'Tous',
                      //   style: TextStyle(fontSize: 12, color: DARK),
                      // ),
                      // espacementWidget(width: 5),
                      // const HeroIcon(
                      //   HeroIcons.chevronRight,
                      //   size: 14,
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: WHITE,
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                iconLabelledItem(
                  icon: HeroIcons.signal,
                  text: 'Nous recrutons',
                  onTap: () {},
                ),
                iconLabelledItem(
                  icon: HeroIcons.user,
                  text: 'Inscription',
                  onTap: () {},
                ),
                iconLabelledItem(
                  icon: HeroIcons.phoneArrowUpRight,
                  text: 'Assistance',
                  onTap: () {},
                ),
                iconLabelledItem(
                  icon: HeroIcons.rss,
                  text: 'Souscription E-mail',
                  onTap: () => CustomPageRoute(
                    const CompteSouscriptionsEmail(),
                    context,
                  ),
                ),
                iconLabelledItem(
                  icon: HeroIcons.envelope,
                  text: 'Commentaires',
                  onTap: () {},
                ),
                iconLabelledItem(
                  icon: HeroIcons.share,
                  text: 'Partager',
                  onTap: () {},
                ),
                iconLabelledItem(
                  icon: HeroIcons.chatBubbleLeftRight,
                  text: 'FAQ',
                  onTap: () {},
                ),
                iconLabelledItem(
                  icon: HeroIcons.userPlus,
                  text: 'Parrainner',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container mesCommandeView(BuildContext context) {
    return Container(
      color: WHITE,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                customText(
                  'Mes commandes',
                  style: TextStyle(
                    fontSize: 15,
                    color: DARK,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => CustomPageRoute(
                    const TabMesCommandesScreen(
                      initialIndex: 0,
                      canReturn: true,
                    ),
                    context,
                  ),
                  child: Row(
                    children: [
                      customText(
                        'Toutes les commandes',
                        style: TextStyle(fontSize: 12, color: DARK),
                      ),
                      espacementWidget(width: 5),
                      const HeroIcon(HeroIcons.chevronRight, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: WHITE,
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                iconLabelledItem(
                  icon: HeroIcons.wallet,
                  text: 'Non Payee',
                  onTap: () => CustomPageRoute(
                    const TabMesCommandesScreen(
                      initialIndex: 1,
                      canReturn: true,
                    ),
                    context,
                  ),
                ),
                iconLabelledItem(
                  icon: HeroIcons.arrowLeftOnRectangle,
                  text: 'Preparation',
                  onTap: () => CustomPageRoute(
                    const TabMesCommandesScreen(
                      initialIndex: 2,
                      canReturn: true,
                    ),
                    context,
                  ),
                ),
                iconLabelledItem(
                  icon: HeroIcons.truck,
                  text: 'Expedie',
                  onTap: () => CustomPageRoute(
                    const TabMesCommandesScreen(
                      initialIndex: 3,
                      canReturn: true,
                    ),
                    context,
                  ),
                ),
                iconLabelledItem(
                  icon: HeroIcons.envelopeOpen,
                  text: 'Donner un avis',
                  onTap: () => CustomPageRoute(
                    const TabMesCommandesScreen(
                      initialIndex: 4,
                      canReturn: true,
                    ),
                    context,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector iconLabelledItem({
    required HeroIcons icon,
    required String text,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 85,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroIcon(icon, size: 24),
              espacementWidget(height: 4),
              Center(
                child: customCenterText(
                  text,
                  softWrap: true,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: DARK),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar CompteAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: WHITE,
      title: customText(
        needToLogin == false
            ? 'Bonjour, John Doe'
            : 'Bonjour, cher.e visiteur.e',
        style: TextStyle(
          fontSize: 17,
          color: DARK,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () => {},
          child: const HeroIcon(HeroIcons.share, size: 21),
        ),
        espacementWidget(width: 15),
        GestureDetector(
          onTap: () => {},
          child: const HeroIcon(HeroIcons.bellAlert, size: 21),
        ),
        espacementWidget(width: 15),
        GestureDetector(
          onTap: () => CustomPageRoute(const CompteParametres(), context),
          child: const HeroIcon(HeroIcons.cog8Tooth, size: 21),
        ),
        espacementWidget(width: 15),
      ],
    );
  }
}
