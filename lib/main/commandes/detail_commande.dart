// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/main/commandes/paiement_commande.dart';
import 'package:qirha/main/parametres/qui_sommes_nous.dart';
import 'package:qirha/res/constantes.dart';

import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/widgets/expandable_widget.dart';
import 'package:qirha/widgets/image_svg.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/selectable_container_livraison.dart';

class DetailCommandeProduit extends StatefulWidget {
  const DetailCommandeProduit({super.key, required this.commande});
  final CommandeModel commande;

  @override
  State<DetailCommandeProduit> createState() => _DetailCommandeProduitState();
}

class _DetailCommandeProduitState extends State<DetailCommandeProduit> {
  var ArticleCommandeList = [];
  bool isLoading = true;

  late (String, String, String, int) selectedLivraison = (
    homme_marchant,
    "Je n'accepte pas la livraison",
    '0',
    1,
  );

  getArticlesCommande() async {
    setState(() {
      isLoading = true;
    });

    var articles = await ApiServices().getArticlesCommande(
      widget.commande.commande_id.toString(),
    );

    articles.forEach((article) {
      setState(() {
        ArticleCommandeList.add(article);
      });
    });
  }

  annulationCommande() {}

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            espacementWidget(height: 10),
            identificationCommande(),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: SelectableContainerLivraison(
                onSelect: ((String, String, String, int) selected) {
                  setState(() {
                    selectedLivraison = selected;
                  });
                },
              ),
            ),
            if (selectedLivraison.$4 == 1) livraisonRefuse(),
            if (selectedLivraison.$4 == 2) adresseLivraisonADomicile(),
            // Agence expedition
            if (selectedLivraison.$4 == 3) agenceDexpedition(),
            if (selectedLivraison.$4 == 3) espacementWidget(height: 10),
            if (selectedLivraison.$4 == 3) detailAgenceDexpedition(),

            espacementWidget(height: 20),

            espacementWidget(height: 10),
            articleDeLaCommande(),

            espacementWidget(height: 10),
            resumeCommande(),

            espacementWidget(height: 10),
            GestureDetector(
              onTap: () => CustomPageRoute(
                PaiementCommandePage(
                  sousTotal: widget.commande.montant_total as double,
                ),
                context,
              ),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.black.withOpacity(.08),
                  ),
                  color: const Color.fromARGB(118, 33, 148, 8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: customText(
                    'Payer la commande',
                    style: TextStyle(color: WHITE, fontSize: 12),
                  ),
                ),
              ),
            ),

            espacementWidget(height: 30),
            GestureDetector(
              onTap: () => annulationCommande(),
              child: Container(
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
            ),

            espacementWidget(height: 60),
          ],
        ),
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
                      "Taxes",
                      style: TextStyle(color: LIGHT, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: customText(
                      '0,00 XAF',
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
                        (double.parse(
                          widget.commande.montant_total.toString(),
                        )).toString(),
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
                  text: "3 Jours depuis la validation",
                  style: TextStyle(fontSize: 11, color: DARK),
                ),
              ],
            ),
          ),
          for (var index = 0; index < ArticleCommandeList.length; index++)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    articleItem(article: ArticleCommandeList[index]),
                    // badge
                    if (ArticleCommandeList[index]['est_en_promo'] == true)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0),
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(5),
                          ),
                          child: Container(
                            decoration: BoxDecoration(color: PRIMARY),
                            padding: EdgeInsets.all(5),
                            child: Row(
                              children: [
                                HeroIcon(
                                  HeroIcons.bolt,
                                  size: 12,
                                  color: WHITE,
                                ),
                                espacementWidget(width: 5),
                                customText(
                                  '- ${((ArticleCommandeList[index]['pourcentage_reduction'] ?? 0) * 100).toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: WHITE,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (index < ArticleCommandeList.length - 1) lightDivider(),
              ],
            ),
        ],
      ),
    );
  }

  Container articleItem({required article}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          roundedImageContainer(
            image: article['photo_cover'].toString().isNotEmpty
                ? article['photo_cover'].toString()
                : demoPic,
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
                  article['nom_produit'].toString(),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 3,
                  style: TextStyle(fontSize: 12, color: DARK),
                ),
              ),
              espacementWidget(height: 7),
              Row(
                children: [
                  for (
                    var i = 0;
                    i < article['attributs_produit_caracteristiques'].length;
                    i++
                  )
                    Container(
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: PRIMARY.withAlpha(20),
                        border: Border.all(width: .5),
                      ),
                      child: customText(
                        "${article['attributs_produit_caracteristiques'][i]['contenu_text']}",
                        style: TextStyle(fontSize: 9, color: PRIMARY),
                      ),
                    ),
                ],
              ),

              espacementWidget(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText(
                    formatMoney(
                      (article['est_en_promo'] == true
                              ? (article['prix_unitaire'] -
                                    article['prix_unitaire'] *
                                        article['pourcentage_reduction'])
                              : article['prix_unitaire'])
                          .toString(),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  espacementWidget(width: 10),
                  const HeroIcon(HeroIcons.xMark, size: 11),
                  customText(
                    article['quantite'].toString(),
                    style: TextStyle(fontSize: 10, color: LIGHT),
                  ),
                ],
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
                      '${widget.commande.code_commande}',
                      style: TextStyle(color: DARK, fontSize: 11),
                    ),
                    espacementWidget(width: 10),
                    GestureDetector(
                      onTap: () => copyToClipBoard(
                        context,
                        text: '${widget.commande.code_commande}',
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
                        initialChildSize: .4,
                        minChildSize: .4,
                        maxChildSize: .4,
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
                                  // if (widget.commande.accepte_la_livraison ==
                                  //     "0")
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 50,
                                      vertical: 15,
                                    ),
                                    child: customCenterText(
                                      "Si, Non : Apres traitement de votre commande, vous passerez recuperer vos produits dans les locaux de Qirha",
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: DARK,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  espacementWidget(height: 6),
                                  // if (widget.commande.accepte_la_livraison ==
                                  //     "1")
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 50,
                                      vertical: 15,
                                    ),
                                    child: customCenterText(
                                      "Si, Oui : Apres traitement de votre commande, vous serez livré a l'addresse de livraion indiquée",
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

  Container adresseLivraisonADomicile() {
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

  Container agenceDexpedition() {
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
                "Expedition hors Brazzaville",
                style: TextStyle(
                  color: DARK,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  HeroIcon(HeroIcons.truck, size: 14, color: PRIMARY),
                  espacementWidget(width: 7),
                  customText(
                    "Toutes les agences",
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
                  text: "Nos partenaires de livraison partout en",
                  style: TextStyle(fontSize: 11, color: LIGHT),
                ),
                TextSpan(
                  text: " Republique du Congo ",
                  style: TextStyle(fontSize: 11, color: PRIMARY),
                ),
              ],
            ),
          ),
          espacementWidget(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(width: 1, color: PRIMARY),
                    ),
                    child: Row(
                      children: [
                        HeroIcon(
                          HeroIcons.buildingStorefront,
                          size: 14,
                          color: PRIMARY,
                        ),
                        espacementWidget(width: 7),
                        customText(
                          "BZV",
                          style: TextStyle(color: PRIMARY, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              HeroIcon(HeroIcons.arrowRight, size: 12, color: LIGHT),
              Row(
                children: [
                  // customText("Destination : ",
                  //     style: TextStyle(color: LIGHT, fontSize: 11)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(width: 1, color: PRIMARY),
                    ),
                    child: Row(
                      children: [
                        HeroIcon(HeroIcons.mapPin, size: 14, color: PRIMARY),
                        espacementWidget(width: 7),
                        customText(
                          "PNR",
                          style: TextStyle(color: PRIMARY, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          espacementWidget(height: 7),
          lightDivider(padding: 0),
          espacementWidget(height: 7),
          Center(
            child: customText(
              "Configurer l'adresse d'expedition ici",
              style: TextStyle(color: PRIMARY, fontSize: 11),
            ),
          ),
          // espacementWidget(height: 5),
        ],
      ),
    );
  }

  Container livraisonRefuse() {
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
                "Je n'accepte pas la livraison",
                style: TextStyle(
                  color: DARK,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  HeroIcon(HeroIcons.mapPin, size: 14, color: PRIMARY),
                  espacementWidget(width: 7),
                  customText(
                    "voir l'itineraire",
                    style: TextStyle(color: PRIMARY, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
          espacementWidget(height: 10),
          GestureDetector(
            onTap: () =>
                CustomPageRoute(const CompteParametresQuiSommesNous(), context),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                //style for all textspan
                children: [
                  TextSpan(
                    text: "Vous devrez vous rendre dans nos locaux",
                    style: TextStyle(fontSize: 11, color: LIGHT),
                  ),
                  TextSpan(
                    text: " Qirha Shop ",
                    style: TextStyle(fontSize: 11, color: PRIMARY),
                  ),
                  TextSpan(
                    text:
                        " pour recuperer votre commande. Nos addresses sur la page ",
                    style: TextStyle(fontSize: 11, color: LIGHT),
                  ),
                  TextSpan(
                    text: " Compte > Parametres > ",
                    style: TextStyle(fontSize: 11, color: LIGHT),
                  ),
                  TextSpan(
                    text: " Qui sommes-nous ",
                    style: TextStyle(fontSize: 11, color: PRIMARY),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container detailAgenceDexpedition() {
    return Container(
      color: WHITE,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: CustomExpandableWidget(
        label: "Detail de l'expedition",
        size: 13,
        last: true,
        content: Column(
          children: [
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
      ),
    );
  }
}
