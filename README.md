# qirha

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


import 'package:flutter/material.dart';

class BannerCarouselSlider extends StatefulWidget {
  const BannerCarouselSlider({super.key});

  @override
  State<BannerCarouselSlider> createState() => _BannerCarouselSliderState();
}

class _BannerCarouselSliderState extends State<BannerCarouselSlider> {
  int _currentCarouselBannerIndex = 0;

  final List<String> imageList = [
    "assets/img1.jpg",
    "assets/img2.jpg",
    "assets/img3.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔥 Nouveau widget CarouselView
        CarouselView(
          itemExtent: MediaQuery.of(context).size.width, // largeur pleine
          itemSnapping: true, // défilement fluide avec snapping
          enableInfiniteScroll: true, // boucle infinie
          onTap: (index) {
            // action au clic sur une image
          },
          onPageChanged: (index) {
            setState(() {
              _currentCarouselBannerIndex = index;
            });
          },
          children: imageList.map((imgPath) {
            return Image.asset(
              imgPath,
              fit: BoxFit.cover, // occupe tout l’espace
              width: double.infinity,
            );
          }).toList(),
        ),

        // 🔘 Indicateurs
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                // possibilité de contrôler le scroll si besoin
              },
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.blue)
                      .withOpacity(
                          _currentCarouselBannerIndex == entry.key ? 0.9 : 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
