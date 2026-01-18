import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/main/bottom_nav/compte/parametres/securite_compte.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class CompteParametresMonCompte extends StatefulWidget {
  const CompteParametresMonCompte({super.key});

  @override
  State<CompteParametresMonCompte> createState() =>
      _CompteParametresMonCompteState();
}

class _CompteParametresMonCompteState extends State<CompteParametresMonCompte> {
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
          'Mon Compte',
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
                label: 'Photo de Profil',
                trailingLabel: '',
                actions: [
                  roundedImageContainer(
                      image: app_icon, width: 35, height: 35, http: false),
                  espacementWidget(width: 5),
                  const HeroIcon(
                    HeroIcons.chevronRight,
                    size: 16,
                  )
                ],
                route: Placeholder()),
            espacementWidget(height: 8),
            listLinkItem(context,
                label: 'E-mail',
                trailingLabel: 'contact@qirha.net',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: 'Securite du compte',
                trailingLabel: '',
                actions: [],
                route: const CompteParametresSecuriteCompte()),
            espacementWidget(height: 8),
            listLinkItem(context,
                label: "Nom d'utilisateur",
                trailingLabel: 'Alexis Mavy Ngoyi Moussounda',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: 'Date de Naissance',
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: 'Sexe',
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: 'Numero de telephone',
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: 'Adresse domicile',
                trailingLabel: 'N. Rue/Avenue',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: 'Ville',
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: "Arrondissement",
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: "Quartier",
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: "Reference",
                trailingLabel: '',
                actions: [],
                route: Placeholder()),
            listLinkItem(context,
                label: "Coordonnees Maps",
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
