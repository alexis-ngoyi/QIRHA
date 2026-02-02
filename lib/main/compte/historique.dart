import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class CompteHistorique extends StatefulWidget {
  const CompteHistorique({super.key});

  @override
  State<CompteHistorique> createState() => _CompteHistoriqueState();
}

class _CompteHistoriqueState extends State<CompteHistorique> {
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
          'Mes historiques',
          style: TextStyle(
            fontSize: 17,
            color: DARK,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          MyCartWidget(size: 24, color: DARK),
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
            'Votre historique est vide',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          customText(
            "Vous n'avez pas encore consulte des articles",
            style: const TextStyle(fontSize: 12),
          ),
          espacementWidget(height: 10),
        ],
      ),
    );
  }
}
