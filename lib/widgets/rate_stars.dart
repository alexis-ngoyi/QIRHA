import 'package:flutter/material.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CustomRateStars extends StatefulWidget {
  const CustomRateStars({super.key, required this.produit});
  final ProduitModel produit;

  @override
  State<CustomRateStars> createState() => _CustomRateStarsState();
}

class _CustomRateStarsState extends State<CustomRateStars> {
  @override
  Widget build(BuildContext context) {
    return lesEtoiles();
  }

  Row lesEtoiles() {
    return Row(
      children: [
        Icon(Icons.star, size: 13, color: PRIMARY),
        Icon(Icons.star, size: 13, color: PRIMARY),
        Icon(Icons.star, size: 13, color: PRIMARY),
        Icon(Icons.star, size: 13, color: PRIMARY),
        Icon(Icons.star_half, size: 13, color: PRIMARY),
        espacementWidget(width: 3),
        customText('(30)', style: TextStyle(color: LIGHT, fontSize: 12)),
      ],
    );
  }
}
