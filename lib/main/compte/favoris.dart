import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class CompteFavoris extends StatefulWidget {
  const CompteFavoris({super.key});

  @override
  State<CompteFavoris> createState() => _CompteFavorisState();
}

class _CompteFavorisState extends State<CompteFavoris> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      appBar: AppBar(
        backgroundColor: WHITE,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const HeroIcon(HeroIcons.chevronLeft, size: 25),
        ),
        title: customText(
          'Mes favoris',
          style: TextStyle(
            fontSize: 17,
            color: DARK,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          MyCartWidget(size: 25, color: DARK),
          espacementWidget(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [emptyFavoris(), espacementWidget(height: 40)]),
      ),
    );
  }

  Center emptyFavoris() {
    return Center(
      child: Column(
        children: [
          const Image(image: AssetImage(empty_cart), height: 230, width: 230),
          customText(
            'La liste de favoris est vide',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          customText(
            "Vous n'avez pas encore ajoute d'article a vos favoris",
            style: const TextStyle(fontSize: 12),
          ),
          espacementWidget(height: 10),
        ],
      ),
    );
  }
}
