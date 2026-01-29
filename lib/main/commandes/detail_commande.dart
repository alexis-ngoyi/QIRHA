// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';

import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/widgets/image_svg.dart';
import 'package:qirha/functions/money_format.dart';
import 'package:qirha/functions/status_commande.dart';
import 'package:qirha/main/commandes/moyen_de_paiement_commandes.dart';
import 'package:qirha/model/commandes.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/constantes.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class DetailCommandeProduit extends StatefulWidget {
  const DetailCommandeProduit({super.key, required this.commande});
  final CommandeModel commande;

  @override
  State<DetailCommandeProduit> createState() => _DetailCommandeProduitState();
}

class _DetailCommandeProduitState extends State<DetailCommandeProduit> {
  List<ArticlesCommandeModel> ListArtclesCommande = [];
  bool isLoading = true;

  getArticlesCommande() async {
    setState(() {
      isLoading = true;
    });

    var articles = await ApiServices().getArticlesCommande(
      widget.commande.commande_id.toString(),
    );

    articles.forEach((article) {
      setState(() {
        ListArtclesCommande.add(
          ArticlesCommandeModel(
            code_taille: article['code_taille'],
            nom_couleur: article['nom_couleur'],
            nom_produit: article['nom_produit'],
            produit_id: article['produit_id'].toString(),
            photo_cover: article['photo_cover'],
            couleur_id: article['couleur_id'].toString(),
            image_id: article['image_id'].toString(),
            taille_id: article['taille_id'].toString(),
            prix_unitaire: article['prix_unitaire'],
            quantite: article['quantite'].toString(),
            quantite_en_stock: article['quantite_en_stock'].toString(),
          ),
        );
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getArticlesCommande();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      appBar: AppBar(
        backgroundColor: WHITE,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const HeroIcon(HeroIcons.chevronLeft, size: 25),
        ),
        title: customText(
          'Details de la commande',
          style: TextStyle(
            fontSize: 17,
            color: DARK,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          MyCartWidget(size: 24, color: DARK),
          espacementWidget(width: 10),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                espacementWidget(height: 10),
                identificationCommande(),
                if (widget.commande.accepte_la_livraison == "1")
                  espacementWidget(height: 10),
                if (widget.commande.accepte_la_livraison == "1")
                  adresseLivraison(),
                espacementWidget(height: 10),
                articleDeLaCommande(),
                espacementWidget(height: 10),
                resumeCommande(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: WHITE,
              height: 140,
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          'TOTAL :',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Container(
                          child: customText(
                            formatMoney(
                              (double.parse("2040") +
                                      double.parse(
                                        widget.commande.montant_total
                                            .toString(),
                                      ))
                                  .toString(),
                            ),
                            style: TextStyle(
                              color: GREEN,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    customDivider(),
                    Column(
                      children: [
                        customText(
                          "Guarrantissons vos paiements en toute securite",
                          softWrap: true,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 10),
                        ),
                        espacementWidget(height: 5),
                        GestureDetector(
                          onTap: () => CustomPageRoute(
                            const MoyenDePaiementCommande(),
                            context,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.black.withOpacity(.08),
                              ),
                              color: PRIMARY,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: customText(
                                'VALIDER LA COMMANDE',
                                style: TextStyle(color: WHITE, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container resumeCommande() {
    return Container(
      color: WHITE,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HeroIcon(HeroIcons.newspaper, size: 14, color: DARK),
              espacementWidget(width: 7),
              customText(
                "Resume de la commande",
                style: TextStyle(
                  color: DARK,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          espacementWidget(height: 8),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: customText(
                      'Sous-total',
                      style: TextStyle(color: LIGHT, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: customText(
                      formatMoney(widget.commande.montant_total.toString()),
                      style: TextStyle(color: LIGHT, fontSize: 11),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: customText(
                      "Frais d'expedition",
                      style: TextStyle(color: LIGHT, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: customText(
                      '1 000,00 XAF',
                      style: TextStyle(color: LIGHT, fontSize: 11),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: customText(
                      "Assurance d'expedition",
                      style: TextStyle(color: LIGHT, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: customText(
                      '1 000,00 XAF',
                      style: TextStyle(color: LIGHT, fontSize: 11),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: customText(
                      "Taxes",
                      style: TextStyle(color: LIGHT, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: customText(
                      '40,00 XAF',
                      style: TextStyle(color: LIGHT, fontSize: 11),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: customText(
                      "Total",
                      style: TextStyle(color: LIGHT, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: customText(
                      formatMoney(
                        (double.parse("2040") +
                                double.parse(
                                  widget.commande.montant_total.toString(),
                                ))
                            .toString(),
                      ),
                      style: TextStyle(
                        color: DARK,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          espacementWidget(height: 10),
          lightDivider(),
          espacementWidget(height: 10),
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black.withOpacity(.08),
              ),
              color: const Color.fromARGB(118, 244, 67, 54),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: customText(
                'Annuler la commande',
                style: TextStyle(color: WHITE, fontSize: 12),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black.withOpacity(.08),
              ),
              color: WHITE,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: customText(
                'Service client',
                style: TextStyle(color: DARK, fontSize: 12),
              ),
            ),
          ),
          espacementWidget(height: 150),
        ],
      ),
    );
  }

  Container articleDeLaCommande() {
    return Container(
      color: WHITE,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HeroIcon(
                statusCommandeIcon(widget.commande.status.toString()),
                size: 14,
                color: DARK,
              ),
              espacementWidget(width: 7),
              customText(
                statusCommande(widget.commande.status.toString()),
                style: TextStyle(
                  color: DARK,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          espacementWidget(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Date d'arrivée prévue :",
                  style: TextStyle(fontSize: 13, color: LIGHT),
                ),
                TextSpan(
                  text: "2023-11-20 ~ 2023-11-25",
                  style: TextStyle(fontSize: 11, color: DARK),
                ),
              ],
            ),
          ),
          for (var index = 0; index < ListArtclesCommande.length; index++)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                articleItem(article: ListArtclesCommande[index]),
                if (index < ListArtclesCommande.length - 1) lightDivider(),
              ],
            ),
        ],
      ),
    );
  }

  Container adresseLivraison() {
    return Container(
      color: WHITE,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(
                'Adresse de Livraison',
                style: TextStyle(
                  color: DARK,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  HeroIcon(HeroIcons.pencilSquare, size: 14, color: PRIMARY),
                  espacementWidget(width: 7),
                  customText(
                    "Modifier l'adresse",
                    style: TextStyle(color: PRIMARY, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          espacementWidget(height: 10),
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              //style for all textspan
              children: [
                TextSpan(
                  text:
                      "Alexis Ngoyi ,  +242069500886 , 19 rue Niari , Q. La poudriere , Arr. 4 Moungali , Ref # Arret de bus 1er Arret  ",
                  style: TextStyle(fontSize: 11, color: LIGHT),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container articleItem({required ArticlesCommandeModel article}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedImageContainer(
            image: article.photo_cover.toString(),
            width: 75,
            height: 75,
          ),
          espacementWidget(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 200,
                child: customText(
                  article.nom_produit.toString(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  style: TextStyle(fontSize: 13, color: DARK),
                ),
              ),
              espacementWidget(height: 5),
              Container(
                padding: const EdgeInsets.all(3),
                margin: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: GREY,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  children: [
                    customText(
                      '${article.nom_couleur}; ${article.code_taille}',
                      style: const TextStyle(
                        fontSize: 11,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    espacementWidget(width: 5),
                    const HeroIcon(HeroIcons.chevronDown, size: 12),
                  ],
                ),
              ),
              espacementWidget(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    formatMoney(article.prix_unitaire.toString()),
                    style: const TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  espacementWidget(width: 10),
                  const HeroIcon(HeroIcons.xMark, size: 11),
                  customText(
                    article.quantite.toString(),
                    style: TextStyle(fontSize: 13, color: LIGHT),
                  ),
                ],
              ),
              customText(
                "Total restant : ${article.quantite_en_stock} articles",
                style: TextStyle(fontSize: 9, color: PRIMARY),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container identificationCommande() {
    return Container(
      color: WHITE,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Table(
        children: [
          TableRow(
            children: [
              TableCell(
                child: customText(
                  'Commande #',
                  style: TextStyle(color: LIGHT, fontSize: 13),
                ),
              ),
              TableCell(
                child: Row(
                  children: [
                    customText(
                      '$prefixCodeCommande${widget.commande.commande_id}',
                      style: TextStyle(color: DARK, fontSize: 11),
                    ),
                    espacementWidget(width: 10),
                    GestureDetector(
                      onTap: () => copyToClipBoard(
                        context,
                        text:
                            '$prefixCodeCommande${widget.commande.commande_id}',
                        msg: "Le code de la commande a été copié",
                      ),
                      child: HeroIcon(
                        HeroIcons.clipboardDocumentCheck,
                        size: 18,
                        color: PRIMARY,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              TableCell(
                child: customText(
                  'Date de la commande',
                  style: TextStyle(color: LIGHT, fontSize: 13),
                ),
              ),
              TableCell(
                child: customText(
                  widget.commande.date_commande.toString(),
                  style: TextStyle(color: DARK, fontSize: 11),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              TableCell(
                child: customText(
                  'Accepte la livraison ?',
                  style: TextStyle(color: LIGHT, fontSize: 13),
                ),
              ),
              TableCell(
                child: GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return DraggableScrollableSheet(
                        initialChildSize: .3,
                        minChildSize: .17,
                        maxChildSize: .3,
                        expand: false,
                        builder: (BuildContext context, ScrollController scrollController) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                children: [
                                  espacementWidget(height: 30),
                                  const MySvgImageWidget(
                                    asset: livraison_svg,
                                    height: 70,
                                    width: 90,
                                  ),
                                  espacementWidget(height: 25),
                                  customCenterText(
                                    'Acceptez-vous la livraison pour cette \n commande uniquement ?',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: DARK,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  espacementWidget(height: 8),
                                  if (widget.commande.accepte_la_livraison ==
                                      "0")
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 15,
                                      ),
                                      child: customCenterText(
                                        "Apres traitement de votre commande, vous passerez recuperer vos produits dans les locaux de Qirha",
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: DARK,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  espacementWidget(height: 6),
                                  if (widget.commande.accepte_la_livraison ==
                                      "1")
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 15,
                                      ),
                                      child: customCenterText(
                                        "Apres traitement de votre commande, vous serez livré a l'addresse de livraion indiquée",
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: DARK,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  child: customText(
                    "Non ( recuperation dans les locaux de Qirha)",
                    maxLines: 2,
                    style: TextStyle(color: DARK, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
