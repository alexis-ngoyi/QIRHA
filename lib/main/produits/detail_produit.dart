// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names, avoid_print

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/loading_process.dart';

import 'package:qirha/widgets/carousel_detail_produit.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/widgets/combo/custom_button.dart';
import 'package:qirha/widgets/custom_counter_cart.dart';
import 'package:qirha/widgets/custom_timer_count_down.dart';
import 'package:qirha/widgets/expandable_widget.dart';
import 'package:qirha/widgets/need_to_login.dart';
import 'package:qirha/widgets/rate_stars.dart';
import 'package:qirha/widgets/reactive_icon_widget.dart';
import 'package:qirha/widgets/text_collapse_widget.dart';
import 'package:qirha/main/produits/all_produit_bazard.dart';
import 'package:qirha/main/produits/send_message_produit.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class DetailProduit extends StatefulWidget {
  const DetailProduit({super.key, required this.produit});
  final ProduitModel produit;

  @override
  State<DetailProduit> createState() => _DetailProduitState();
}

class _DetailProduitState extends State<DetailProduit> {
  late ProduitModel produit = widget.produit;

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

  var produitAllCaracteristiques = [];

  getProduitAllCaracteristiques() async {
    var caracteristiques = await ApiServices().getProduitAllCaracteristiques(
      produit.produit_id.toString(),
    );

    setState(() {
      produitAllCaracteristiques = caracteristiques;
      print('total ${produitAllCaracteristiques.length}');
    });
  }

  var prix_par_defaut = 0.0;
  var quantite_par_defaut = 0;
  var prix_promo_par_defaut = 0.0;
  var selected_quantite = 1;
  var prix_produit_id = 0;

  getProduitPrixMinimumParams() async {
    var prix_params = await ApiServices().getProduitPrixMinimumParams(
      produit.prix_produit_id.toString(),
    );

    setState(() {
      // Récupération sécurisée des valeurs
      final double prix =
          double.tryParse(prix_params['prix'].toString()) ?? 0.0;
      final int quantite =
          int.tryParse(prix_params['quantite_en_stock'].toString()) ?? 0;

      prix_par_defaut = prix;

      // Calcul du prix promo uniquement si le produit est en promo
      prix_promo_par_defaut =
          prix_par_defaut -
          (widget.produit.est_en_promo == true
              ? prix * (widget.produit.taux_reduction!.toDouble())
              : 0.0);

      quantite_par_defaut = quantite;

      prix_produit_id = int.parse(widget.produit.prix_produit_id.toString());

      // Réinitialisation des attributs sélectionnés
      selectedAttributs = [];
    });

    prix_params['combinaison_attribut_produit_caracteristique_ids'].forEach((
      item,
    ) {
      setState(() {
        selectedAttributs.add(
          SelectedAttribut(
            attributs_produit_caracteristiques_id:
                item['attributs_produit_caracteristiques_id'],
            attributs_produit_id: item['attributs_produit_id'],
          ),
        );
      });
    });
  }

  getProduitCaracteristique() async {
    var caracteristiques = await ApiServices().getProduitCaracteristique(
      produit.produit_id.toString(),
    );

    caracteristiques.forEach((item) {
      setState(() {
        produitCaracteristique.add(
          ProduitCaracteristiqueModel(
            caracteristique: item['main_caracteristique']['contenu'],
            caracteristique_id: item['caracteristique_id'].toString(),
            contenu: item['contenu'],
            est_un_argument_de_vente: item['est_un_argument_de_vente'],
          ),
        );

        if (item['est_un_argument_de_vente'] == "1") {
          produitCaracteristiqueArgumentVente.add(
            ProduitCaracteristiqueModel(
              caracteristique: item['main_caracteristique']['contenu'],
              caracteristique_id: item['caracteristique_id'].toString(),
              contenu: item['contenu'],
              est_un_argument_de_vente: item['est_un_argument_de_vente'],
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

    avis.forEach((item) {
      List<ImageModel> images_list = [];

      item['image'].forEach((i) {
        images_list.add(ImageModel(url: i['url']));
      });

      setState(() {
        produitAvis.add(
          ProduitAvisModel(
            images: images_list,
            commentaire: item['commentaire'],
            est_verifie: item['utilisateur']['est_verifie'],
            nom_couleur: item['couleur']['nom_couleur'],
            code_taille: item['taille']['code_taille'],
            nom_utilisateur: item['utilisateur']['nom_utilisateur'],
            note: item['note'],
            produit_avis_id: item['produit_avis_id'],
            utilisateur_id: item['utilisateur']['utilisateur_id'],
          ),
        );
      });
    });
  }

  List<SelectedAttribut> selectedAttributs = [];
  getProduitPrixParCombinaison({
    String? produit_id,
    required List<SelectedAttribut> selected,
  }) async {
    var prix_params = await ApiServices().getProduitPrixParCombinaison(
      produit_id: widget.produit.produit_id,
      selected: selectedAttributs,
    );

    setState(() {
      // Récupération sécurisée des valeurs
      final double prix =
          double.tryParse(prix_params['prix'].toString()) ?? 0.0;
      final int quantite =
          int.tryParse(prix_params['quantite_en_stock'].toString()) ?? 0;

      prix_par_defaut = prix;

      // Calcul du prix promo uniquement si le produit est en promo
      prix_promo_par_defaut =
          prix_par_defaut -
          (widget.produit.est_en_promo == true
              ? prix * (widget.produit.taux_reduction!.toDouble())
              : 0.0);

      quantite_par_defaut = quantite;

      prix_produit_id = int.parse(prix_params['prix_produit_id'].toString());
    });
  }

  // Ajouter au panier
  onPressAjouterAuPanier() async {
    LoadingProcess.showLoading(text: 'Insertion dans le panier...');

    var utilisateur_id = prefs.getString('utilisateur_id');

    AddPanierModel panierItem = AddPanierModel(
      quantite: selected_quantite,
      produit_id: widget.produit.produit_id,
      utilisateur_id: utilisateur_id,
      photo_cover: '',
      prix_produit_id: prix_produit_id.toString(),
    );

    var reponse = await ApiServices().addPanierItem(utilisateur_id, panierItem);

    print("ADD TO PANIER REPONSE : $reponse");

    // close loader
    LoadingProcess.dismissLoading();
  }

  @override
  void initState() {
    super.initState();
    getProduitPrixMinimumParams();
    getProduitCaracteristique();
    getProduitAllCaracteristiques();
    getProduitAvisStats();
    getProduitAvis();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      body: Stack(
        children: [
          VuePrincipalDuProduit(context),
          BackPreviousScreen(context),
          AjouterAuPanier(context),
        ],
      ),
    );
  }

  Positioned BackPreviousScreen(BuildContext context) {
    return Positioned(
      top: 40,
      left: 10,
      right: null,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),

        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: PRIMARY,
                borderRadius: BorderRadius.circular(100),
              ),
              child: HeroIcon(HeroIcons.chevronLeft, color: WHITE, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Positioned AjouterAuPanier(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 88,
        color: GREY,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            customText(
              'TOTAL : ' +
                  formatMoney(
                    (selected_quantite *
                            (widget.produit.est_en_promo == true
                                ? prix_promo_par_defaut
                                : prix_par_defaut))
                        .toString(),
                  ),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),

            Row(
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
                    onPressAjouterAuPanier();
                  },
                  label: 'AJOUTER AU PANIER',
                  bgColor: PRIMARY,
                  labelColor: WHITE,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView VuePrincipalDuProduit(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CarouselDetailProduit(
                currentProduit: produit,
                getCurrentIndex: (int currentIndex) {
                  // print('current index' + currentIndex.toString());
                },
                currentProduitImage: (currentProduitImage) {
                  setState(() {
                    // currentProduitImage;
                  });
                },
              ),
              if (reduction) BannerDeReduction(context),
            ],
          ),
          DescriptionDuProduit(context),
        ],
      ),
    );
  }

  Positioned BannerDeReduction(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: GestureDetector(
        onTap: () => CustomPageRoute(const AllProduitBazardPage(), context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          color: PRIMARY,
          width: MediaQuery.of(context).size.width,
          height: 40,
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
                      padding: const EdgeInsets.symmetric(horizontal: 5),
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
                    '$quantite_par_defaut restant',
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
    );
  }

  Column DescriptionDuProduit(BuildContext context) {
    return Column(
      children: [
        PrixEtNomProduit(),

        //  description produit
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [CustomTextCollapse(label: "${produit.description}")],
              ),
            ),
          ],
        ),

        SeparateurLineGrise(context),

        // attributs
        AttriubutProduits(),

        espacementWidget(height: 10),

        delaiTraitement(),

        delaiLivraison(),

        espacementWidget(height: 10),

        if (reduction) SeparateurLineGrise(context),

        if (reduction)
          GestureDetector(
            onTap: () => CustomPageRoute(const AllProduitBazardPage(), context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
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
        SeparateurLineGrise(context),
        sectionCaracteristique(),

        selectionArgumentVente(),
        SeparateurLineGrise(context),

        espacementWidget(height: 10),
        EnteteDesAvis(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: customText(
            "L'article correspondait-il a votre taille ?",
            style: TextStyle(color: LIGHT, fontSize: 12),
          ),
        ),

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
        SeparateurLineGrise(context),

        for (var index = 0; index < produitAvis.length; index++)
          if (index < 3) messageItem(context, produit_avis: produitAvis[index]),

        if (produitAvis.isNotEmpty)
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return DraggableScrollableSheet(
                    initialChildSize: 400 / MediaQuery.of(context).size.height,
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
        SeparateurLineGrise(context),

        QuestionReponse(context),

        SeparateurLineGrise(context),

        espacementWidget(height: 60),
      ],
    );
  }

  Padding PrixEtNomProduit() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // titre + prix
          widget.produit.est_en_promo == true
              ? Row(
                  children: [
                    customText(
                      formatMoney(prix_promo_par_defaut.toString()),
                      style: TextStyle(
                        color: PRIMARY,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    espacementWidget(width: 5),
                    customText(
                      formatMoney(prix_par_defaut.toString()),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.lineThrough,
                        decorationThickness: 1.0,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    customText(
                      formatMoney(prix_par_defaut.toString()),
                      style: TextStyle(
                        color: PRIMARY,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

          customText(
            widget.produit.nom ?? '',
            maxLines: 2,
            style: const TextStyle(
              color: Color.fromARGB(225, 0, 0, 0),
              fontSize: 11,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Container QuestionReponse(BuildContext context) {
    return Container(
      color: WHITE,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          customText(
            "Questions & questions",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                                  borderRadius: BorderRadius.circular(10),
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
                                            controller: scrollController,
                                            children: const [NeedToLogin()],
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
                  : CustomPageRoute(SendMessage(produit: produit), context);
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
    );
  }

  Column AttriubutProduits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        for (var attribut in produitAllCaracteristiques) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  attribut["nom_main_attribut"],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    for (var carac in attribut["caracteristiques"])
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: GestureDetector(
                          onTap: () {
                            var selected = SelectedAttribut(
                              attributs_produit_caracteristiques_id:
                                  carac['attributs_produit_caracteristiques_id'],
                              attributs_produit_id:
                                  carac['attributs_produit_id'],
                            );

                            bool doublon = selectedAttributs.any(
                              (attr) =>
                                  attr.attributs_produit_id ==
                                  selected.attributs_produit_id,
                            );

                            if (doublon) {
                              setState(() {
                                // supprime l'existant
                                selectedAttributs.removeWhere(
                                  (attr) =>
                                      attr.attributs_produit_id ==
                                      selected.attributs_produit_id,
                                );
                                // ajoute le nouveau
                                selectedAttributs.add(selected);
                              });
                            } else {
                              setState(() {
                                selectedAttributs.add(selected);
                              });
                            }

                            if (selectedAttributs.length ==
                                produitAllCaracteristiques.length) {
                              getProduitPrixParCombinaison(
                                produit_id: widget.produit.produit_id,
                                selected: selectedAttributs,
                              );
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: customText(
                                    carac["contenu_text"],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              // check if it's selected
                              if (selectedAttributs.any(
                                (attr) =>
                                    attr.attributs_produit_caracteristiques_id ==
                                        carac['attributs_produit_caracteristiques_id'] &&
                                    attr.attributs_produit_id ==
                                        carac['attributs_produit_id'],
                              ))
                                SelectedContainerBadge(),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 10),

        Container(
          margin: EdgeInsets.only(left: 10),
          child: customText(
            'Quantite : ',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: CustomizableCounter(
            padding: 10,
            count: selected_quantite,
            step: 1,
            minCount: 1,
            maxCount: quantite_par_defaut,
            incrementIcon: const Icon(Icons.add, color: Colors.white),
            decrementIcon: const Icon(Icons.remove, color: Colors.white),
            onCountChange: (count) {
              setState(() {
                selected_quantite = count;
              });
            },
            onIncrement: (count) {
              setState(() {
                selected_quantite = count;
              });
            },
            onDecrement: (count) {
              setState(() {
                selected_quantite = count;
              });
            },
          ),
        ),

        //
      ],
    );
  }

  Positioned SelectedContainerBadge() {
    return Positioned(
      right: 0,
      top: 0,
      child: Transform.translate(
        offset: Offset(4, -2), // x pour horizontal, y pour vertical
        child: Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: GREEN,
          ),
          child: HeroIcon(HeroIcons.check, color: WHITE, size: 12),
        ),
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

  Padding EnteteDesAvis() {
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

  Container SeparateurLineGrise(BuildContext context) {
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
              text:
                  "Les livraison ne sont pas encore pris en compte dans l'aaplication",
              style: TextStyle(fontSize: 12.5, color: DARK),
            ),
            // TextSpan(
            //   text: "1-2 jours ",
            //   style: TextStyle(
            //     fontSize: 13,
            //     color: DARK,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
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
              text: "Vous sera communique une fois le panier valide",
              style: TextStyle(fontSize: 13, color: DARK),
            ),
          ],
        ),
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
