// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/widgets/empty/no_commande.dart';
import 'package:qirha/widgets/need_to_login.dart';
import 'package:qirha/functions/money_format.dart';
import 'package:qirha/functions/status_commande.dart';
import 'package:qirha/main/commandes/detail_commande.dart';
import 'package:qirha/model/commandes.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/constantes.dart';
import 'package:qirha/res/utils.dart';

class CommandeStatus extends StatefulWidget {
  const CommandeStatus({super.key, required this.status});
  final String status;

  @override
  State<CommandeStatus> createState() => _CommandeStatusState();
}

class _CommandeStatusState extends State<CommandeStatus> {
  final List<CommandeModel> ListCommandes = [];
  bool isLoading = true;
  bool needLogin = true;
  late String? utilisateur_id = prefs.getString('utilisateur_id');

  getCommandes() async {
    // load view
    setState(() {
      isLoading = true;
    });

    var commandes = await ApiServices().getCommandes(utilisateur_id);

    commandes.forEach((commande) {
      if (commande['status'] == widget.status) {
        setState(() {
          ListCommandes.add(CommandeModel(
            commande_id: commande['commande_id'],
            date_commande: commande['date_commande'],
            montant_total: commande['montant_total'],
            nom_utilisateur: commande['utilisateur']['nom_utilisateur'],
            status: commande['status'],
            utilisateur_id:
                commande['utilisateur']['utilisateur_id'].toString(),
          ));
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
      if (utilisateur_id == null) {
        setState(() {
          needLogin = true;
          isLoading = false;
        });
      } else {
        getCommandes();
      }
      timer.cancel();
    });
  }

  @override
  void initState() {
    super.initState();

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
        body: isLoading == false
            ? Column(
                children: [
                  needLogin == false
                      ? SingleChildScrollView(
                          child: ListCommandes.isNotEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    espacementWidget(height: 8),
                                    for (var index = 0;
                                        index < ListCommandes.length;
                                        index++)
                                      GestureDetector(
                                        onTap: () => CustomPageRoute(
                                            DetailCommandeProduit(
                                              commande: ListCommandes[index],
                                            ),
                                            context),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: commandeItem(context,
                                              commande: ListCommandes[index]),
                                        ),
                                      ),
                                    espacementWidget(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Container(
                                        color: WHITE,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: customCenterText(
                                            'Je ne trouve pas ma commande',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 13, color: DARK)),
                                      ),
                                    ),
                                    espacementWidget(height: 10),
                                  ],
                                )
                              : const Center(
                                  child: NoCommandeWidget(),
                                ),
                        )
                      : (needLogin == true
                          ? const Scaffold(body: NeedToLogin())
                          : const Scaffold(
                              body: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ))
                ],
              )
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ));
  }

  Container commandeItem(BuildContext context,
      {required CommandeModel commande}) {
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
                      'Commande #$prefixCodeCommande${commande.commande_id}',
                      style: const TextStyle(fontSize: 11)),
                  Row(
                    children: [
                      customText("Montant total d'article : ",
                          style: const TextStyle(fontSize: 11)),
                      customText(formatMoney(commande.montant_total.toString()),
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    customText('Plus de details',
                        style: TextStyle(
                            color: BLUE,
                            fontSize: 11,
                            overflow: TextOverflow.ellipsis)),
                    espacementWidget(width: 5),
                    const HeroIcon(
                      HeroIcons.chevronRight,
                      size: 12,
                    ),
                  ],
                ),
              )
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
              customText(statusCommande(commande.status.toString()),
                  style: TextStyle(
                      color: statusCommandeColor(commande.status.toString()),
                      fontSize: 11,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
          customText(commande.date_commande.toString(),
              style: TextStyle(
                  color: LIGHT, fontSize: 11, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
