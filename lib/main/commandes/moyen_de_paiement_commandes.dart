import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/main/commandes/numero_de_paiement.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/combo/custom_button.dart';

class MoyenDePaiementCommande extends StatefulWidget {
  const MoyenDePaiementCommande({super.key});

  @override
  State<MoyenDePaiementCommande> createState() =>
      _MoyenDePaiementCommandeState();
}

class _MoyenDePaiementCommandeState extends State<MoyenDePaiementCommande> {
  String modePaiement = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      appBar: AppBar(
        backgroundColor: WHITE,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const HeroIcon(
            HeroIcons.chevronLeft,
            size: 25,
          ),
        ),
        title: customText(
          'Mode de paiement',
          style:
              TextStyle(fontSize: 17, color: DARK, fontWeight: FontWeight.bold),
        ),
        actions: [
          MyCartWidget(
            size: 24,
            color: DARK,
          ),
          espacementWidget(
            width: 10,
          ),
        ],
      ),
      body: Stack(
        children: [
          mainContent(context),
          Positioned(bottom: 0, child: procederPaiement(context))
        ],
      ),
    );
  }

  Positioned procederPaiement(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: Container(
          color: WHITE,
          height: 150,
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText('Mode de paiement :',
                        style: const TextStyle(
                          fontSize: 12,
                        )),
                    customText(modePaiement.toString(),
                        style: TextStyle(
                            fontSize: 12,
                            color: BLUE,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                customDivider(),
                Column(
                  children: [
                    customText("Guarrantissons vos paiements en toute securite",
                        softWrap: true,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 10,
                        )),
                    espacementWidget(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (modePaiement != "Paiement a la livraison")
                          Expanded(
                            flex: 1,
                            child: MyButtonWidget(
                                onPressed: () => CustomPageRoute(
                                    const NumeroDePaiementCommande(), context),
                                label: 'PROCEDER AU PAIEMENT',
                                bgColor: BLUE,
                                labelColor: WHITE),
                          ),
                        if (modePaiement == "Paiement a la livraison")
                          Expanded(
                            flex: 1,
                            child: MyButtonWidget(
                                onPressed: () => CustomPageRoute(
                                    const NumeroDePaiementCommande(), context),
                                label: 'PAYER SUR PLACE',
                                bgColor: BLUE,
                                labelColor: WHITE),
                          ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }

  SingleChildScrollView mainContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                espacementWidget(height: 30),
                Image.asset(
                  security,
                  fit: BoxFit.contain,
                  width: 150,
                  height: 100,
                ),
                Container(
                  color: WHITE,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: customCenterText(
                        "Nous vous proposons des moyens de paiements sur et securises tant national qu'un international.\nChoisissez le mode de paiement qui vous correspond. ",
                        textAlign: TextAlign.center,
                        maxLines: 5,
                        style: TextStyle(color: DARK, fontSize: 12)),
                  ),
                ),
                espacementWidget(height: 30)
              ],
            ),
          ),
          espacementWidget(height: 7),
          modePaiementItem(context,
              title: "MTN Mobile Money",
              enable: true,
              defaultValue: "MTN Mobile Money",
              subtitle: "Payer avec MTN Mobile Money",
              logo: mtn_logo,
              value: modePaiement),
          espacementWidget(height: 7),
          modePaiementItem(context,
              title: "AIRTEL Money",
              enable: true,
              defaultValue: "AIRTEL Money",
              subtitle: "Payer avec AIRTEL Money",
              logo: airtel_logo,
              value: modePaiement),
          espacementWidget(height: 7),
          // modePaiementItem(context,
          //     title: "Paiement VISA",
          //     enable: false,
          //     defaultValue: "Paiement VISA",
          //     subtitle: "Payer avec votre carte VISA",
          //     logo: visa,
          //     value: modePaiement),
          // espacementWidget(height: 7),
          // modePaiementItem(context,
          //     title: "Paiement MasterCard",
          //     enable: false,
          //     defaultValue: "Paiement MasterCard",
          //     subtitle: "Payer avec votre carte MasterCard",
          //     logo: mastercard,
          //     value: modePaiement),
          // espacementWidget(height: 7),
          modePaiementItem(context,
              title: "Paiement en Main ( En espece )",
              enable: true,
              defaultValue: "Paiement a la livraison",
              subtitle: "Payer en main a la livraison",
              logo: money_hand,
              network: true,
              value: modePaiement),
          espacementWidget(height: 400),
        ],
      ),
    );
  }

  GestureDetector modePaiementItem(BuildContext context,
      {required String logo,
      required String title,
      required String subtitle,
      bool network = false,
      required bool enable,
      required String defaultValue,
      required String value}) {
    return GestureDetector(
      onTap: enable
          ? () => setState(() {
                modePaiement = defaultValue;
                // print('Mode Paiement: ${modePaiement}');
              })
          : () => {}
      //  customToast(context,
      //     description: 'Mode de paiement non disponible',
      //     type: ToastificationType.info),
      ,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            border: defaultValue != value
                ? Border.all(width: 1, color: GREY)
                : null,
            color: defaultValue == value ? Colors.indigo.withAlpha(30) : WHITE,
            borderRadius: BorderRadius.circular(8)),
        width: MediaQuery.of(context).size.width,
        child: Row(
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
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    title,
                    style: TextStyle(
                        fontSize: 12, color: DARK, fontWeight: FontWeight.bold),
                  ),
                  customText(
                    subtitle,
                    style: TextStyle(fontSize: 10, color: LIGHT),
                  ),
                ],
              ),
            )),
            enable
                ? Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        color: defaultValue == value ? BLUE : GREY,
                        borderRadius: BorderRadius.circular(100)),
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
                        borderRadius: BorderRadius.circular(3)),
                    child: Row(
                      children: [
                        HeroIcon(
                          HeroIcons.exclamationTriangle,
                          size: 10,
                          color: DANGER,
                        ),
                        espacementWidget(width: 3),
                        customText('OFF',
                            style: TextStyle(fontSize: 7, color: DANGER))
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  popModalRequestNumber() {
    // print('object');
  }
}
