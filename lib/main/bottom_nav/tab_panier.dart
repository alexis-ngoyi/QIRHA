// ignore_for_file: prefer_const_constructors_in_immutables, non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/widgets/combo/custom_button.dart';
import 'package:qirha/widgets/need_to_login.dart';

import 'package:qirha/widgets/suggestion_produit.dart';
import 'package:qirha/functions/money_format.dart';
import 'package:qirha/main/commandes/confirmation_commande.dart';
import 'package:qirha/main/search.dart';
import 'package:qirha/model/commandes.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/widgets/custom_counter_cart.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class TabPanierScreen extends StatefulWidget {
  TabPanierScreen({super.key, required this.canReturn});
  final bool canReturn;

  @override
  State<TabPanierScreen> createState() => _TabPanierScreenState();
}

class _TabPanierScreenState extends State<TabPanierScreen> {
  List<ArticlesCommandeModel> cartProduit = [];
  bool isLoading = true;
  double prixTotalPanier = 0;

  getPanierUtilisateur() async {
    setState(() {
      isLoading = true;
      cartProduit = [];
    });

    var utilisateur_id = prefs.getString('utilisateur_id');

    double tmp = 0;

    var articles =
        await ApiServices().getPanierUtilisateur(utilisateur_id.toString());

    articles.forEach((article) {
      setState(() {
        cartProduit.add(ArticlesCommandeModel(
          code_taille: article['code_taille'],
          nom_couleur: article['nom_couleur'],
          produit_id: article['produit_id'].toString(),
          couleur_id: article['couleur_id'].toString(),
          image_id: article['image_id'].toString(),
          taille_id: article['taille_id'].toString(),
          nom_produit: article['nom_produit'],
          photo_cover: article['photo_cover'],
          prix_unitaire: article['prix'],
          quantite: article['quantite'].toString(),
          quantite_en_stock: article['quantite_en_stock'].toString(),
        ));

        tmp += double.parse(article['prix'].toString()) *
            int.parse(article['quantite'].toString());
      });
    });

    setState(() {
      prixTotalPanier = tmp;
      isLoading = false;
    });
  }

  // UPDATE PRIX TOTAL DU PANIER
  updatePrixTotalPanier() {
    double tmp = 0;

    // calculate new prix
    for (var index = 0; index < cartProduit.length; index++) {
      tmp += double.parse(cartProduit[index].prix_unitaire.toString()) *
          double.parse(cartProduit[index].quantite.toString());
    }

    setState(() {
      prixTotalPanier = tmp;
    });
  }

  late String? utilisateur_id;
  bool? needToLogin;
  late Timer main_timer;

  authGuard() {
    // Define the interval duration in milliseconds
    const intervalDuration = Duration(seconds: 1);

    // Set up a periodic timer
    main_timer = Timer.periodic(intervalDuration, (timer) async {
      if (utilisateur_id == null) {
        setState(() {
          needToLogin = true;
        });
      } else {
        setState(() {
          needToLogin = false;
        });
      }
      timer.cancel();
    });
  }

  // delete panier item
  delelePanierItem(ArticlesCommandeModel article) async {
    setState(() {
      cartProduit.remove(article);
    });

    var utilisateur_id = prefs.getString('utilisateur_id');

    AddPanierModel panierItem = AddPanierModel(
        couleur_id: article.couleur_id,
        quantite: article.quantite,
        image_id: article.image_id,
        produit_id: article.produit_id,
        taille_id: article.taille_id,
        utilisateur_id: utilisateur_id);

    var reponse =
        await ApiServices().deletePanierItem(utilisateur_id, panierItem);

    print("DELETE FROM PANIER REPONSE : $reponse");

    await onRefreshPanierContent();

    // close loader
    // SmartDialog.dismiss();
  }

  Future<void> onRefreshPanierContent() async {
    // Load panier
    getPanierUtilisateur();

    // calculate prices
    updatePrixTotalPanier();
  }

  @override
  void initState() {
    super.initState();
    utilisateur_id = prefs.getString('utilisateur_id');
    authGuard();

    getPanierUtilisateur();
  }

  @override
  void dispose() {
    super.dispose();
    main_timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefreshPanierContent,
      backgroundColor: BLUE,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: WHITE,
      child: Scaffold(
          backgroundColor: GREY,
          body: needToLogin == false
              ? Stack(
                  children: [
                    Column(
                      children: [
                        espacementWidget(height: 40),
                        panierAppBar(),
                        if (isLoading == true)
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 400,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        cartProduit.isEmpty && isLoading == false
                            ? emptyCartWithSuggestion(context)
                            : notEmptyCart(),
                      ],
                    ),
                    if (cartProduit.isNotEmpty && isLoading == false)
                      Positioned(
                          bottom: 0,
                          child: Container(
                            color: WHITE,
                            height: 110,
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customText('TOTAL :',
                                          style: const TextStyle(
                                            fontSize: 14,
                                          )),
                                      customText(
                                          formatMoney(
                                              prixTotalPanier.toString()),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  espacementWidget(height: 10),
                                  SizedBox(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width,
                                    child: Expanded(
                                      flex: 1,
                                      child: MyButtonWidget(
                                          onPressed: () => CustomPageRoute(
                                              ConfirmationCommandeProduit(
                                                  panier: cartProduit,
                                                  sousTotal: prixTotalPanier),
                                              context),
                                          label: 'VALIDER LE PANIER',
                                          bgColor: BLUE,
                                          labelColor: WHITE),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                  ],
                )
              : (needToLogin == true
                  ? const NeedToLogin()
                  : const Center(
                      child: CircularProgressIndicator(),
                    ))),
    );
  }

  Column moyenDePayment(BuildContext context) {
    return Column(
      children: [
        customText('Payez avec avec les moyens de paiement locaux suivants :',
            softWrap: true,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 11,
            )),
        espacementWidget(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => CustomPageRoute(
                  ConfirmationCommandeProduit(
                      panier: cartProduit, sousTotal: prixTotalPanier),
                  context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  mtn_logo,
                  width: 100,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            espacementWidget(width: 10),
            GestureDetector(
              onTap: () => CustomPageRoute(
                  ConfirmationCommandeProduit(
                      panier: cartProduit, sousTotal: prixTotalPanier),
                  context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  airtel_logo,
                  width: 100,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  notEmptyCart() {
    return Expanded(
        child: SingleChildScrollView(
      child: Column(
        children: [
          espacementWidget(height: 5),
          for (var index = 0; index < cartProduit.length; index++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: cartTileItem(article: cartProduit[index]),
            ),
          espacementWidget(height: 20),
          const SuggestionProduitWidget()
        ],
      ),
    ));
  }

  Container cartTileItem({required ArticlesCommandeModel article}) {
    return Container(
      color: WHITE,
      child: Row(children: [
        espacementWidget(width: 8),
        GestureDetector(
          onTap: () {
            delelePanierItem(article);
          },
          child: Container(
            decoration: BoxDecoration(
                color: WHITE, borderRadius: BorderRadius.circular(50)),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: HeroIcon(
                HeroIcons.trash,
                color: DANGER,
                size: 14,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                roundedImageContainer(
                    image: article.photo_cover.toString(),
                    width: 50,
                    height: 60),
                espacementWidget(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: customText(article.nom_produit.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 12,
                              color: DARK,
                            )),
                      ),
                      espacementWidget(height: 2),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(.013),
                            borderRadius: BorderRadius.circular(3)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                                'Couleur : ${article.nom_couleur} / Taille : ${article.code_taille}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            espacementWidget(width: 2),
                            const HeroIcon(
                              HeroIcons.chevronDown,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                      espacementWidget(height: 2),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                                formatMoney(article.prix_unitaire.toString()),
                                style: const TextStyle(
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold)),
                            espacementWidget(width: 60),
                            CustomizableCounter(
                              padding: 4,
                              count: double.parse(article.quantite as String),
                              step: 1,
                              minCount: 1,
                              maxCount: double.parse(
                                  article.quantite_en_stock as String),
                              incrementIcon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              decrementIcon: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              onCountChange: (count) {
                                setState(() {
                                  article.quantite = count.toString();
                                });
                                updatePrixTotalPanier();
                              },
                              onIncrement: (count) {
                                setState(() {
                                  article.quantite = count.toString();
                                });
                                updatePrixTotalPanier();
                              },
                              onDecrement: (count) {
                                setState(() {
                                  article.quantite = count.toString();
                                });
                                updatePrixTotalPanier();
                              },
                            )
                          ],
                        ),
                      ),
                      customText(
                          "Total restant : ${article.quantite_en_stock} articles",
                          style: TextStyle(fontSize: 9, color: BLUE)),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ]),
    );
  }

  Expanded emptyCartWithSuggestion(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            emptyCart(),
            espacementWidget(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 1,
                    color: BLUE,
                  ),
                  customText('Vous pourriez le remplir avec',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Container(
                    width: 50,
                    height: 1,
                    color: BLUE,
                  ),
                ],
              ),
            ),
            espacementWidget(height: 20),
            SuggestionProduitWidget()
          ],
        ),
      ),
    );
  }

  Center emptyCart() {
    return Center(
      child: Column(
        children: [
          const Image(
            image: AssetImage(empty_cart),
            height: 230,
            width: 230,
          ),
          customText('Votre panier est vide',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          customText('Connectez-vous pour consulter votre panier',
              style: const TextStyle(fontSize: 12)),
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
                      color: WHITE, border: Border.all(width: 1, color: WHITE)),
                  child: customText(
                    'Achetez Maintenant',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold, color: DARK),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  color: BLUE,
                  padding: const EdgeInsets.all(6),
                  child: customText(
                    'Me connecter',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: WHITE),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container panierAppBar() {
    return Container(
      color: WHITE,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () =>
                      widget.canReturn ? Navigator.of(context).pop() : {},
                  child: HeroIcon(
                    widget.canReturn
                        ? HeroIcons.chevronLeft
                        : HeroIcons.shoppingCart,
                    size: 25,
                  ),
                ),
                espacementWidget(width: 10),
                customText(
                    cartProduit.isEmpty
                        ? 'Panier'
                        : 'Panier (${cartProduit.length})',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                espacementWidget(width: 10),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: BLUE, borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    children: [
                      HeroIcon(HeroIcons.mapPin, size: 12, color: WHITE),
                      espacementWidget(width: 5),
                      customText('Livraison partout au congo',
                          style: TextStyle(fontSize: 9, color: WHITE)),
                    ],
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => CustomPageRoute(const SearchBarScreen(), context),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: HeroIcon(
                  HeroIcons.magnifyingGlass,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
