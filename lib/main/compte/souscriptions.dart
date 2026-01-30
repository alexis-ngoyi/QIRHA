import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/widgets/input/checkbox_widget.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CompteSouscriptionsEmail extends StatefulWidget {
  const CompteSouscriptionsEmail({super.key});

  @override
  State<CompteSouscriptionsEmail> createState() =>
      _CompteSouscriptionsEmailState();
}

class _CompteSouscriptionsEmailState extends State<CompteSouscriptionsEmail> {
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
          'Souscriptions E-mail',
          style: TextStyle(
            fontSize: 17,
            color: DARK,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [espacementWidget(width: 10)],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            espacementWidget(height: 10),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 7),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: PRIMARY,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    'Souscriptions E-mail pour',
                    style: TextStyle(fontSize: 10, color: WHITE),
                  ),
                  customText(
                    'alexisng@gmail.com',
                    style: TextStyle(
                      fontSize: 13,
                      color: WHITE,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            espacementWidget(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 10),
              color: WHITE,
              child: Column(
                children: [
                  souscriptionCard(
                    context,
                    title: 'Nouvelles offres promotionnelles',
                    subtitle:
                        "Accedez facilement a nos dernieres offres, a nos offres exclusives par e-mail. Offres de vente Bazard et cadeaux",
                    frequence: "Normal",
                  ),
                  souscriptionCard(
                    context,
                    title: 'Nouvelles offres promotionnelles',
                    subtitle:
                        "Accedez facilement a nos dernieres offres, a nos offres exclusives par e-mail. Offres de vente Bazard et cadeaux",
                    frequence: "Normal",
                    last: true,
                  ),
                ],
              ),
            ),
            espacementWidget(height: 10),
            listLinkItem(
              context,
              label: 'Souscrire a tous les E-mail',
              trailingLabel: '',
              actions: [CustomCheckbox(onChange: (active) => {})],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: customText(
                '''Veuillez noter que recevrez encore des e-mails concernant votre compte, vos commandes et colis. Cela devrait prendre 48 heures avant que ces changements soient effectifs. Nous apprecions votre patience pendant que nous effectuons ces changements.''',
                maxLines: 10000,
                style: TextStyle(
                  fontSize: 10,
                  overflow: TextOverflow.ellipsis,
                  color: LIGHT,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row souscriptionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String frequence,
    bool last = false,
  }) {
    return Row(
      children: [
        const HeroIcon(HeroIcons.gift, size: 20),
        espacementWidget(width: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width - 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: DARK,
                  fontWeight: FontWeight.bold,
                ),
              ),
              espacementWidget(height: 2),
              customText(
                subtitle,
                maxLines: 100,
                style: TextStyle(fontSize: 11, color: LIGHT),
              ),
              espacementWidget(height: 2),
              Row(
                children: [
                  customText(
                    "Frequence: ",
                    style: TextStyle(fontSize: 11, color: DARK),
                  ),
                  customText(
                    " $frequence",
                    style: TextStyle(fontSize: 11, color: PRIMARY),
                  ),
                ],
              ),
              if (!last)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, thickness: 1, color: GREY),
                ),
            ],
          ),
        ),
        espacementWidget(width: 10),
        HeroIcon(HeroIcons.chevronRight, size: 18, color: LIGHT),
      ],
    );
  }
}
