import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/main/messagerie/discussions.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class MessagerieScreen extends StatefulWidget {
  const MessagerieScreen({super.key});

  @override
  State<MessagerieScreen> createState() => _MessagerieScreenState();
}

class _MessagerieScreenState extends State<MessagerieScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: tabs.length,
    vsync: this,
  );
  final List<Widget> tabs = const <Widget>[
    HeroIcon(HeroIcons.envelope),
    HeroIcon(HeroIcons.bell),
    HeroIcon(HeroIcons.users),
    HeroIcon(HeroIcons.phone),
  ];

  final List<Widget> tabViews = const <Widget>[
    MessagerieDiscussions(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WHITE,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            color: WHITE,
            height: 40,
            child: Scrollbar(
              child: TabBar(tabs: tabs, controller: _tabController),
            ),
          ),
        ),
        title: customText(
          'Messagerie',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          MyCartWidget(size: 25, color: DARK),
          espacementWidget(width: 20),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const HeroIcon(HeroIcons.arrowRightOnRectangle, size: 25),
          ),
          espacementWidget(width: 14),
        ],
      ),
      body: TabBarView(controller: _tabController, children: tabViews),
    );
  }
}
