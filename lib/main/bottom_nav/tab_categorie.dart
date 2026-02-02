// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/main/produits/produit_par_categorie.dart';
import 'package:qirha/main/produits/produit_par_groupe.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/constantes.dart';
import 'package:qirha/res/images.dart';
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
            (main_categories.isNotEmpty)
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
                                for (var i = 0; i < main_categories.length; i++)
                                  GestureDetector(
                                    onTap: () => setState(
                                      () => _currentMainCategorieIndexPage = i,
                                    ),
                                    child: Container(
                                      color: _currentMainCategorieIndexPage == i
                                          ? WHITE
                                          : GREY,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 10,
                                      ),
                                      width: double.infinity,
                                      child: customCenterText(
                                        main_categories[i].nom_main_categorie
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
                : const Center(child: NoCategorieWidget()),
          ],
        ),
      ),
    );
  }
}

class SousCategorieSection extends StatefulWidget {
  const SousCategorieSection({super.key, required this.main_categorie});
  final MainCategorieModel main_categorie;

  @override
  State<SousCategorieSection> createState() => _SousCategorieSectionState();
}

class _SousCategorieSectionState extends State<SousCategorieSection> {
  List<GroupeCategorieModel> categorieGroupes = <GroupeCategorieModel>[];
  late String main_categorie_id = widget.main_categorie.main_categorie_id
      .toString();

  getMainCategorieGroupes(String id) async {
    // Reset
    setState(() {
      categorieGroupes = [];
    });

    var groupes = await ApiServices().getMainCategorieGroupes(id);

    groupes.forEach((groupe) async {
      var groupe_id = groupe['groupe_id'];
      List<CategorieModel> categoriesList = [];

      var categories = await ApiServices().getCategoriesOfGroupe(
        groupe_id.toString(),
      );

      categories.forEach((categorie) {
        categoriesList.add(
          CategorieModel(
            libelle: categorie['nom_categorie'],
            categorie_id: categorie['categorie_id'].toString(),
            img: categorie['image_categorie'],
          ),
        );
      });

      setState(() {
        categorieGroupes.add(
          GroupeCategorieModel(
            id: groupe['groupe_id'].toString(),
            groupe: groupe['nom_groupe'],
            categorie: categoriesList,
          ),
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getMainCategorieGroupes(main_categorie_id);
  }

  @override
  void didUpdateWidget(covariant SousCategorieSection oldScreen) {
    if (widget.main_categorie.main_categorie_id !=
        oldScreen.main_categorie.main_categorie_id) {
      // print('Parameter changed to: ${widget.main_categorie.main_categorie_id}');
    }
    super.didUpdateWidget(oldScreen);

    getMainCategorieGroupes(widget.main_categorie.main_categorie_id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: boxGroupeCategorie(context, groupe: categorieGroupes),
    );
  }

  Column boxGroupeCategorie(
    BuildContext context, {
    required List<GroupeCategorieModel> groupe,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < groupe.length; i++)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customCenterTitle(title: groupe[i].groupe as String),
              Wrap(
                alignment: WrapAlignment.start,
                children: [
                  customCardCategorie(
                    image: demoPic,
                    title: 'Tout',
                    press: () => {
                      CustomPageRoute(
                        ProduitParGroupe(
                          groupe: groupe[i],
                          typeView: 'DEFAULT',
                        ),
                        context,
                      ),
                    },
                  ),
                  for (var j = 0; j < groupe[i].categorie!.length; j++)
                    customCardCategorie(
                      image: demoPic,
                      title: groupe[i].categorie![j].libelle as String,
                      press: () => CustomPageRoute(
                        ProduitParCategorie(
                          typeView: 'DEFAULT',
                          categorie: groupe[i].categorie![j],
                        ),
                        context,
                      ),
                    ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
