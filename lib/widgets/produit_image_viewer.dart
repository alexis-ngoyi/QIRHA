// ignore_for_file: camel_case_types

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class customGalleryViewer extends StatefulWidget {
  const customGalleryViewer({super.key});

  @override
  State<customGalleryViewer> createState() => _customGalleryViewerState();
}

class _customGalleryViewerState extends State<customGalleryViewer> {
  final CarouselSliderController _controllerCategorieSlider =
      CarouselSliderController();
  int _currentCarouselCategorieIndex = 0;

  final List<String> gallerieList = [
    'https://m.media-amazon.com/images/I/71gdsV24uDL._AC_SY535_.jpg',
    'https://m.media-amazon.com/images/I/91QZEFoH-HL._AC_SX625_.jpg',
    'https://m.media-amazon.com/images/I/81Dh3-zHCsL._AC_SY675_.jpg',
    'https://m.media-amazon.com/images/I/71-og9SGxtL._AC_SY741_.jpg',
    'https://m.media-amazon.com/images/I/71n-feem8lS._AC_SY679_.jpg',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: WHITE,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            espacementWidget(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(''),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.close,
                      color: DARK,
                    ),
                  ),
                )
              ],
            ),
            espacementWidget(
              height: 100,
            ),
            CarouselSlider(
              carouselController: _controllerCategorieSlider,
              items: gallerieList.map((image) {
                return Builder(builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: FadeInImage.assetNetwork(
                      placeholder: placeholder,
                      image: image,
                      fit: BoxFit.cover,
                    ),
                  );
                });
              }).toList(),
              options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: true,
                  aspectRatio: 1.1,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentCarouselCategorieIndex = index;
                    });
                  }),
            ),
            espacementWidget(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Column(
                children: [
                  customText(
                    '${_currentCarouselCategorieIndex + 1}/${gallerieList.length}',
                    style: TextStyle(color: DARK),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  customText(
                    "Publie par l'equipe de prospection qirha",
                    style: TextStyle(color: DARK, fontSize: 12),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
