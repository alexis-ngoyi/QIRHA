// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/main/commandes/commande_tabview.dart';
import 'package:qirha/main/commandes/toutes.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/need_to_login.dart';

class TabMesCommandesScreen extends StatefulWidget {
  const TabMesCommandesScreen({
    super.key,
    required this.initialIndex,
    required this.canReturn,
  });
  final bool canReturn;
  final int initialIndex;

  @override
  State<TabMesCommandesScreen> createState() => _TabMesCommandesScreenState();
}

class _TabMesCommandesScreenState extends State<TabMesCommandesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> tabViews = const <Widget>[
    MesCommandesTabTout(),
    CommandeTabView(status: "3"), // EN ATTENTE
    CommandeTabView(status: "1"), //  PAYE
    CommandeTabView(status: "2"), // Annule
  ];

  final List<Tab> tabs = <Tab>[
    const Tab(text: 'Toutes'),
    const Tab(text: 'En Attente'),
    const Tab(text: 'Payée'),
    const Tab(text: 'Annulée'),
  ];

  late String? utilisateur_id;
  bool? needToLogin;
  late Timer main_timer;
  authGuard() {
    // Define the interval duration in milliseconds
    const intervalDuration = Duration(seconds: 1);

    // Set up a periodic timer
    main_timer = Timer.periodic(intervalDuration, (timer) async {
      if (utilisateur_id == null) {
        setState(() {
          needToLogin = true;
        });
      } else {
        setState(() {
          needToLogin = false;
        });
      }
      timer.cancel();
    });
  }

  @override
  void initState() {
    super.initState();
    utilisateur_id = prefs.getString('utilisateur_id');
    authGuard();
    _tabController = TabController(
      initialIndex: widget.initialIndex,
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    main_timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _tabController.animateTo(widget.initialIndex),
    );
    return needToLogin == false
        ? DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              backgroundColor: GREY,
              appBar: MesCommandesAppBar(
                context,
                canReturn: widget.canReturn,
                tabs: tabs,
                controller: _tabController,
              ),
              body: IconTheme(
                data: const IconThemeData(color: Colors.black),
                child: TabBarView(
                  controller: _tabController,
                  children: tabViews,
                ),
              ),
            ),
          )
        : Scaffold(body: NeedToLogin());
  }
}
