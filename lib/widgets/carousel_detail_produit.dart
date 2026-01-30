// ignore_for_file: non_constant_identifier_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:qirha/api/services.dart';

import 'package:qirha/widgets/produit_image_viewer.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class CarouselDetailProduit extends StatefulWidget {
  const CarouselDetailProduit({
    super.key,
    required this.getCurrentIndex,
    required this.currentProduit,
    required this.currentProduitImage,
  });
  final void Function(int currentIndex) getCurrentIndex;
  final ProduitModel currentProduit;

  final void Function(String currentProduitImage) currentProduitImage;

  @override
  State<CarouselDetailProduit> createState() => _CarouselDetailProduitState();
}

class _CarouselDetailProduitState extends State<CarouselDetailProduit> {
  final CarouselSliderController _controllerCategorieSlider =
      CarouselSliderController();
  int currentIndex = 0;
  GalleryProduitModel? currentProduitImage;
  bool isLoading = true;
  final List<GalleryProduitModel> gallerieList = [];

  getProduitsGallery({String produit_couleur_id = "0"}) async {
    setState(() {
      isLoading = true;
    });

    var galleries = await ApiServices().getProduitsGallery(
      widget.currentProduit.produit_id.toString(),
    );

    galleries.forEach((g) {
      setState(() {
        gallerieList.add(
          GalleryProduitModel(
            produit_gallery_id: g['produit_gallery_id'],
            url_image: g['url_image'].toString(),
          ),
        );
      });
    });

    // default image
    setState(() {
      isLoading = false;
      currentProduitImage = gallerieList[currentIndex];

      // Emitting default data
      widget.getCurrentIndex.call(currentIndex);
    });
  }

  @override
  void initState() {
    super.initState();

    getProduitsGallery();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isLoading == false
            ? carouselImage()
            : const SizedBox(
                height: 250,
                width: double.infinity,
                child: Center(child: CircularProgressIndicator()),
              ),
        Positioned(
          bottom: widget.currentProduit.est_en_promo == true ? 38 : 5,
          left: 10,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: GREY,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    customText(
                      isLoading ? "0" : (currentIndex + 1).toString(),
                      style: TextStyle(
                        fontSize: 15,
                        color: PRIMARY,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    customText(
                      '/${gallerieList.length}',
                      style: TextStyle(fontSize: 11, color: DARK),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  CarouselSlider carouselImage() {
    return CarouselSlider(
      carouselController: _controllerCategorieSlider,
      items: gallerieList.map((gallery) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () =>
                  CustomPageRoute(const customGalleryViewer(), context),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FadeInImage.assetNetwork(
                  placeholder: placeholder,
                  image: gallery.url_image as String,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        autoPlay: false,
        enlargeCenterPage: true,
        aspectRatio: 1,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        viewportFraction: 1,
        onPageChanged: (index, reason) {
          setState(() {
            currentIndex = index;
            currentProduitImage = gallerieList[currentIndex];

            // emit currentIndex
            widget.getCurrentIndex.call(index);

            // emit  quantiteRestant
            // widget.getQuantiteRestant.call(
            //   gallerieList[currentIndex].restant.toString(),
            // );

            // // emit image_id
            // widget.currentProduitImage.call(
            //   gallerieList[currentIndex].image_id.toString(),
            // );
          });
        },
      ),
    );
  }
}
