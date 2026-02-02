import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/res/constantes.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/widgets/combo/custom_button.dart';
import 'package:qirha/widgets/expandable_widget.dart';
import 'package:qirha/widgets/selectable_container_livraison.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/main/parametres/qui_sommes_nous.dart';
import 'package:qirha/main/commandes/moyen_de_paiement_commandes.dart';

import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class ConfirmationCommandeProduit extends StatefulWidget {
  const ConfirmationCommandeProduit({
    super.key,
    required this.panier,
    required this.sousTotal,
  });
  final panier;
  final double sousTotal;

  @override
  State<ConfirmationCommandeProduit> createState() =>
      _ConfirmationCommandeProduitState();
}

class _ConfirmationCommandeProduitState
    extends State<ConfirmationCommandeProduit> {
  late (String, String, String, int) selectedLivraison = (
    homme_marchant,
    "Je n'accepte pas la livraison",
    '0',
    1,
  );

  @override
  void initState() {
    super.initState();
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
          'Confirmation de la commande',
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 10,
                  ),
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
                // fin
                espacementWidget(height: 10),
                articleDeLaCommande(),
              ],
            ),
          ),
          confirmeButton(context),
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

  Positioned confirmeButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        color: WHITE,
        height: 180,
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              customDivider(),
              espacementWidget(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customText('TOTAL :', style: const TextStyle(fontSize: 14)),
                  customText(
                    formatMoney(
                      (double.parse("2040") +
                              double.parse(widget.sousTotal.toString()))
                          .toString(),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      color: PRIMARY,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              espacementWidget(height: 10),
              Column(
                children: [
                  customCenterText(
                    "Inscrivez-vous a la plateforme pour beneficier d'un compte business",
                    softWrap: true,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: DARK),
                  ),
                  espacementWidget(height: 5),
                  SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: Expanded(
                      flex: 1,
                      child: MyButtonWidget(
                        onPressed: () => CustomPageRoute(
                          const MoyenDePaiementCommande(),
                          context,
                        ),
                        label: 'PAYER LA COMMANDE',
                        bgColor: PRIMARY,
                        labelColor: WHITE,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
              HeroIcon(HeroIcons.paperClip, size: 14, color: DARK),
              espacementWidget(width: 7),
              customText(
                "Vos articles  (${widget.panier.length})",
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
                  text: "Date d'arrivee prevue :",
                  style: TextStyle(fontSize: 13, color: LIGHT),
                ),
                TextSpan(
                  text: " 3 jours",
                  style: TextStyle(
                    fontSize: 11,
                    color: PRIMARY,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
}
