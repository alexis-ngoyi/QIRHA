// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:qirha/api/services.dart';

import 'package:qirha/main/categorie/produit_of_categorie_of_groupe.dart';
import 'package:qirha/main/categorie/produit_par_groupe.dart';
import 'package:qirha/model/categorie.dart';
import 'package:qirha/model/main_categorie_model.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class SousCategorieSection extends StatefulWidget {
  const SousCategorieSection({super.key, required this.main_categorie});
  final MainCategorieModel main_categorie;

  @override
  State<SousCategorieSection> createState() => _SousCategorieSectionState();
}

class _SousCategorieSectionState extends State<SousCategorieSection> {
  List<GroupeCategorieModel> categorieGroupes = <GroupeCategorieModel>[];
  late String main_categorie_id =
      widget.main_categorie.main_categorie_id.toString();

  getMainCategorieGroupes(String id) async {
    // Reset
    setState(() {
      categorieGroupes = [];
    });

    var groupes = await ApiServices().getMainCategorieGroupes(id);

    groupes.forEach((groupe) async {
      var groupe_id = groupe['groupe_id'];
      List<CategorieModel> categoriesList = [];

      var categories =
          await ApiServices().getCategoriesOfGroupe(groupe_id.toString());

      categories.forEach((categorie) {
        categoriesList.add(CategorieModel(
            libelle: categorie['nom_categorie'],
            categorie_id: categorie['categorie_id'].toString(),
            img: categorie['image_categorie']));
      });

      setState(() {
        categorieGroupes.add(
          GroupeCategorieModel(
              id: groupe['groupe_id'].toString(),
              groupe: groupe['nom_groupe'],
              categorie: categoriesList),
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
        child: boxGroupeCategorie(context, groupe: categorieGroupes));
  }

  Column boxGroupeCategorie(BuildContext context,
      {required List<GroupeCategorieModel> groupe}) {
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
                      image: categorie_default,
                      title: 'Tout',
                      press: () => {
                            CustomPageRoute(
                                ProduitParGroupe(
                                    groupe: groupe[i], typeView: 'DEFAULT'),
                                context)
                          }),
                  for (var j = 0; j < groupe[i].categorie!.length; j++)
                    customCardCategorie(
                        image: default_image,
                        title: groupe[i].categorie![j].libelle as String,
                        press: () => CustomPageRoute(
                            ProduitOfCategorieOfGroupe(
                                typeView: 'DEFAULT',
                                categorie: groupe[i].categorie![j]),
                            context)),
                ],
              )
            ],
          ),
      ],
    );
  }
}
