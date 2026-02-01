// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, prefer_const_constructors, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/main/produits/all_produit_bazard.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/loading_process.dart';
import 'package:qirha/res/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ToutTabScreen extends StatefulWidget {
  const ToutTabScreen({super.key});

  @override
  State<ToutTabScreen> createState() => _ToutTabScreenState();
}

class _ToutTabScreenState extends State<ToutTabScreen> {
  final List<MainCarouselModel> imageList = <MainCarouselModel>[
    MainCarouselModel(img: banner_1),
    MainCarouselModel(img: banner_3),
    MainCarouselModel(img: banner_4),
    MainCarouselModel(img: banner_5),
  ];

  int _currentCarouselBannerIndex = 0;

  final CarouselSliderController _controllerSlider = CarouselSliderController();

  late String? utilisateur_id;

  Future<void> _handleRefresh() async {}

  late Timer _timer;
  late int _totalDurationInSeconds = 3600 * 10;
  late String hours = '00';
  late String minutes = '00';
  late String remainingSeconds = '00';

  void _onTimerTick(Timer timer) {
    setState(() {
      if (_totalDurationInSeconds > 0) {
        _totalDurationInSeconds--;
      } else {
        _timer.cancel();
      }
    });
  }

  String _twoDigitFormatter(int n) => n.toString().padLeft(2, '0');

  void _formatDuration(int seconds) {
    setState(() {
      hours = _twoDigitFormatter(seconds ~/ 3600);
      minutes = _twoDigitFormatter((seconds % 3600) ~/ 60);
      remainingSeconds = _twoDigitFormatter(seconds % 60);
    });
  }

  final List<ProduitModel> ListProduitEnReduction = <ProduitModel>[];

  final List<ProduitModel> allProduits = <ProduitModel>[];
  getProduits() async {
    var produits = await ApiServices().getProduits();

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

        if (produit['est_en_promo'] == true) {
          ListProduitEnReduction.add(
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
        }
      });
    });
  }

  late Timer main_timer;
  bool? needToLogin;

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

  @override
  void initState() {
    super.initState();
    main_timer = Timer.periodic(Duration(seconds: 1), (timer) {});
    utilisateur_id = prefs.getString('utilisateur_id');
    authGuard();
    // start loading
    //----------------------------------------
    LoadingProcess.showLoading(text: 'Chargement');
    //----------------------------------------

    _timer = Timer.periodic(const Duration(seconds: 1), _onTimerTick);
    hours = '00';
    minutes = '00';
    remainingSeconds = '00';

    // Load all produits
    getProduits();

    // close loading
    LoadingProcess.dismissLoading();
  }

  @override
  void dispose() {
    _timer.cancel();
    main_timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger countdown
    if (_totalDurationInSeconds > 0) _formatDuration(_totalDurationInSeconds);

    return Scaffold(
      backgroundColor: GREY,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        backgroundColor: PRIMARY,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        color: WHITE,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      BannerCarouselSlider(),
                      Positioned(
                        top: 0,
                        right: 10,
                        child: BannerCarouselIndicator(context),
                      ),
                    ],
                  ),

                  MainScreenContent(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column MainScreenContent(BuildContext context) {
    return Column(
      children: [
        // Bazar reduction
        if (ListProduitEnReduction.isNotEmpty) ProduitsEnReduction(),

        FonctionnaliteAccessRapide(),

        // espacementWidget(height: 5),
        labelWithIcon(icon: HeroIcons.star, label: 'Meilleure suggestion'),
        StickyHeader(
          header: StackedQuickBar(context),
          content: Padding(
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
        ),
        espacementWidget(height: 20),
        noMoreProduit(),
      ],
    );
  }

  Stack StackedQuickBar(BuildContext context) {
    return Stack(
      children: [
        // Container(
        //   margin: const EdgeInsets.only(bottom: 5),
        //   height: 10,
        //   width: double.infinity,
        //   decoration: BoxDecoration(color: GREY),
        // ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 7),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                QuickBarItem(
                  title: 'Nouveaute',
                  icon: HeroIcons.star,
                  press: () => {},
                ),
                QuickBarItem(
                  title: 'En reduction',
                  icon: HeroIcons.tag,
                  press: () => {},
                ),

                QuickBarItem(
                  title: 'Meilleur ventre',
                  icon: HeroIcons.trophy,
                  press: () => {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  GestureDetector QuickBarItem({
    String title = '',
    HeroIcons icon = HeroIcons.questionMarkCircle,
    Function()? press,
  }) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: WHITE,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
          child: Row(
            children: [
              HeroIcon(icon, size: 13, color: PRIMARY),
              espacementWidget(width: 10),
              customText(
                title,
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: PRIMARY),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Countdown
  Row CustomHourCountdown() {
    return Row(
      children: [
        customText('Fini dans ', style: const TextStyle(fontSize: 10)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: PRIMARY,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: customText(
              hours,
              style: TextStyle(fontSize: 8, color: WHITE),
            ),
          ),
        ),
        customText(':', style: const TextStyle(fontSize: 8)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: PRIMARY,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: customText(
              minutes,
              style: TextStyle(fontSize: 8, color: WHITE),
            ),
          ),
        ),
        customText(':', style: const TextStyle(fontSize: 8)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: PRIMARY,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: customText(
              remainingSeconds,
              style: TextStyle(fontSize: 8, color: WHITE),
            ),
          ),
        ),
        const HeroIcon(HeroIcons.chevronRight, size: 15),
      ],
    );
  }

  //  BAZARD RAPID

  GestureDetector ProduitsEnReduction() {
    return GestureDetector(
      onTap: () => CustomPageRoute(AllProduitBazardPage(), context),
      child: Column(
        children: [
          espacementWidget(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    HeroIcon(
                      HeroIcons.bolt,
                      size: 20,
                      color: PRIMARY,
                      style: HeroIconStyle.solid,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: customText(
                        'Bazard rapide',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomHourCountdown(),
              ],
            ),
          ),
          SizedBox(
            height: 290,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: ListProduitEnReduction.length,
                itemBuilder: (BuildContext context, int i) {
                  return BazardRapidItem(
                    context,
                    reduction: true,
                    produit: ListProduitEnReduction[i],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  RAPID FEATURE

  Wrap FonctionnaliteAccessRapide() {
    return Wrap(
      children: [
        FonctionnaliteAccessRapideItem(
          HeroIcons.heart,
          'Mes favoris',
          Colors.black,
        ),
        FonctionnaliteAccessRapideItem(
          HeroIcons.truck,
          'Mes comandes',
          Colors.black,
        ),
        FonctionnaliteAccessRapideItem(
          HeroIcons.gift,
          'Faire un Cadeau',
          Colors.black,
        ),
        FonctionnaliteAccessRapideItem(
          HeroIcons.users,
          'Parrainez un ami',
          Colors.black,
        ),
      ],
    );
  }

  // BANNER CAROUSEL

  Row BannerCarouselIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imageList.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => _controllerSlider.animateToPage(entry.key),
          child: Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  (Theme.of(context).brightness == Brightness.dark
                          ? WHITE
                          : PRIMARY)
                      .withOpacity(
                        _currentCarouselBannerIndex == entry.key ? 0.9 : 0.4,
                      ),
            ),
          ),
        );
      }).toList(),
    );
  }

  CarouselSlider BannerCarouselSlider() {
    return CarouselSlider(
      carouselController: _controllerSlider,
      items: imageList.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                // action au clic
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 3.0,
                  vertical: 3,
                ), // espace entre images
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    image.img as String,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: false,
        viewportFraction:
            0.99, // chaque image occupe 99% → pour laisser la prochaine image charger rapidement dans les 0.1% restant
        enableInfiniteScroll: true,
        autoPlayCurve: Curves.easeInOut,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        onPageChanged: (index, reason) {
          setState(() {
            _currentCarouselBannerIndex = index;
          });
        },
      ),
    );
  }

  // fin
}
