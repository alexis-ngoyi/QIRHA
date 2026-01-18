import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/main/bazard/bazard_home.dart';
import 'package:qirha/main/categorie/produit_par_categorie_hot.dart';
import 'package:qirha/model/categorie.dart';
import 'package:qirha/res/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:qirha/res/demo_data.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MainTabElectroniquesScreen extends StatefulWidget {
  const MainTabElectroniquesScreen({super.key});

  @override
  State<MainTabElectroniquesScreen> createState() =>
      _MainTabElectroniquesScreenState();
}

class _MainTabElectroniquesScreenState
    extends State<MainTabElectroniquesScreen> {
  final List<String> imageList = <String>[img_bazard11];

  int _currentCarouselBannerIndex = 0;

  final CarouselSliderController _controllerSlider = CarouselSliderController();

  final List<CategorieModel> CategorieList = <CategorieModel>[
    CategorieModel(img: img_bazard11, libelle: 'Audio Video'),
    CategorieModel(img: img_bazard11, libelle: 'Ecouteurs'),
    CategorieModel(img: img_bazard11, libelle: 'Appareils electronique'),
    CategorieModel(img: img_bazard11, libelle: 'Soins personnels'),
    CategorieModel(img: img_bazard11, libelle: 'Electro inteligence'),
    CategorieModel(img: img_bazard11, libelle: 'Automobile'),
    CategorieModel(img: img_bazard11, libelle: 'Montres'),
    CategorieModel(img: img_bazard11, libelle: 'Securite surete'),
    CategorieModel(img: img_bazard11, libelle: 'Accessoires'),
    CategorieModel(img: img_bazard11, libelle: 'Electrique & outils'),
    CategorieModel(img: img_bazard11, libelle: 'Iphone'),
    CategorieModel(img: img_bazard11, libelle: 'Ordinateur'),
    CategorieModel(img: img_bazard11, libelle: 'Television'),
  ];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 5));
    setState(() {});
  }

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

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), _onTimerTick);
    hours = '00';
    minutes = '00';
    remainingSeconds = '00';
  }

  @override
  void dispose() {
    _timer.cancel();
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
        backgroundColor: BLUE,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        color: WHITE,
        child: SingleChildScrollView(
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
              Column(
                children: [
                  Container(
                    height: 330,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: WHITE,
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 1,
                            childAspectRatio: .84,
                            mainAxisExtent: 97,
                          ),
                      itemCount: CategorieList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => CustomPageRoute(
                            ProduitParCategorieHot(
                              typeView: 'DEFAULT',
                              categorie: CategorieList[index],
                            ),
                            context,
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  color: GREY,
                                  width: 55,
                                  height: 55,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: roundedImageContainer(
                                      image: CategorieList[index].img as String,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 8,
                                ),
                                child: customText(
                                  CategorieList[index].libelle as String,
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Bazar
                  if (_totalDurationInSeconds > 0) BazardRow(),

                  labelWithIcon(
                    icon: HeroIcons.fire,
                    label: 'Les plus populaire',
                  ),
                  StaggeredGrid.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    children: [
                      // for (var i = 0; i < nouveauteImageList.length; i++)
                      //   cardImageProduit(context,
                      //       reduction: false,
                      //       i: i,
                      //       image: img_bazard11,
                      //       gallerie: nouveauteImageList),
                    ],
                  ),
                  espacementWidget(height: 50),
                  noMoreProduit(),
                ],
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
        customText('Se termine dans', style: const TextStyle(fontSize: 12)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: BLUE,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: customText(
              hours,
              style: TextStyle(fontSize: 10, color: WHITE),
            ),
          ),
        ),
        customText(':', style: const TextStyle(fontSize: 10)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: BLUE,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: customText(
              minutes,
              style: TextStyle(fontSize: 10, color: WHITE),
            ),
          ),
        ),
        customText(':', style: const TextStyle(fontSize: 10)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: BLUE,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: customText(
              remainingSeconds,
              style: TextStyle(fontSize: 10, color: WHITE),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => CustomPageRoute(BazardHomePage(), context),
          child: const HeroIcon(HeroIcons.chevronRight, size: 15),
        ),
      ],
    );
  }

  //  BAZARD RAPID

  Column BazardRow() {
    return Column(
      children: [
        espacementWidget(height: 15),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  HeroIcon(
                    HeroIcons.bolt,
                    size: 20,
                    color: BLUE,
                    style: HeroIconStyle.solid,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: customText(
                      'Bazard rapide',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              CustomHourCountdown(),
            ],
          ),
        ),
        BazardRapid(),
      ],
    );
  }

  SingleChildScrollView BazardRapid() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (var i = 0; i < imageBazardListElectronique.length; i++)
              BazardRapidItem(
                context,
                reduction: true,
                produit: imageBazardListElectronique[i],
              ),
          ],
        ),
      ),
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
                          : BLUE)
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
      items: imageList.map((imagePath) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: GREY),
              child: FadeInImage.assetNetwork(
                placeholder: placeholder,
                image: imagePath,
                fit: BoxFit.cover,
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.2, //4.0,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          setState(() {
            _currentCarouselBannerIndex = index;
          });
        },
      ),
    );
  }
}
