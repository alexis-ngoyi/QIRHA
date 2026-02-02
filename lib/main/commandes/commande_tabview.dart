// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/widgets/empty/no_commande.dart';
import 'package:qirha/widgets/image_svg.dart';
import 'package:qirha/widgets/need_to_login.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/main/commandes/detail_commande.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/constantes.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/text_collapse_widget.dart';

class CommandeTabView extends StatefulWidget {
  const CommandeTabView({super.key, required this.status});
  final String status;

  @override
  State<CommandeTabView> createState() => _CommandeTabViewState();
}

class _CommandeTabViewState extends State<CommandeTabView> {
  final List<CommandeModel> ListCommandes = [];
  bool isLoading = true;
  late bool needLogin;
  late String? utilisateur_id;

  getCommandes() async {
    // load view
    setState(() {
      isLoading = true;
    });

    var commandes = await ApiServices().getCommandes(utilisateur_id);

    commandes.forEach((commande) {
      if (commande['status'] == widget.status) {
        setState(() {
          ListCommandes.add(
            CommandeModel(
              commande_id: commande['commande_id'],
              utilisateur_id: commande['utilisateur_id'],
              nom_utilisateur: commande['nom_utilisateur'],
              date_commande: commande['date_commande'],
              montant_total: parseDouble(commande['montant_total'].toString()),
              status: commande['status'],
              accepte_la_livraison: commande['accepte_la_livraison'],
              code_commande: commande['code_commande'],
            ),
          );
        });
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  Timer? main_timer;

  authGuard() {
    // Define the interval duration in milliseconds
    const intervalDuration = Duration(seconds: 1);

    // Set up a periodic timer
    main_timer = Timer.periodic(intervalDuration, (timer) async {
      setState(() {
        needLogin = utilisateur_id == null ? true : false;
      });

      if (!needLogin) getCommandes();

      timer.cancel();
    });
  }

  @override
  void initState() {
    super.initState();
    needLogin = true;
    utilisateur_id = prefs.getString('utilisateur_id');

    authGuard();
  }

  @override
  void dispose() {
    super.dispose();
    main_timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      body: SingleChildScrollView(
        child: ListCommandes.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  espacementWidget(height: 8),
                  for (var index = 0; index < ListCommandes.length; index++)
                    GestureDetector(
                      onTap: () => CustomPageRoute(
                        DetailCommandeProduit(commande: ListCommandes[index]),
                        context,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: commandeItem(
                          context,
                          commande: ListCommandes[index],
                        ),
                      ),
                    ),

                  espacementWidget(height: 10),
                ],
              )
            : Container(
                child: Center(
                  child: Column(
                    children: [
                      // MySvgImageWidget(asset: empty, height: 130, width: 130),
                      espacementWidget(height: 200),
                      Text(
                        'Aucunes commandes ...',
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Container commandeItem(
    BuildContext context, {
    required CommandeModel commande,
  }) {
    return Container(
      color: WHITE,
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    'Commande : ${commande.code_commande}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  Row(
                    children: [
                      customText(
                        "Montant total d'article : ",
                        style: const TextStyle(fontSize: 11),
                      ),
                      customText(
                        formatMoney(commande.montant_total.toString()),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    customText(
                      'Plus de details',
                      style: TextStyle(
                        color: PRIMARY,
                        fontSize: 11,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    espacementWidget(width: 5),
                    const HeroIcon(HeroIcons.chevronRight, size: 12),
                  ],
                ),
              ),
            ],
          ),
          customDivider(),
          Row(
            children: [
              HeroIcon(
                statusCommandeIcon(commande.status.toString()),
                size: 12,
                color: statusCommandeColor(commande.status.toString()),
              ),
              espacementWidget(width: 5),
              customText(
                statusCommande(commande.status.toString()),
                style: TextStyle(
                  color: statusCommandeColor(commande.status.toString()),
                  fontSize: 11,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          customText(
            commande.date_commande.toString(),
            style: TextStyle(
              color: LIGHT,
              fontSize: 11,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
