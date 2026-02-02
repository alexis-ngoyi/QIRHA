// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/res/constantes.dart';

import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/main/produits/produit_par_categorie.dart';
import 'package:qirha/main/recherche/search.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class ProduitParGroupe extends StatefulWidget {
  const ProduitParGroupe({
    super.key,
    required this.groupe,
    required this.typeView,
  });
  final GroupeCategorieModel groupe;
  final String typeView; //[HOT | DEFAULT]
  @override
  State<ProduitParGroupe> createState() => _ProduitParGroupeState();
}

class _ProduitParGroupeState extends State<ProduitParGroupe>
    with TickerProviderStateMixin {
  final ScrollController _mainScrollController = ScrollController();
  double currentScrollPosition = 0;

  String currentTitle = '';

  List<ProduitModel> allProduits = <ProduitModel>[];
  getProduitOfGroupe() async {
    setState(() {
      allProduits = [];
    });

    var produits = await ApiServices().getProduitOfGroupe(
      widget.groupe.id.toString(),
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
    currentScrollPosition = 0;
    super.initState();

    // Produit of groupe [params]
    getProduitOfGroupe();

    // Current title [current]
    currentTitle = widget.groupe.groupe.toString();
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
                  child: appBarProduitParGroupe(context),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _mainScrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      espacementWidget(height: 5),
                      otherCategorieRow(),
                      StickyHeader(
                        header: Container(
                          width: MediaQuery.of(context).size.width,
                          color: WHITE,
                          child: Column(children: []),
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

  // RIGHT FILTER

  Padding otherCategorieRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            espacementWidget(width: 4),
            for (
              var index = 0;
              index < widget.groupe.categorie!.length;
              index++
            )
              groupeCategorieItems(
                index: 1,
                img: demoPic,
                text: widget.groupe.categorie![index].libelle.toString(),
                press: () => {
                  CustomPageRoute(
                    ProduitParCategorie(
                      typeView: 'DEFAULT',
                      categorie: widget.groupe.categorie![index],
                    ),
                    context,
                  ),
                },
              ),
          ],
        ),
      ),
    );
  }

  GestureDetector groupeCategorieItems({
    required String img,
    required String text,
    required Function() press,
    required int index,
  }) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 70,
        height: 100,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: WHITE,
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: FadeInImage.assetNetwork(
                    placeholder: demoPic,
                    image: demoPic,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8,
                  ),
                  child: SizedBox(
                    width: 55,
                    child: customCenterText(
                      text,
                      softWrap: true,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: DARK, fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row appBarProduitParGroupe(BuildContext context) {
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
              currentTitle.length > 20
                  ? '${currentTitle.substring(0, 20)}...'
                  : currentTitle,
              style: TextStyle(
                fontSize: 15,
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
