import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';

import 'package:qirha/model/model_produit_taille.dart';
import 'package:qirha/model/produit.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class TailleProduitPicker extends StatefulWidget {
  const TailleProduitPicker(
      {super.key, required this.selectedTailleProduit, required this.produit});
  final void Function(ProduitTailleModel selectedTailleProduit)
      selectedTailleProduit;
  final ProduitModel produit;

  @override
  State<TailleProduitPicker> createState() => _TailleProduitPickerState();
}

class _TailleProduitPickerState extends State<TailleProduitPicker> {
  late int currentIndex = 0;
  ProduitTailleModel? currentTailleProduit;

  final List<ProduitTailleModel> produitTailles = <ProduitTailleModel>[];
  getProduitTailles() async {
    var tailles =
        await ApiServices().getProduitsTailles(widget.produit.produit_id);

    tailles.forEach((taille) {
      setState(() {
        produitTailles.add(ProduitTailleModel(
            code_taille: taille['taille']['code_taille'],
            taille_id: taille['taille']['taille_id'].toString(),
            nom_taille: taille['taille']['nom_taille']));
      });

      // select default
      currentTailleProduit = produitTailles[currentIndex];

      // emit taille
      widget.selectedTailleProduit.call(produitTailles[currentIndex]);
    });
  }

  @override
  void initState() {
    super.initState();
    getProduitTailles();
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                customText(
                  'Taille :',
                  style: TextStyle(color: LIGHT, fontSize: 10),
                ),
                if (currentTailleProduit != null)
                  customText(
                    ' ${currentTailleProduit?.code_taille}',
                    style: TextStyle(
                        color: DARK, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            Row(
              children: [
                HeroIcon(
                  HeroIcons.clipboardDocumentList,
                  color: BLUE,
                  size: 14,
                ),
                espacementWidget(width: 5),
                customText('Tableau des tailles',
                    style: TextStyle(color: DARK, fontSize: 11))
              ],
            )
          ],
        ),
        espacementWidget(height: 10),
        SizedBox(
          height: 25,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: produitTailles.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentTailleProduit = produitTailles[index];
                      currentIndex = index;
                      widget.selectedTailleProduit.call(produitTailles[index]);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            width: 1,
                            color:
                                currentTailleProduit == produitTailles[index] &&
                                        currentIndex == index
                                    ? BLUE
                                    : Colors.black.withOpacity(.1))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: customText(
                                produitTailles[index].code_taille as String,
                                style: const TextStyle(fontSize: 11)),
                          )),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
