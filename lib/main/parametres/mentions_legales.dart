import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CompteParametresMentionLegale extends StatefulWidget {
  const CompteParametresMentionLegale({super.key});

  @override
  State<CompteParametresMentionLegale> createState() =>
      _CompteParametresMentionLegaleState();
}

class _CompteParametresMentionLegaleState
    extends State<CompteParametresMentionLegale> {
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  customText('Mis à jour le 01 Janvier 2024',
                      style: TextStyle(
                          fontSize: 12,
                          color: DARK,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              espacementWidget(height: 20),
              customText(
                  '''Sous réserve des conditions d'utilisation et de la politique de confidentialité, nos services sont fournis par qirha SARL.''',
                  maxLines: 10000,
                  style: TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    color: DARK,
                  )),
              espacementWidget(height: 20),
              customText('''
Adresse de bureau a Brazzaville:
01  Avenue...

Adresse de bureau a Pointe-Noire :

Numéro de téléphone : +242

Veuillez NE PAS envoyer de retours à l'adresse. Veuillez d'abord soumettre un ticket « Retour ou échange » au service client.

E-mail:
contact@qirha.net''',
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
