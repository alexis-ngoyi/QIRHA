// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:qirha/api/services.dart';

import 'package:qirha/main/categorie/sous_categorie.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/empty/no_categories.dart';

class TabCategorieScreen extends StatefulWidget {
  const TabCategorieScreen({super.key});

  @override
  State<TabCategorieScreen> createState() => _TabCategorieScreenState();
}

class _TabCategorieScreenState extends State<TabCategorieScreen> {
  late int _currentMainCategorieIndexPage;
  bool? isLoading;

  final List<MainCategorieModel> main_categories = <MainCategorieModel>[];

  getMainCategorie() async {
    setState(() {
      isLoading = true;
    });
    var main_categorie = await ApiServices().getMainCategorie();

    print(main_categorie);
    main_categorie.forEach((main) {
      setState(() {
        main_categories.add(
          MainCategorieModel(
            main_categorie_id: main['main_categorie_id'].toString(),
            nom_main_categorie: main['nom_main_categorie'],
          ),
        );
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _currentMainCategorieIndexPage = 0;
    getMainCategorie();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      body: IconTheme(
        data: const IconThemeData(color: Colors.black),
        child: Column(
          children: [
            espacementWidget(height: 30),
            customAppSearchBar(context),
            (isLoading == false)
                ? (main_categories.isNotEmpty)
                      ? Expanded(
                          child: Row(
                            children: [
                              // LEFT SIDE
                              Container(
                                width: 100,
                                height: MediaQuery.of(context).size.height,
                                color: GREY,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      for (
                                        var i = 0;
                                        i < main_categories.length;
                                        i++
                                      )
                                        GestureDetector(
                                          onTap: () => setState(
                                            () =>
                                                _currentMainCategorieIndexPage =
                                                    i,
                                          ),
                                          child: Container(
                                            color:
                                                _currentMainCategorieIndexPage ==
                                                    i
                                                ? WHITE
                                                : GREY,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 10,
                                            ),
                                            width: double.infinity,
                                            child: customCenterText(
                                              main_categories[i]
                                                      .nom_main_categorie
                                                  as String,
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color:
                                                    _currentMainCategorieIndexPage ==
                                                        i
                                                    ? PRIMARY
                                                    : DARK,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              // MAIN CONTENT
                              if (main_categories.isNotEmpty)
                                Expanded(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Container(
                                      decoration: BoxDecoration(color: WHITE),
                                      child: SousCategorieSection(
                                        main_categorie:
                                            main_categories[_currentMainCategorieIndexPage],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : const Center(child: NoCategorieWidget())
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
