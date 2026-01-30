import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/model/all_model.dart';
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
        allProduits.add(
          ProduitModel(
            nom: produit['nom'],
            url_image: produit['url_image'],
            status: produit['status'],
            description: produit['description'],
            est_en_promo: produit['est_en_promo'],
            taux_reduction: parseDouble(produit['taux_reduction']),
            prix_promo: parseDouble(produit['prix_promo']),
            prix_minimum: parseDouble(produit['prix_minimum']),
            cree_le: produit['cree_le'],
            date_fin: produit['date_fin'],
            fournisseur_id: produit['fournisseur_id'].toString(),
            nom_fournisseur: produit['nom_fournisseur'],
            produit_id: produit['produit_id'].toString(),
            prix_produit_id: produit['prix_produit_id'].toString(),
          ),
        );
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
                ProduitCardView(context, produit: allProduits[i]),
            ],
          ),
        ),
        if (allProduits.isNotEmpty) espacementWidget(height: 120),
      ],
    );
  }
}
