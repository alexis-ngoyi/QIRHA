import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CompteParametresQuiSommesNous extends StatefulWidget {
  const CompteParametresQuiSommesNous({super.key});

  @override
  State<CompteParametresQuiSommesNous> createState() =>
      _CompteParametresQuiSommesNousState();
}

class _CompteParametresQuiSommesNousState
    extends State<CompteParametresQuiSommesNous> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
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
          'qirha - Vente en ligne - Accessibilite',
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              espacementWidget(height: 20),
              customText('A propos de qirha',
                  style: TextStyle(
                      fontSize: 15, color: DARK, fontWeight: FontWeight.bold)),
              espacementWidget(height: 20),
              customText(
                  '''qirha est une entreprise congolaise de vente au détail en ligne qui livre des produits directement aux consommateurs sur tout le territoire congolais. Fondée en 2024, qirha a permis à ses clients d'acheter une large sélection de produits de style de vie à des prix attractifs sur la plateforme, disponible dans plusieurs langues étrangères.''',
                  maxLines: 10000,
                  style: TextStyle(
                    fontSize: 11,
                    overflow: TextOverflow.ellipsis,
                    color: DARK,
                  )),
              espacementWidget(height: 20),
              customText(
                  '''qirha offre des produits dans les catégories des vêtements et d'autres marchandises générales..''',
                  maxLines: 10000,
                  style: TextStyle(
                    fontSize: 11,
                    overflow: TextOverflow.ellipsis,
                    color: DARK,
                  )),
              espacementWidget(height: 20),
              customText(
                  "Le modèle d'entreprise innovant de qirha, basé sur les données, lui permet d'offrir des produits personnalisés, tels que des robes de mariée et des robes de soirée, à l'échelle permettant un marketing, un merchandising et un traitement des commandes optimaux.",
                  maxLines: 10000,
                  style: TextStyle(
                    fontSize: 11,
                    overflow: TextOverflow.ellipsis,
                    color: DARK,
                  )),
              espacementWidget(height: 20),
              customText('''
NIU : 

RCCM : 

SIRET : 

Adresse : 

E-mail : contact@qirha.net

Telephone : +242
''',
                  maxLines: 10000,
                  style: TextStyle(
                    fontSize: 11,
                    overflow: TextOverflow.ellipsis,
                    color: DARK,
                  )),
              espacementWidget(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
