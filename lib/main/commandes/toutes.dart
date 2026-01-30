// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/main/commandes/detail_commande.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/constantes.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/empty/no_commande.dart';

class MesCommandesTabTout extends StatefulWidget {
  const MesCommandesTabTout({super.key});

  @override
  State<MesCommandesTabTout> createState() => _MesCommandesTabToutState();
}

class _MesCommandesTabToutState extends State<MesCommandesTabTout> {
  List<CommandeModel> ListCommandes = [];
  bool isLoading = true;
  late String? utilisateur_id;

  getCommandes() async {
    setState(() {
      isLoading = true;
      ListCommandes = [];
    });

    var commandes = await ApiServices().getCommandes(utilisateur_id);

    print(commandes.length);

    if (commandes != Null) {
      commandes.forEach((commande) {
        setState(() {
          ListCommandes.add(
            CommandeModel(
              commande_id: commande['commande_id'],
              date_commande: commande['date_commande'],
              montant_total: commande['montant_total'],
              nom_utilisateur: commande['utilisateur']['nom_utilisateur'],
              status: commande['status'],
              utilisateur_id: commande['utilisateur']['utilisateur_id']
                  .toString(),
            ),
          );
        });
      });
    } else {
      // print("utilisateur_id commande null :$utilisateur_id");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // get utilisateur_id
    utilisateur_id = prefs.getString('utilisateur_id');

    getCommandes();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getCommandes();
      },
      child: Scaffold(
        backgroundColor: GREY,
        body: isLoading == false
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: ListCommandes.isNotEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                espacementWidget(height: 8),
                                for (
                                  var index = 0;
                                  index < ListCommandes.length;
                                  index++
                                )
                                  GestureDetector(
                                    onTap: () => CustomPageRoute(
                                      DetailCommandeProduit(
                                        commande: ListCommandes[index],
                                      ),
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
                                espacementWidget(height: 5),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Container(
                                    color: WHITE,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: customCenterText(
                                      'Je ne trouve pas ma commande',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: DARK,
                                      ),
                                    ),
                                  ),
                                ),
                                espacementWidget(height: 10),
                              ],
                            )
                          : const Center(child: NoCommandeWidget()),
                    ),
                  ],
                ),
              )
            : Center(child: CircularProgressIndicator()),
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
                    'Commande #$prefixCodeCommande${commande.commande_id}',
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
