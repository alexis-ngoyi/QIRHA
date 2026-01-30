import 'package:flutter/material.dart';
import 'package:qirha/api/services.dart';

import 'package:qirha/widgets/produit_image_viewer.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/shimmer_widget.dart';

class CustomImageScrollHorizontal extends StatefulWidget {
  const CustomImageScrollHorizontal({super.key, required this.produit});
  final ProduitModel produit;

  @override
  State<CustomImageScrollHorizontal> createState() =>
      _CustomImageScrollHorizontalState();
}

class _CustomImageScrollHorizontalState
    extends State<CustomImageScrollHorizontal> {
  final List<String> produitGallery = <String>[];
  bool isLoading = true;

  getProduitGallery() async {
    setState(() {
      isLoading = true;
    });
    var gallery = await ApiServices().getProduitGallery(
      widget.produit.produit_id as String,
    );

    print(gallery);

    gallery.forEach((produit) {
      setState(() {
        produitGallery.add(produit['image']);
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getProduitGallery();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (isLoading)
            Container(
              margin: const EdgeInsets.all(3.0),
              child: MyShimmerWidget(
                width: MediaQuery.of(context).size.width / 2 - 50,
                height: 150,
              ),
            ),
          if (isLoading)
            Container(
              margin: const EdgeInsets.all(3.0),
              child: MyShimmerWidget(
                width: MediaQuery.of(context).size.width / 2 - 50,
                height: 150,
              ),
            ),
          if (isLoading)
            Container(
              margin: const EdgeInsets.all(3.0),
              child: MyShimmerWidget(
                width: MediaQuery.of(context).size.width / 2 - 50,
                height: 150,
              ),
            ),
          if (isLoading == false)
            for (var i = 0; i < produitGallery.length; i++)
              GestureDetector(
                onTap: () =>
                    CustomPageRoute(const customGalleryViewer(), context),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2 - 50,
                    height: 150,
                    decoration: BoxDecoration(
                      color: GREY,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: FadeInImage.assetNetwork(
                      placeholder: placeholder,
                      image: produitGallery[i],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
