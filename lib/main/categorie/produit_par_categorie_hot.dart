// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:heroicons/heroicons.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/widgets/filter_widget.dart';
import 'package:qirha/widgets/cart_widget.dart';

import 'package:qirha/functions/prix_promo_format.dart';
import 'package:qirha/main/search.dart';

// Model
import 'package:qirha/model/categorie.dart';
import 'package:qirha/model/produit.dart';

// Res
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class ProduitParCategorieHot extends StatefulWidget {
  const ProduitParCategorieHot(
      {super.key, required this.categorie, required this.typeView});
  final CategorieModel categorie;
  final String typeView; //[HOT | DEFAULT]
  @override
  State<ProduitParCategorieHot> createState() => _ProduitParCategorieHotState();
}

class _ProduitParCategorieHotState extends State<ProduitParCategorieHot>
    with TickerProviderStateMixin {
  final ScrollController _mainScrollController = ScrollController();
  double currentScrollPosition = 0;

  final List<CategorieModel> categorieList = <CategorieModel>[];
  String currentTitle = '';

  getHotCategories() async {
    var categories = await ApiServices().getHotCategories();

    categories.forEach((categorie) {
      setState(() {
        categorieList.add(CategorieModel(
            img: categorie['image_categorie'].toString().isEmpty ||
                    categorie['image_categorie'] == null
                ? categorie_default
                : categorie['image_categorie'].toString(),
            libelle: categorie['nom_categorie'],
            categorie_id: categorie['categorie_id'].toString()));
      });
    });
  }

  List<ProduitModel> allProduits = <ProduitModel>[];
  getProduitOfCategorie({required String categorie_id}) async {
    setState(() {
      allProduits = [];
    });

    var produits = await ApiServices().getProduitOfCategorie(categorie_id);

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
    currentScrollPosition = 0;
    super.initState();

    // Produit Hot Categorie [Latest]
    getHotCategories();

    // Produit of categorie [params]
    getProduitOfCategorie(
        categorie_id: widget.categorie.categorie_id.toString());

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
                  borderRadius: BorderRadius.circular(100)),
              backgroundColor: WHITE,
              onPressed: () {
                _mainScrollController.animateTo(0,
                    curve: Curves.ease, duration: const Duration(seconds: 1));
              },
              child: const HeroIcon(HeroIcons.arrowUp),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: PreferredSize(
          preferredSize: MediaQuery.of(context).size, child: const Row()),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                  child: appBarProduitParCategorieHot(context),
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
                            child: Column(
                              children: [MyFilterWidget()],
                            ),
                          ),
                          content: Column(
                            children: [
                              espacementWidget(height: 10),
                              produitView(context),
                            ],
                          ))
                    ],
                  ),
                ),
              )
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
                cardImageProduit(context, produit: allProduits[i]),
            ],
          ),
        ),
        espacementWidget(
          height: 50,
        ),
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
            for (var index = 0; index < categorieList.length; index++)
              otherCategorieItem(
                  index: 1,
                  img: categorieList[index].img as String,
                  text: categorieList[index].libelle as String,
                  press: () => {
                        setState(() {
                          currentTitle =
                              categorieList[index].libelle.toString();
                        }),
                        getProduitOfCategorie(
                            categorie_id:
                                categorieList[index].categorie_id.toString())
                      }),
          ],
        ),
      ),
    );
  }

  GestureDetector otherCategorieItem(
      {required String img,
      required String text,
      required Function() press,
      required int index}) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 70,
        height: 100,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border:
              text == currentTitle ? Border.all(width: 1, color: BLUE) : null,
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
                    placeholder: placeholder,
                    image: img,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
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

  Row appBarProduitParCategorieHot(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const HeroIcon(
                  HeroIcons.chevronLeft,
                  size: 25,
                )),
            espacementWidget(
              width: 20,
            ),
            customText(
              currentTitle.length > 23
                  ? '${currentTitle.substring(0, 23)}...'
                  : currentTitle,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: DARK),
            ),
          ],
        ),
        Row(
          children: [
            appBarActionIconItem(
                route: const SearchBarScreen(),
                icon: HeroIcons.magnifyingGlass),
            espacementWidget(width: 8),
            MyCartWidget(
              size: 24,
              color: DARK,
            ),
          ],
        )
      ],
    );
  }

  Widget appBarActionIconItem(
      {required Widget route, required HeroIcons icon}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
          onTap: () => CustomPageRoute(route, context),
          child: HeroIcon(
            icon,
            size: 25,
          )),
    );
  }
}
