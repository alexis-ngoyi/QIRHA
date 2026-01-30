// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';

import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class BazardHomePage extends StatefulWidget {
  const BazardHomePage({super.key});
  @override
  State<BazardHomePage> createState() => _BazardHomePageState();
}

class _BazardHomePageState extends State<BazardHomePage> {
  bool isLoading = false;
  List<Tab> tabs = <Tab>[const Tab(text: 'Tout')];
  List<Widget> tabViews = <Widget>[const BazardToutProduit()];

  getMainCategorie() async {
    setState(() {
      isLoading = true;
    });

    var main_categorie = await ApiServices().getMainCategorie();

    main_categorie.forEach((main) {
      setState(() {
        // loading tabs
        tabs.add(Tab(text: main['nom_main_categorie']));
        // loading views
        tabViews.add(
          BazardHomeItem(
            main_categorie_id: main['main_categorie_id'].toString(),
          ),
        );
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  late Timer _timer;
  late int _totalDurationInSeconds = 3600 * 10;
  late String hours = '00';
  late String minutes = '00';
  late String remainingSeconds = '00';

  void _onTimerTick(Timer timer) {
    setState(() {
      if (_totalDurationInSeconds > 0) {
        _totalDurationInSeconds--;
      } else {
        _timer.cancel();
      }
    });
  }

  String _twoDigitFormatter(int n) => n.toString().padLeft(2, '0');

  void _formatDuration(int seconds) {
    setState(() {
      hours = _twoDigitFormatter(seconds ~/ 3600);
      minutes = _twoDigitFormatter((seconds % 3600) ~/ 60);
      remainingSeconds = _twoDigitFormatter(seconds % 60);
    });
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _onTimerTick);
    hours = '00';
    minutes = '00';
    remainingSeconds = '00';

    getMainCategorie();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger countdown
    if (_totalDurationInSeconds > 0) _formatDuration(_totalDurationInSeconds);

    return isLoading == false
        ? DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              backgroundColor: GREY,
              appBar: BazardAppBar(context, tabs: tabs),
              body: IconTheme(
                data: const IconThemeData(color: Colors.black),
                child: TabBarView(children: tabViews),
              ),
            ),
          )
        : const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Row CustomHourCountdown() {
    return Row(
      children: [
        customText(
          'Se termine dans',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: PRIMARY,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: customText(
              hours,
              style: TextStyle(fontSize: 10, color: WHITE),
            ),
          ),
        ),
        customText(':', style: const TextStyle(fontSize: 10)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: PRIMARY,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: customText(
              minutes,
              style: TextStyle(fontSize: 10, color: WHITE),
            ),
          ),
        ),
        customText(':', style: const TextStyle(fontSize: 10)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: PRIMARY,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: customText(
              remainingSeconds,
              style: TextStyle(fontSize: 10, color: WHITE),
            ),
          ),
        ),
      ],
    );
  }

  AppBar BazardAppBar(BuildContext context, {required List<Widget> tabs}) {
    return AppBar(
      backgroundColor: PRIMARY,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: WHITE,
          height: 80,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                width: MediaQuery.of(context).size.width,
                color: GREY,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CustomHourCountdown()],
                ),
              ),
              Scrollbar(
                child: TabBar(
                  isScrollable: true,
                  tabs: tabs,
                  tabAlignment: TabAlignment.start,
                ),
              ),
            ],
          ),
        ),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: HeroIcon(HeroIcons.chevronLeft, color: WHITE, size: 25),
      ),
      title: customText(
        'Bazard Rapide',
        style: TextStyle(
          color: WHITE,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: WHITE,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              HeroIcon(HeroIcons.plus, size: 12, color: PRIMARY),
              espacementWidget(width: 5),
              customText(
                "Je m'abonne",
                style: TextStyle(fontSize: 11, color: PRIMARY),
              ),
            ],
          ),
        ),
        espacementWidget(width: 20),
        MyCartWidget(size: 25, color: WHITE),
        espacementWidget(width: 10),
      ],
    );
  }
}

// Bazard Item
class BazardHomeItem extends StatefulWidget {
  const BazardHomeItem({super.key, required this.main_categorie_id});
  final String main_categorie_id;
  @override
  State<BazardHomeItem> createState() => _BazardHomeItemState();
}

class _BazardHomeItemState extends State<BazardHomeItem> {
  final List<ProduitModel> bazardProduits = <ProduitModel>[];
  getProduitOfMainCategorie() async {
    var produits = await ApiServices().getProduitOfMainCategorie(
      widget.main_categorie_id,
    );

    produits.forEach((produit) {
      setState(() {
        if (produit['pourcentage_reduction'] >= 10) {
          bazardProduits.add(
            ProduitModel(
              nom: produit['nom'],
              url_image: produit['url_image'],
              status: produit['status'],
              description: produit['description'],
              est_en_promo: produit['est_en_promo'],
              taux_reduction: (produit['taux_reduction'] as num?)?.toDouble(),
              prix_promo: (produit['prix_promo'] as num?)?.toDouble(),
              prix_minimum: (produit['prix_minimum'] as num?)?.toDouble(),
              cree_le: produit['cree_le'],
              date_fin: produit['date_fin'],
              fournisseur_id: produit['fournisseur_id'].toString(),
              nom_fournisseur: produit['nom_fournisseur'],
              produit_id: produit['produit_id'].toString(),
            ),
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getProduitOfMainCategorie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      body: SingleChildScrollView(
        child: Column(
          children: [
            espacementWidget(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                children: [
                  for (var i = 0; i < bazardProduits.length; i++)
                    BazardRapidItem(
                      context,
                      reduction: true,
                      produit: bazardProduits[i],
                      margin: 2,
                    ),
                ],
              ),
            ),
            noMoreProduit(),
          ],
        ),
      ),
    );
  }
}

// Tout produit
class BazardToutProduit extends StatefulWidget {
  const BazardToutProduit({super.key});

  @override
  State<BazardToutProduit> createState() => _BazardToutProduitState();
}

class _BazardToutProduitState extends State<BazardToutProduit> {
  final List<ProduitModel> bazardProduits = <ProduitModel>[];
  getProduitsBazard() async {
    var produits = await ApiServices().getProduits();

    produits.forEach((produit) {
      setState(() {
        if (produit['pourcentage_reduction'] >= 10) {
          bazardProduits.add(
            ProduitModel(
              nom: produit['nom'],
              url_image: produit['url_image'],
              status: produit['status'],
              description: produit['description'],
              est_en_promo: produit['est_en_promo'],
              taux_reduction: (produit['taux_reduction'] as num?)?.toDouble(),
              prix_promo: (produit['prix_promo'] as num?)?.toDouble(),
              prix_minimum: (produit['prix_minimum'] as num?)?.toDouble(),
              cree_le: produit['cree_le'],
              date_fin: produit['date_fin'],
              fournisseur_id: produit['fournisseur_id'].toString(),
              nom_fournisseur: produit['nom_fournisseur'],
              produit_id: produit['produit_id'].toString(),
            ),
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getProduitsBazard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      body: SingleChildScrollView(
        child: Column(
          children: [
            espacementWidget(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: StaggeredGrid.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                children: [
                  for (var i = 0; i < bazardProduits.length; i++)
                    BazardRapidItem(
                      context,
                      reduction: true,
                      produit: bazardProduits[i],
                      margin: 2,
                    ),
                ],
              ),
            ),
            noMoreProduit(),
          ],
        ),
      ),
    );
  }
}
