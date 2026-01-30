import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CompteParametresSecuriteCompte extends StatefulWidget {
  const CompteParametresSecuriteCompte({super.key});

  @override
  State<CompteParametresSecuriteCompte> createState() =>
      _CompteParametresSecuriteCompteState();
}

class _CompteParametresSecuriteCompteState
    extends State<CompteParametresSecuriteCompte> {
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
          'Securite du Compte',
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
            espacementWidget(height: 8),
            listLinkItem(context,
                label: 'Supprimer le compte',
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: "Geler le compte",
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            espacementWidget(height: 20)
          ],
        ),
      ),
    );
  }
}
