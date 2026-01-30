import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CompteParametresAccessibilite extends StatefulWidget {
  const CompteParametresAccessibilite({super.key});

  @override
  State<CompteParametresAccessibilite> createState() =>
      _CompteParametresAccessibiliteState();
}

class _CompteParametresAccessibiliteState
    extends State<CompteParametresAccessibilite> {
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
              espacementWidget(height: 8),
              Center(
                  child: customText('ACCESSIBILITE',
                      style: TextStyle(
                          fontSize: 14,
                          color: DARK,
                          fontWeight: FontWeight.bold))),
              espacementWidget(height: 20),
              customText('Notre politique',
                  style: TextStyle(
                      fontSize: 12, color: DARK, fontWeight: FontWeight.bold)),
              espacementWidget(height: 20),
              customText(
                  '''qirha améliore continuellement l'accessibilité de notre application mobile et de tous les actifs numériques que nous y proposons. qirha s'efforce de créer des opportunités égales pour les personnes handicapées de visiter notre plaeforme ou d'utiliser nos services. Cependant, la technologie actuelle et d'autres restrictions limitent parfois l'accessibilité a la plateforme, c'est pourquoi l'accessibilité est un effort continu pour nous.''',
                  maxLines: 10000,
                  style: TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    color: DARK,
                  )),
              espacementWidget(height: 20),
              customText("Besoins en matière d'accessibilité",
                  style: TextStyle(
                      fontSize: 12, color: DARK, fontWeight: FontWeight.bold)),
              espacementWidget(height: 20),
              customText(
                  '''Si vous avez des questions ou rencontrez des problèmes lors de la navigation sur notre plateforme, veuillez nous contacter par e-mail à l'adresse accessibilite@qirha.net. Nous vous aiderons à accéder à notre plateforme et vos commentaires nous aident également à améliorer notre application pour les autres. Nous voulons vous aider à surmonter tous les problèmes que vous rencontrez et vous offrir une expérience de magasinage aussi agréable que possible.''',
                  maxLines: 10000,
                  style: TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    color: DARK,
                  )),
              espacementWidget(height: 20),
              customText("Liens vers du contenu tiers",
                  style: TextStyle(
                      fontSize: 12, color: DARK, fontWeight: FontWeight.bold)),
              espacementWidget(height: 20),
              customText(
                  "Sous réserve de la section 11 des conditions d'utilisation, notre plateforme peut inclure des liens vers des sites Web tiers et peut inclure ou utiliser du contenu tiers intégré pour partager des informations. Nous ne pouvons pas contrôler ou corriger les problèmes liés à ces sites Web tiers. Si vous rencontrez des problèmes, vous souhaiterez peut-être également adresser vos préoccupations directement à ces tiers.",
                  maxLines: 10000,
                  style: TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    color: DARK,
                  )),
              customText("Comment nous contacter",
                  style: TextStyle(
                      fontSize: 12, color: DARK, fontWeight: FontWeight.bold)),
              espacementWidget(height: 20),
              customText(
                  "En bref, si vous rencontrez des difficultés pour accéder à notre plateforme ou aux sites liés, veuillez nous contacter à l'adresse accessibilite@qirha.net. Notre représentant en service coordonnera les problèmes et communiquera de notre mieux avec l'opérateur des sites liés.",
                  maxLines: 10000,
                  style: TextStyle(
                    fontSize: 12,
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
