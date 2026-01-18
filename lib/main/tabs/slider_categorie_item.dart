// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:qirha/main/categorie/produit_par_categorie_hot.dart';
import 'package:qirha/model/categorie.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class SliderCategorieItem extends StatefulWidget {
  const SliderCategorieItem({super.key, required this.categorieList});

  final List<CategorieModel> categorieList;

  @override
  State<SliderCategorieItem> createState() => _SliderCategorieItemState();
}

class _SliderCategorieItemState extends State<SliderCategorieItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 1,
          childAspectRatio: .84,
          mainAxisExtent: 97),
      itemCount: widget.categorieList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => CustomPageRoute(
              ProduitParCategorieHot(
                categorie: widget.categorieList[index],
                typeView: 'HOT',
              ),
              context),
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
                    child: Image.asset(
                      widget.categorieList[index].img as String,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                child: customCenterText(
                  widget.categorieList[index].libelle as String,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: DARK),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
