// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names, avoid_print

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/functions/money_format.dart';
import 'package:qirha/model/commandes.dart';

import 'package:qirha/widgets/carousel_detail_produit.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/widgets/combo/custom_button.dart';
import 'package:qirha/widgets/couleur_produit_picker.dart';
import 'package:qirha/widgets/custom_loading.dart';
import 'package:qirha/widgets/custom_timer_count_down.dart';
import 'package:qirha/widgets/expandable_widget.dart';
import 'package:qirha/widgets/need_to_login.dart';
import 'package:qirha/widgets/produit_image_viewer.dart';
import 'package:qirha/widgets/rate_stars.dart';
import 'package:qirha/widgets/reactive_icon_widget.dart';
import 'package:qirha/widgets/text_collapse_widget.dart';
import 'package:qirha/main/bazard/bazard_home.dart';
import 'package:qirha/main/categorie/send_message_produit.dart';
import 'package:qirha/model/model_produit_couleur.dart';
import 'package:qirha/model/produit.dart';
import 'package:qirha/model/produit_avis.dart';
import 'package:qirha/model/produit_caracteristique_model.dart';
import 'package:qirha/model/produit_stats.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class DetailProduit extends StatefulWidget {
  const DetailProduit({super.key, required this.produit, this.isModal = false});
  final ProduitModel produit;
  final bool isModal;

  @override
  State<DetailProduit> createState() => _DetailProduitState();
}

class _DetailProduitState extends State<DetailProduit> {
  late ProduitModel produit = widget.produit;
  late String couleurQuantiteRestant = '';
  late bool reduction =
      double.parse(widget.produit.taux_reduction.toString()) > 0;

  final List<ProduitCaracteristiqueModel> produitCaracteristique = [];
  final List<ProduitCaracteristiqueModel> produitCaracteristiqueArgumentVente =
      [];

  // isLogged
  bool isLogged = true;

  // isActiveHeartFavoris
  bool isActiveHeartFavoris = false;

  // isLoadingHeartFavoris
  bool isLoadingHeartFavoris = false;

  getProduitCaracteristique() async {
    var caracteristiques = await ApiServices().getProduitCaracteristique(
      produit.produit_id.toString(),
    );

    caracteristiques.forEach((g) {
      setState(() {
        produitCaracteristique.add(
          ProduitCaracteristiqueModel(
            caracteristique: g['main_caracteristique']['contenu'],
            caracteristique_id: g['caracteristique_id'].toString(),
            contenu: g['contenu'],
            est_un_argument_de_vente: g['est_un_argument_de_vente'],
          ),
        );

        if (g['est_un_argument_de_vente'] == "1") {
          produitCaracteristiqueArgumentVente.add(
            ProduitCaracteristiqueModel(
              caracteristique: g['main_caracteristique']['contenu'],
              caracteristique_id: g['caracteristique_id'].toString(),
              contenu: g['contenu'],
              est_un_argument_de_vente: g['est_un_argument_de_vente'],
            ),
          );
        }
      });
    });
  }

  final List<ProduitStatsModel> produitAvisStats = [];

  getProduitAvisStats() async {
    var stats = await ApiServices().getProduitAvisStats(
      produit.produit_id.toString(),
    );

    stats.forEach((stat) {
      setState(() {
        produitAvisStats.add(
          ProduitStatsModel(
            totaux_avis: stat['totaux_avis'],
            nom_type_avis: stat['nom_type_avis'],
            percentage: stat['percentage'],
            effectif_par_element: stat['effectif_par_element'],
          ),
        );
      });
    });
  }

  final List<ProduitAvisModel> produitAvis = [];
  getProduitAvis() async {
    var avis = await ApiServices().getProduitAvis(
      produit.produit_id.toString(),
    );

    avis.forEach((a) {
      List<ImageModel> images_list = [];

      a['image'].forEach((i) {
        images_list.add(ImageModel(url: i['url']));
      });

      setState(() {
        produitAvis.add(
          ProduitAvisModel(
            images: images_list,
            commentaire: a['commentaire'],
            est_verifie: a['utilisateur']['est_verifie'],
            nom_couleur: a['couleur']['nom_couleur'],
            code_taille: a['taille']['code_taille'],
            nom_utilisateur: a['utilisateur']['nom_utilisateur'],
            note: a['note'],
            produit_avis_id: a['produit_avis_id'],
            utilisateur_id: a['utilisateur']['utilisateur_id'],
          ),
        );
      });
    });
  }

  // Add Produit To Panier

  late String? couleur_id = '';
  late String? image_id = '';
  late String? taille_id = '';

  addToCart() async {
    var maskWidget = Opacity(
      opacity: 1,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: WHITE,
      ),
    );
    SmartDialog.showLoading(
      maskWidget: maskWidget,
      clickMaskDismiss: true,
      backDismiss: true,
      animationType: SmartAnimationType.scale,
      builder: (_) =>
          const CustomLoading(type: 2, text: 'Insertion dans le panier...'),
    );

    var utilisateur_id = prefs.getString('utilisateur_id');

    AddPanierModel panierItem = AddPanierModel(
      couleur_id: couleur_id,
      image_id: image_id,
      produit_id: produit.produit_id,
      quantite: couleurQuantiteRestant != '0' ? '1' : '0', // default
      taille_id: taille_id,
      utilisateur_id: utilisateur_id,
    );

    var reponse = await ApiServices().addPanierItem(utilisateur_id, panierItem);

    print("ADD TO PANIER REPONSE : $reponse");

    // close loader
    SmartDialog.dismiss();
  }

  @override
  void initState() {
    super.initState();
    getProduitCaracteristique();
    getProduitAvisStats();
    getProduitAvis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      body: Stack(
        children: [
          MainDetailProduitContent(context),
          Positioned(
            top: (widget.isModal == false) ? 40 : 0,
            left: (widget.isModal == false) ? 10 : null,
            right: (widget.isModal == false) ? null : 10,
            child: GestureDetector(
              onTap: () => (widget.isModal == false)
                  ? Navigator.of(context).pop()
                  : null,
              child: Row(
                children: [
                  if (widget.isModal == false)
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: PRIMARY,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: HeroIcon(
                        HeroIcons.chevronLeft,
                        color: WHITE,
                        size: 20,
                      ),
                    ),
                  if (widget.isModal == true)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => CustomPageRoute(
                            DetailProduit(
                              isModal: false,
                              produit: widget.produit,
                            ),
                            context,
                          ),
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: GREY,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: [
                                customText(
                                  'Tous les details',
                                  style: TextStyle(color: DARK, fontSize: 9),
                                ),
                                espacementWidget(width: 4),
                                HeroIcon(
                                  HeroIcons.chevronRight,
                                  size: 15,
                                  color: PRIMARY,
                                ),
                              ],
                            ),
                          ),
                        ),
                        espacementWidget(height: 10),
                        GestureDetector(
                          onTap: () => CustomPageRoute(
                            const customGalleryViewer(),
                            context,
                          ),
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: GREY,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              children: [
                                customText(
                                  'Gallerie',
                                  style: TextStyle(color: DARK, fontSize: 9),
                                ),
                                espacementWidget(width: 4),
                                HeroIcon(
                                  HeroIcons.chevronRight,
                                  size: 15,
                                  color: PRIMARY,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: GREY,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      espacementWidget(width: 10),
                      MyCartWidget(color: DARK),
                      espacementWidget(width: 20),
                      MyReactiveIconWidget(
                        padding: 8,
                        size: 25,
                        isLoading: isLoadingHeartFavoris,
                        activeColor: PRIMARY,
                        activeIcon: Icons.favorite,
                        isActive: isActiveHeartFavoris,
                        color: LIGHT,
                        icon: Icons.favorite_border,
                        onTap: () {
                          setState(() {
                            isLoadingHeartFavoris = true;
                          });

                          // Fetch simulating
                          Future.delayed(const Duration(seconds: 1), () {
                            setState(() {
                              isLoadingHeartFavoris = false;
                              isActiveHeartFavoris = !isActiveHeartFavoris;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  MyButtonWidget(
                    onPressed: () {
                      addToCart();
                    },
                    label: 'AJOUTER AU PANIER',
                    bgColor: PRIMARY,
                    labelColor: WHITE,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView MainDetailProduitContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CarouselDetailProduit(
                reduction: reduction,
                currentProduit: produit,
                getCurrentIndex: (int currentIndex) {
                  // print('current index' + currentIndex.toString());
                },
                currentProduitImage: (currentProduitImage) {
                  setState(() {
                    image_id = currentProduitImage;
                  });
                },
                getQuantiteRestant: (String quantiteRestant) {
                  setState(() {
                    couleurQuantiteRestant = quantiteRestant;
                  });
                },
              ),
              if (reduction)
                Positioned(
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () =>
                        CustomPageRoute(const BazardHomePage(), context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      color: PRIMARY,
                      width: MediaQuery.of(context).size.width,
                      height: 33,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                HeroIcon(
                                  HeroIcons.bolt,
                                  size: 17,
                                  color: WHITE,
                                  style: HeroIconStyle.solid,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: customText(
                                    'Bazard rapide',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: WHITE,
                                    ),
                                  ),
                                ),
                                espacementWidget(width: 7),
                                HeroIcon(
                                  HeroIcons.chevronRight,
                                  size: 10,
                                  color: WHITE,
                                  style: HeroIconStyle.solid,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              customText(
                                '$couleurQuantiteRestant restant',
                                style: TextStyle(fontSize: 9, color: WHITE),
                              ),
                              espacementWidget(height: 2),
                              const CustomTimerCountDown(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          nomProduit(),
          prixEtEtoiles(),
          customDivider(),
          selectCouleur(produit),
          espacementWidget(height: 20),

          espacementWidget(height: 5),
          if (widget.isModal == false) delaiTraitement(),
          if (widget.isModal == false) delaiLivraison(),
          espacementWidget(height: 10),
          if (widget.isModal == false)
            if (reduction) greyBand(context),
          if (widget.isModal == false)
            if (reduction)
              GestureDetector(
                onTap: () => CustomPageRoute(const BazardHomePage(), context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          HeroIcon(
                            HeroIcons.bolt,
                            size: 17,
                            color: PRIMARY,
                            style: HeroIconStyle.solid,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: customText(
                              'Bazard rapide',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: PRIMARY,
                              ),
                            ),
                          ),
                        ],
                      ),
                      HeroIcon(
                        HeroIcons.chevronRight,
                        size: 15,
                        color: DARK,
                        style: HeroIconStyle.solid,
                      ),
                    ],
                  ),
                ),
              ),
          if (widget.isModal == false) greyBand(context),
          if (widget.isModal == false) sectionCaracteristique(),
          if (widget.isModal == false) selectionArgumentVente(),
          if (widget.isModal == false) greyBand(context),
          if (widget.isModal == false) espacementWidget(height: 10),
          if (widget.isModal == false) avisHearder(),
          if (widget.isModal == false)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: customText(
                "L'article correspondait-il a votre taille ?",
                style: TextStyle(color: LIGHT, fontSize: 12),
              ),
            ),
          if (widget.isModal == false)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                children: [
                  for (var index = 0; index < produitAvisStats.length; index++)
                    statLine(
                      context,
                      label: produitAvisStats[index].nom_type_avis.toString(),
                      percent: produitAvisStats[index].percentage as int,
                    ),
                ],
              ),
            ),
          if (widget.isModal == false) greyBand(context),
          if (widget.isModal == false)
            for (var index = 0; index < produitAvis.length; index++)
              if (index < 3)
                messageItem(context, produit_avis: produitAvis[index]),
          if (widget.isModal == false)
            if (produitAvis.isNotEmpty)
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return DraggableScrollableSheet(
                        initialChildSize:
                            400 / MediaQuery.of(context).size.height,
                        minChildSize: 0.1,
                        maxChildSize: 1.0,
                        expand: false,
                        builder:
                            (
                              BuildContext context,
                              ScrollController scrollController,
                            ) {
                              return Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                      right: 5,
                                      top: 40,
                                      bottom: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListView.builder(
                                      controller: scrollController,
                                      itemCount: produitAvis.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                            return messageItem(
                                              context,
                                              produit_avis: produitAvis[index],
                                            );
                                          },
                                    ),
                                  ),
                                  Container(
                                    color: WHITE,
                                    height: 40,
                                    child: Column(
                                      children: [
                                        showModalSmallBar(context),
                                        espacementWidget(height: 5),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                      );
                    },
                  );
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: customText(
                      'Voir tous les avis',
                      style: TextStyle(color: LIGHT, fontSize: 12),
                    ),
                  ),
                ),
              ),
          if (produitAvis.isNotEmpty) espacementWidget(height: 5),
          if (widget.isModal == false) greyBand(context),
          if (widget.isModal == false)
            Container(
              color: WHITE,
              margin: const EdgeInsets.only(bottom: 1),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  customText(
                    "Questions & questions",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      isLogged == false
                          ? showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return DraggableScrollableSheet(
                                  initialChildSize: .25,
                                  minChildSize: 0.25,
                                  maxChildSize: .25,
                                  expand: false,
                                  builder:
                                      (
                                        BuildContext context,
                                        ScrollController scrollController,
                                      ) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Container(
                                            color: Colors.white,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                espacementWidget(height: 10),
                                                showModalSmallBar(context),
                                                espacementWidget(height: 10),
                                                Container(
                                                  color: Colors.white,
                                                  height: 100,
                                                  child: ListView(
                                                    controller:
                                                        scrollController,
                                                    children: const [
                                                      NeedToLogin(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                );
                              },
                            )
                          : CustomPageRoute(
                              SendMessage(produit: produit),
                              context,
                            );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          child: customText(
                            'Poser une question\nIci et maintenant',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 12, color: LIGHT),
                          ),
                        ),
                        espacementWidget(width: 5),
                        const HeroIcon(HeroIcons.chevronRight, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (widget.isModal == false) greyBand(context),
          espacementWidget(height: 60),
          // SuggestionProduitWidget()
          // espacementWidget(height: 100)
        ],
      ),
    );
  }

  DottedBorder messageItem(
    BuildContext context, {
    required ProduitAvisModel produit_avis,
  }) {
    return DottedBorder(
      options: RectDottedBorderOptions(
        color: GREY,
        padding: const EdgeInsets.all(0),
        strokeWidth: 1,
      ),
      child: Container(
        color: WHITE,
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    customText(
                      "${produit_avis.nom_utilisateur}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    espacementWidget(width: 4),
                    HeroIcon(
                      produit_avis.est_verifie == 1
                          ? HeroIcons.shieldCheck
                          : HeroIcons.signal,
                      size: 12,
                      color: produit_avis.est_verifie == 1
                          ? Colors.green
                          : Colors.red,
                    ),
                    espacementWidget(width: 5),
                    customText(
                      '${produit_avis.est_verifie == 1 ? '' : 'Non'} verifie',
                      style: TextStyle(
                        fontSize: 9,
                        color: produit_avis.est_verifie == 1
                            ? Colors.green
                            : Colors.red,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Rate
                CustomRateStars(produit: produit),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    'Couleur: ${produit_avis.nom_couleur}, Taille: ${produit_avis.code_taille}',
                    style: TextStyle(fontSize: 11, color: LIGHT),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .9,
                        child: customText(
                          "${produit_avis.commentaire}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (
                      var index = 0;
                      index < produit_avis.images.length;
                      index++
                    )
                      if (index < 3)
                        roundedImageContainer(
                          image: produit_avis.images[index].url.toString(),
                          width: 45,
                          height: 45,
                        ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      customText(
                        "J'aime (0)",
                        style: const TextStyle(
                          fontSize: 11,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      espacementWidget(width: 5),
                      const HeroIcon(HeroIcons.heart, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow statLine(
    BuildContext context, {
    required String label,
    required int percent,
  }) {
    return TableRow(
      children: [
        TableCell(
          child: customText(label, style: TextStyle(color: DARK, fontSize: 12)),
        ),
        TableCell(
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .37,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.05),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Container(
                      width:
                          (MediaQuery.of(context).size.width * .37) *
                          (percent / 100),
                      height: 9,
                      decoration: BoxDecoration(
                        color: PRIMARY,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ],
                ),
              ),
              espacementWidget(width: 4),
              customText(
                '$percent%',
                style: TextStyle(color: LIGHT, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding avisHearder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(
            'Avis (${produitAvisStats.isNotEmpty ? produitAvisStats[0].totaux_avis : 0})',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          CustomRateStars(produit: produit),
        ],
      ),
    );
  }

  Container greyBand(BuildContext context) {
    return Container(
      color: GREY,
      width: MediaQuery.of(context).size.width,
      height: 10,
    );
  }

  CustomExpandableWidget selectionArgumentVente() {
    return CustomExpandableWidget(
      label: 'Arguments de vente',
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (
              var index = 0;
              index < produitCaracteristiqueArgumentVente.length;
              index++
            )
              customText(
                '${index + 1}. ${produitCaracteristiqueArgumentVente[index].caracteristique} : ${produitCaracteristiqueArgumentVente[index].contenu}',
                style: TextStyle(color: LIGHT, fontSize: 12),
              ),
          ],
        ),
      ),
      isExpanded: false,
      last: false,
    );
  }

  CustomExpandableWidget sectionCaracteristique() {
    return CustomExpandableWidget(
      label: 'Caracteristiques',
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: produitCaracteristique.isNotEmpty
            ? Table(
                children: [
                  for (
                    var index = 0;
                    index < produitCaracteristique.length;
                    index++
                  )
                    tableRow(
                      leading:
                          '${produitCaracteristique[index].caracteristique} :',
                      trailing: '${produitCaracteristique[index].contenu}',
                    ),
                ],
              )
            : Center(
                child: customText(
                  'Aucune caracteristique',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: DARK, fontSize: 10),
                ),
              ),
      ),
      isExpanded: true,
      last: false,
    );
  }

  Row nomProduit() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // customText(produit.libelle.toString(),
              //     maxLines: 1,
              //     overflow: TextOverflow.ellipsis,
              //     style: TextStyle(fontSize: 11, color: DARK)),
              CustomTextCollapse(label: "${produit.description}"),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => {},
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: HeroIcon(HeroIcons.arrowUpTray, size: 17),
          ),
        ),
      ],
    );
  }

  Padding delaiLivraison() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          //style for all textspan
          children: [
            TextSpan(
              text: "Delai de Livraison :",
              style: TextStyle(fontSize: 13, color: LIGHT),
            ),
            TextSpan(
              text: " TRANS BONY ",
              style: TextStyle(fontSize: 12.5, color: DARK),
            ),
            TextSpan(
              text: "1-2 jours ",
              style: TextStyle(
                fontSize: 13,
                color: DARK,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding delaiTraitement() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RichText(
        text: TextSpan(
          //style for all textspan
          children: [
            TextSpan(
              text: "Delai de traitement :",
              style: TextStyle(fontSize: 13, color: LIGHT),
            ),
            TextSpan(
              text: "sera calcule lorsque l'article aura ete calcule",
              style: TextStyle(fontSize: 13, color: DARK),
            ),
          ],
        ),
      ),
    );
  }

  Padding selectCouleur(ProduitModel produit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: CouleurProduitPicker(
        selectedCouleurProduit: (ProduitCouleurModel selectedCouleurProduit) {
          // print('selected couleur : ${selectedCouleurProduit.nom_couleur}');
          setState(() {
            couleur_id = selectedCouleurProduit.couleur_id.toString();
          });
        },
        produit: produit,
        defaultSelectedCouleur: -1, // default
      ),
    );
  }

  Padding prixEtEtoiles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(
            formatMoney(
              '${produit.est_en_promo == true ? produit.prix_promo : produit.prix_minimum}',
            ),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          CustomRateStars(produit: produit),
        ],
      ),
    );
  }

  TableRow tableRow({required String leading, required String trailing}) {
    return TableRow(
      children: [
        TableCell(
          child: customText(
            '$leading :',
            style: TextStyle(color: LIGHT, fontSize: 12),
          ),
        ),
        TableCell(
          child: customText(
            trailing,
            style: TextStyle(color: LIGHT, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
