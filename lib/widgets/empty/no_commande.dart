import 'package:flutter/material.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class NoCommandeWidget extends StatefulWidget {
  const NoCommandeWidget({super.key});

  @override
  State<NoCommandeWidget> createState() => _NoCommandeWidgetState();
}

class _NoCommandeWidgetState extends State<NoCommandeWidget> {
  @override
  Widget build(BuildContext context) {
    return emptyCommandes();
  }

  Center emptyCommandes() {
    return Center(
      child: Column(
        children: [
          const Image(image: AssetImage(empty_cart), height: 230, width: 230),
          customText(
            'La liste de commandes est vide',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          customText(
            'Veuillez achetez maintenant ou consulter votre panier',
            style: const TextStyle(fontSize: 12),
          ),
          espacementWidget(height: 10),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: WHITE,
                    border: Border.all(width: 1, color: WHITE),
                  ),
                  child: customText(
                    'Achetez Maintenant',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: DARK,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  color: PRIMARY,
                  padding: const EdgeInsets.all(6),
                  child: customText(
                    'Mon panier',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: WHITE,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
