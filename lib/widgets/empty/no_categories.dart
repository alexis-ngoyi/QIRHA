import 'package:flutter/material.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class NoCategorieWidget extends StatefulWidget {
  const NoCategorieWidget({super.key});

  @override
  State<NoCategorieWidget> createState() => _NoCategorieWidgetState();
}

class _NoCategorieWidgetState extends State<NoCategorieWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          espacementWidget(height: 100),
          Center(
            child: SizedBox(
              width: 80,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FadeInImage.assetNetwork(
                  placeholder: placeholder,
                  image: categorie_default,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          espacementWidget(height: 10),
          customCenterText('Aucune categorie',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: DARK, fontWeight: FontWeight.bold)),
          espacementWidget(height: 20),
          customCenterText(
              "L'equipe Qirha travaille sans relache pour vous garantir une meilleure experience ",
              maxLines: 4,
              textAlign: TextAlign.center,
              style: TextStyle(color: DARK, fontSize: 12)),
          espacementWidget(height: 10),
        ],
      ),
    );
  }
}
