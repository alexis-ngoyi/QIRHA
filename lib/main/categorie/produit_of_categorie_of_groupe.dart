// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/widgets/filter_widget.dart';

import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/main/search.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class ProduitOfCategorieOfGroupe extends StatefulWidget {
  const ProduitOfCategorieOfGroupe({
    super.key,
    required this.categorie,
    required this.typeView,
  });
  final CategorieModel categorie;
  final String typeView; //[HOT | DEFAULT]
  @override
  State<ProduitOfCategorieOfGroupe> createState() =>
      _ProduitOfCategorieOfGroupeState();
}

class _ProduitOfCategorieOfGroupeState extends State<ProduitOfCategorieOfGroupe>
    with TickerProviderStateMixin {
  final ScrollController _mainScrollController = ScrollController();
  double currentScrollPosition = 0;

  String currentTitle = '';

  List<ProduitModel> allProduits = <ProduitModel>[];
  getProduitOfCategorie() async {
    setState(() {
      allProduits = [];
    });

    var produits = await ApiServices().getProduitOfCategorie(
      widget.categorie.categorie_id.toString(),
    );

    produits.forEach((produit) {
      setState(() {
        allProduits.add(
          ProduitModel(
            nom: produit['nom'],
            url_image: produit['url_image'],
            status: produit['status'],
            description: produit['description'],
            est_en_promo: produit['est_en_promo'],
            taux_reduction: (produit['taux_reduction'] as num?)?.toDouble(),
            prix_promo: (produit['prix_promo'] as num?)?.toDouble(),
            prix_minimum: (produit['prix_minimum'] as num?)?.toDouble(),
            cree_le: produit['cree_le'],
            date_fin: produit['date_fin'],
            fournisseur_id: produit['fournisseur_id'].toString(),
            nom_fournisseur: produit['nom_fournisseur'],
            produit_id: produit['produit_id'].toString(),
          ),
        );
      });
    });
  }

  @override
  void initState() {
    currentScrollPosition = 0;
    super.initState();

    // Produit of categorie [params]
    getProduitOfCategorie();

    // Current title [current]
    currentTitle = widget.categorie.libelle.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: currentScrollPosition > 100
          ? FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: WHITE,
              onPressed: () {
                _mainScrollController.animateTo(
                  0,
                  curve: Curves.ease,
                  duration: const Duration(seconds: 1),
                );
              },
              child: const HeroIcon(HeroIcons.arrowUp),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: PreferredSize(
        preferredSize: MediaQuery.of(context).size,
        child: const Row(),
      ),
      body: IconTheme(
        data: const IconThemeData(color: Colors.black),
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels > 100) {
              setState(() {
                currentScrollPosition = notification.metrics.pixels;
              });
            } else {
              setState(() {
                currentScrollPosition = 0;
              });
            }
            return false;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SpacerHeight(height: 35),
              Container(
                color: WHITE,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 13,
                    horizontal: 10,
                  ),
                  child: appBarProduitOfCategorieOfGroupe(context),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _mainScrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StickyHeader(
                        header: Container(
                          width: MediaQuery.of(context).size.width,
                          color: WHITE,
                          child: Column(children: [MyFilterWidget(top: 120)]),
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

  //////////////////////////////////////////////////////
  ////         WIDGET FUNCTION SIDE                  ///
  //////////////////////////////////////////////////////

  Row appBarProduitOfCategorieOfGroupe(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const HeroIcon(HeroIcons.chevronLeft, size: 25),
            ),
            espacementWidget(width: 20),
            customText(
              currentTitle.length > 23
                  ? '${currentTitle.substring(0, 23)}...'
                  : currentTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: DARK,
              ),
            ),
          ],
        ),
        Row(
          children: [
            appBarActionIconItem(
              route: const SearchBarScreen(),
              icon: HeroIcons.magnifyingGlass,
            ),
            espacementWidget(width: 8),
            MyCartWidget(size: 24, color: DARK),
          ],
        ),
      ],
    );
  }

  Widget appBarActionIconItem({
    required Widget route,
    required HeroIcons icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () => CustomPageRoute(route, context),
        child: HeroIcon(icon, size: 25),
      ),
    );
  }
}
