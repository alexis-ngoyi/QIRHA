import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:qirha/api/services.dart';

import 'package:qirha/functions/prix_promo_format.dart';
import 'package:qirha/model/produit.dart';
import 'package:qirha/res/utils.dart';

class SuggestionProduitWidget extends StatefulWidget {
  const SuggestionProduitWidget({super.key});

  @override
  State<SuggestionProduitWidget> createState() =>
      _SuggestionProduitWidgetState();
}

class _SuggestionProduitWidgetState extends State<SuggestionProduitWidget> {
  final List<ProduitModel> allProduits = <ProduitModel>[];
  getProduits() async {
    var produits = await ApiServices().getProduits();

    produits.forEach((produit) {
      setState(() {
        double pourcentage =
            double.parse(produit['pourcentage_reduction'].toString());
        double prix = double.parse(produit['prix']);
        double reduction = pourcentage * prix / 100;

        allProduits.add(ProduitModel(
            img: produit['image'].toString(),
            libelle: produit['nom'].toString(),
            prix: produit['prix'].toString(),
            reduction: reduction.toString(),
            description: produit['description'].toString(),
            isReduction: produit['pourcentage_reduction'] != 0,
            taux: produit['pourcentage_reduction'].toString(),
            produit_id: produit['produit_id'].toString(),
            prix_promo:
                promoPrix(produit['prix'], produit['pourcentage_reduction'])));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getProduits();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (allProduits.isNotEmpty) espacementWidget(height: 10),
        if (allProduits.isNotEmpty) informationLivraisonView(),
        if (allProduits.isNotEmpty) espacementWidget(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            children: [
              for (var i = 0; i < allProduits.length; i++)
                cardImageProduit(context, produit: allProduits[i]),
            ],
          ),
        ),
        if (allProduits.isNotEmpty) espacementWidget(height: 120)
      ],
    );
  }
}
