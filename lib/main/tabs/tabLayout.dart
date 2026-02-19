// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/model/all_model.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class TabLayout extends StatefulWidget {
  const TabLayout({super.key, required this.mainCategorie});
  final MainCategorieModel mainCategorie;

  @override
  State<TabLayout> createState() => _TabLayoutState();
}

class _TabLayoutState extends State<TabLayout> with TickerProviderStateMixin {
  final ScrollController _mainScrollController = ScrollController();
  double currentScrollPosition = 0;

  String currentTitle = '';

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 5));
    setState(() {});
  }

  List<ProduitModel> allProduits = <ProduitModel>[];
  getProduitOfMainCategorie({groupe_id = 0}) async {
    setState(() {
      allProduits = [];
    });

    var produits = [];

    if (groupe_id == 0) {
      produits = await ApiServices().getProduitOfMainCategorie(
        widget.mainCategorie.main_categorie_id,
      );
    } else {
      print("THIS GROUPE : $groupe_id");
      produits = await ApiServices().getProduitOfGroupe(groupe_id);
    }

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

  List<GroupeCategorieModel> allGroupeByMainCategorie =
      <GroupeCategorieModel>[];
  getallGroupeByMainCategorie() async {
    setState(() {
      allGroupeByMainCategorie = [];
    });

    var groupes = await ApiServices().getallGroupeByMainCategorie(
      widget.mainCategorie.main_categorie_id.toString(),
    );

    groupes.forEach((groupe) {
      setState(() {
        allGroupeByMainCategorie.add(
          GroupeCategorieModel(
            id: groupe['groupe_id'].toString(),
            groupe: groupe['nom_groupe'].toString(),
          ),
        );
      });
    });
  }

  @override
  void initState() {
    currentScrollPosition = 0;
    super.initState();

    getallGroupeByMainCategorie();

    // Produit of categorie [params]
    getProduitOfMainCategorie();

    // Current title [current]
    currentTitle = widget.mainCategorie.nom_main_categorie.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        backgroundColor: PRIMARY,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        color: WHITE,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _mainScrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 160),
                    StickyHeader(
                      header: Container(
                        width: MediaQuery.of(context).size.width,
                        color: WHITE,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [groupeCategorie()],
                        ),
                      ),
                      content: Column(
                        children: [
                          espacementWidget(height: 10),
                          produitView(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column produitView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        espacementWidget(height: 50),
        noMoreProduit(),
      ],
    );
  }

  SingleChildScrollView groupeCategorie() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Container(
        margin: const EdgeInsets.only(top: 15, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                getProduitOfMainCategorie();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2.0,
                  horizontal: 4,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(right: BorderSide(width: 1)),
                  ),
                  width: 55,
                  child: customCenterText(
                    "Tout",
                    softWrap: true,
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: DARK, fontSize: 12),
                  ),
                ),
              ),
            ),

            for (
              var index = 0;
              index < allGroupeByMainCategorie.length;
              index++
            )
              GestureDetector(
                onTap: () {
                  getProduitOfMainCategorie(
                    groupe_id: allGroupeByMainCategorie[index].id,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 6,
                  ),
                  child: Container(
                    width: 70,
                    padding: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: index != allGroupeByMainCategorie.length - 1
                          ? Border(right: BorderSide(width: 1))
                          : null,
                    ),
                    child: customCenterText(
                      allGroupeByMainCategorie[index].groupe.toString(),
                      softWrap: true,
                      maxLines: 4,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: DARK, fontSize: 12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
