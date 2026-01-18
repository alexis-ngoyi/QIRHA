import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/main/categorie/produit_par_categorie_hot.dart';
import 'package:qirha/model/categorie.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class MainTabHommesScreen extends StatefulWidget {
  const MainTabHommesScreen({super.key});

  @override
  State<MainTabHommesScreen> createState() => _MainTabHommesScreenState();
}

class _MainTabHommesScreenState extends State<MainTabHommesScreen> {
  int _currentCarouselBannerIndex = 0;
  final CarouselSliderController _controllerSlider = CarouselSliderController();
  final List<String> imageList = <String>[img_bazard8];

  final List<CategorieModel> topImageList = <CategorieModel>[
    CategorieModel(img: img_enfant, libelle: 'PLus Vendus'),
    CategorieModel(img: img_femme, libelle: 'Plus populaire'),
    CategorieModel(img: img_homme, libelle: 'Nouveaute'),
    CategorieModel(img: img_chaussures, libelle: 'Saint Valentin'),
    CategorieModel(img: img_curvy, libelle: 'Noel'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              color: WHITE,
              child: horizontalListFeatureItem(context),
            ),
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
            labelWithIcon(
              label: 'Acheter par categorie',
              icon: HeroIcons.shoppingBag,
            ),
            gridImageBox(context),
            rowCategorieView(context),
            labelWithIcon(
              label: "Mettez a jour votre dressing",
              icon: HeroIcons.fire,
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
                //       image: nouveauteImageList[i],
                //       gallerie: nouveauteImageList),
              ],
            ),
            noMoreProduit(),
          ],
        ),
      ),
    );
  }

  Padding rowCategorieView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                child: roundedImageContainer(
                  image: img_bazard8,
                  width: MediaQuery.of(context).size.width / 4 - 9,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: customText(
                  'Hoodies',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: WHITE,
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                child: roundedImageContainer(
                  image: img_bazard8,
                  width: MediaQuery.of(context).size.width / 4 - 9,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: customText(
                  'Bottoms',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: WHITE,
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                child: roundedImageContainer(
                  image: img_bazard8,
                  width: MediaQuery.of(context).size.width / 4 - 9,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: customText(
                  'Sweaters',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: WHITE,
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                child: roundedImageContainer(
                  image: img_bazard8,
                  width: MediaQuery.of(context).size.width / 4 - 9,
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: customText(
                  'Shoes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    color: WHITE,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding gridImageBox(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        child: roundedImageContainer(
                          image: img_bazard8,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: customText(
                          'Tops',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: WHITE,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        child: roundedImageContainer(
                          image: img_bazard8,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: customText(
                          'OuterWear',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: WHITE,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Container(
                    child: roundedImageContainer(
                      image: img_bazard8,
                      height: 205,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: customText(
                      'Dresses',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        color: WHITE,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView horizontalListFeatureItem(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          espacementWidget(width: 8),
          for (var index = 0; index < topImageList.length; index++)
            GestureDetector(
              onTap: () => CustomPageRoute(
                ProduitParCategorieHot(
                  typeView: 'DEFAULT',
                  categorie: topImageList[index],
                ),
                context,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Container(
                      color: GREY,
                      width: 50,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(topImageList[index].img as String),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 6,
                    ),
                    child: customText(
                      topImageList[index].libelle as String,
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
        ],
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
        aspectRatio: 2, //4.0,
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
