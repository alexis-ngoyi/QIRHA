import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class NumeroDePaiementCommande extends StatefulWidget {
  const NumeroDePaiementCommande({super.key});

  @override
  State<NumeroDePaiementCommande> createState() =>
      _NumeroDePaiementCommandeState();
}

class _NumeroDePaiementCommandeState extends State<NumeroDePaiementCommande> {
  MaskedTextController myTextController = MaskedTextController(
    mask: '00 000 00 00',
  );
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
          'Numero Mobile Money',
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
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: WHITE,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        height: 80,
        child: GestureDetector(
          onTap: () => {},
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black.withOpacity(.08),
              ),
              color: PRIMARY,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: customText(
                'PAYER MAINTENANT',
                style: TextStyle(color: WHITE, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            espacementWidget(height: 10),
            resumeCommande(),
            espacementWidget(height: 10),
            SizedBox(
              child: customText(
                'Entrez votre Numero Mobile Money',
                style: TextStyle(
                  color: DARK,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            espacementWidget(height: 10),
            inputNumberPhone(context),
            espacementWidget(height: 100),
          ],
        ),
      ),
    );
  }

  Container resumeCommande() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: WHITE,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              HeroIcon(HeroIcons.eye, size: 14, color: DARK),
              espacementWidget(width: 7),
              customText(
                "Apercu de la commande",
                style: TextStyle(
                  color: DARK,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          espacementWidget(height: 8),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: customText(
                      'Sous-total',
                      style: TextStyle(color: LIGHT, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: customText(
                      formatMoney('4000'),
                      style: TextStyle(color: LIGHT, fontSize: 11),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: customText(
                      "Frais d'expedition",
                      style: TextStyle(color: LIGHT, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: customText(
                      formatMoney('1000'),
                      style: TextStyle(color: LIGHT, fontSize: 11),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: customText(
                      "Assurance d'expedition",
                      style: TextStyle(color: LIGHT, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: customText(
                      formatMoney('1000'),
                      style: TextStyle(color: LIGHT, fontSize: 11),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: customText(
                      "Taxes",
                      style: TextStyle(color: LIGHT, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: customText(
                      formatMoney('40'),
                      style: TextStyle(color: LIGHT, fontSize: 11),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: customText(
                      "Total",
                      style: TextStyle(color: LIGHT, fontSize: 13),
                    ),
                  ),
                  Container(
                    child: customText(
                      formatMoney('3540'),
                      style: TextStyle(
                        color: DARK,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container inputNumberPhone(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: WHITE,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              width: 20,
              height: 15,
              child: Image.asset(congo_rc, fit: BoxFit.cover),
            ),
          ),
          espacementWidget(width: 3),
          customText('+242', style: TextStyle(fontSize: 11, color: LIGHT)),
          espacementWidget(width: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: VerticalDivider(width: 1, color: Colors.black.withAlpha(30)),
          ),
          espacementWidget(width: 3),
          Expanded(
            child: TextField(
              keyboardType: const TextInputType.numberWithOptions(),
              minLines: 1,
              controller: myTextController,
              style: TextStyle(
                fontSize: 14,
                color: DARK,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
                hintText: '00 000 00 00',
                hintStyle: TextStyle(fontSize: 11, color: LIGHT),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
