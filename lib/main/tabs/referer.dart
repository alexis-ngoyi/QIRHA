import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class MainTabFemmesScreen extends StatefulWidget {
  const MainTabFemmesScreen({super.key});

  @override
  State<MainTabFemmesScreen> createState() => _MainTabFemmesScreenState();
}

class _MainTabFemmesScreenState extends State<MainTabFemmesScreen> {
  int _currentCarouselBannerIndex = 0;
  final CarouselSliderController _controllerSlider = CarouselSliderController();
  final List<String> imageList = <String>[
    'https://m.media-amazon.com/images/I/51YZofttWSL._SX3000_.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
            customText(
              'Acheter par categorie',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
