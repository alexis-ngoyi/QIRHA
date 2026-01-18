import 'package:flutter/material.dart';
import 'package:qirha/api/services.dart';

import 'package:qirha/functions/format_color.dart';
import 'package:qirha/model/model_produit_couleur.dart';
import 'package:qirha/model/produit.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CouleurProduitPicker extends StatefulWidget {
  const CouleurProduitPicker(
      {super.key,
      required this.selectedCouleurProduit,
      required this.produit,
      required this.defaultSelectedCouleur});
  final void Function(ProduitCouleurModel selectedCouleurProduit)
      selectedCouleurProduit;
  final ProduitModel produit;
  final int defaultSelectedCouleur;

  @override
  State<CouleurProduitPicker> createState() => _CouleurProduitPickerState();
}

class _CouleurProduitPickerState extends State<CouleurProduitPicker> {
  int currentIndex = 0;
  ProduitCouleurModel? currentCouleurProduit;

  List<ProduitCouleurModel> produitCouleurs = <ProduitCouleurModel>[];
  getProduitCouleurs() async {
    setState(() {
      produitCouleurs = [];
    });

    var couleurs =
        await ApiServices().getProduitsCouleurs(widget.produit.produit_id);

    couleurs.forEach((couleur) {
      setState(() {
        produitCouleurs.add(ProduitCouleurModel(
            code_couleur: formatColor(couleur['couleur']['code_couleur']),
            couleur_id: couleur['couleur']['couleur_id'].toString(),
            nom_couleur: couleur['couleur']['nom_couleur']));
      });
    });

    // select default

    setState(() {
      currentCouleurProduit = produitCouleurs[currentIndex];
    });

    // emit couleur
    widget.selectedCouleurProduit.call(produitCouleurs[currentIndex]);
  }

  @override
  void didUpdateWidget(covariant CouleurProduitPicker oldWidget) {
    if (widget.defaultSelectedCouleur != oldWidget.defaultSelectedCouleur) {
      print(
          'defaultSelectedCouleur changed to ${widget.defaultSelectedCouleur}');
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    getProduitCouleurs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            customText(
              'Couleur : ',
              style: TextStyle(color: LIGHT, fontSize: 10),
            ),
            if (currentCouleurProduit != null)
              customText(
                '${currentCouleurProduit!.nom_couleur}',
                style: TextStyle(
                    color: DARK, fontSize: 10, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        espacementWidget(height: 10),
        SizedBox(
          height: 35,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: produitCouleurs.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentCouleurProduit = produitCouleurs[index];
                      currentIndex = index;
                      widget.selectedCouleurProduit
                          .call(produitCouleurs[index]);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.all(3),
                    decoration:
                        currentCouleurProduit == produitCouleurs[index] &&
                                currentIndex == index
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(width: 1, color: BLUE))
                            : null,
                    child: Container(
                      width: 15,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: produitCouleurs[index].code_couleur),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
