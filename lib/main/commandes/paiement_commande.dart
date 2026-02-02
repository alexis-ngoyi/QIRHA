import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/widgets/combo/custom_button.dart';
import 'package:qirha/functions/util_functions.dart';

import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class PaiementCommandePage extends StatefulWidget {
  const PaiementCommandePage({super.key, required this.sousTotal});
  final double sousTotal;

  @override
  State<PaiementCommandePage> createState() => _PaiementCommandePageState();
}

class _PaiementCommandePageState extends State<PaiementCommandePage> {
  String modePaiement = 'MTN Mobile Money';

  MaskedTextController myTextController = MaskedTextController(
    mask: '00 000 00 00',
  );

  @override
  void initState() {
    super.initState();
  }

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
          'Paiement de la commande',
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              espacementWidget(height: 7),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  modePaiementItem(
                    context,
                    title: "MTN Mobile Money",
                    enable: true,
                    defaultValue: "MTN Mobile Money",
                    subtitle: "Payer avec MTN Mobile Money",
                    logo: mtn_logo,
                    value: modePaiement,
                  ),
                  modePaiementItem(
                    context,
                    title: "AIRTEL Mobile Money",
                    enable: true,
                    defaultValue: "AIRTEL Mobile Money",
                    subtitle: "Payer avec AIRTEL Mobile Money",
                    logo: airtel_logo,
                    value: modePaiement,
                  ),

                  modePaiementItem(
                    context,
                    title: "Paiement En main",
                    enable: true,
                    defaultValue: "Paiement En main",
                    subtitle: "Payer en main a la livraison",
                    logo: money_hand,
                    network: true,
                    value: modePaiement,
                  ),
                ],
              ),

              espacementWidget(height: 7),

              confirmeButton(context),

              // fin
            ],
          ),
        ),
      ),
    );
  }

  Container confirmeButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: WHITE,
      ),
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            espacementWidget(height: 7),

            customText(
              'TOTAL : ${formatMoney((double.parse(widget.sousTotal.toString())).toString())}',
              style: TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
                color: PRIMARY,
                fontWeight: FontWeight.bold,
              ),
            ),

            espacementWidget(height: 7),

            if (modePaiement != 'Paiement En main') inputNumberPhone(context),

            espacementWidget(height: 14),

            if (modePaiement != 'Paiement En main')
              SizedBox(
                height: 40,
                width: MediaQuery.of(context).size.width / 2,
                child: MyButtonWidget(
                  onPressed: () => {},
                  label: 'VALIDER LE PAIEMENT ',
                  bgColor: PRIMARY,
                  labelColor: WHITE,
                ),
              ),
          ],
        ),
      ),
    );
  }

  GestureDetector modePaiementItem(
    BuildContext context, {
    required String logo,
    required String title,
    required String subtitle,
    bool network = false,
    required bool enable,
    required String defaultValue,
    required String value,
  }) {
    return GestureDetector(
      onTap: enable
          ? () => setState(() {
              modePaiement = defaultValue;
              // print('Mode Paiement: ${modePaiement}');
            })
          : () => {},
      //  customToast(context,
      //     description: 'Mode de paiement non disponible',
      //     type: ToastificationType.info),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          border: defaultValue != value
              ? Border.all(width: 1, color: GREY)
              : Border.all(width: 1, color: PRIMARY.withAlpha(60)),
          color: WHITE,
          borderRadius: BorderRadius.circular(8),
        ),
        width: MediaQuery.of(context).size.width * .3,
        margin: EdgeInsets.all(2),
        height: 130,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.asset(
                logo,
                width: 50,
                height: 35,
                filterQuality: FilterQuality.medium,
                fit: network ? BoxFit.contain : BoxFit.cover,
              ),
            ),

            espacementWidget(height: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  softWrap: true,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: DARK,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            espacementWidget(height: 5),
            enable
                ? Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: defaultValue == value ? PRIMARY : GREY,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      enable ? Icons.check : Icons.close,
                      size: 11,
                      color: WHITE,
                    ),
                  )
                : Container(
                    height: 15,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: DANGER),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                      children: [
                        HeroIcon(
                          HeroIcons.exclamationTriangle,
                          size: 10,
                          color: DANGER,
                        ),
                        espacementWidget(width: 3),
                        customText(
                          'OFF',
                          style: TextStyle(fontSize: 7, color: DANGER),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget inputNumberPhone(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: PRIMARY.withAlpha(40),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: myTextController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          fontSize: 14,
          color: DARK,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          hintText: 'Entrez votre numero mobile money',
          hintStyle: TextStyle(fontSize: 11, color: LIGHT),
        ),
      ),
    );
  }
}
