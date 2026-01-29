import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/functions/format_color.dart';
import 'package:qirha/model/model_produit_couleur.dart';
import 'package:qirha/model/taille_produit_model.dart';
import 'package:qirha/model/type_produit_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/overlay_widget.dart';

class MyFiltreItemWidget extends StatefulWidget {
  const MyFiltreItemWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.arrayList,
    required this.onSelectedItem,
    required this.typeItem,
    // required this.onTap
  });
  final String text;
  final HeroIcons icon;
  final Color color;
  final List<dynamic> arrayList;
  final Function(dynamic selectedItem) onSelectedItem;
  final int typeItem;

  @override
  State<MyFiltreItemWidget> createState() => _MyFiltreItemWidgetState();
}

class _MyFiltreItemWidgetState extends State<MyFiltreItemWidget> {
  List<TailleProduitModel> currentTailleItems = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () {
          // [Type produit]
          if (widget.typeItem == 1) {
            popTypeProduit(context, array: widget.arrayList);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 35,
            decoration: BoxDecoration(color: WHITE),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    customText(
                      widget.text,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: DARK, fontSize: 13),
                    ),
                    espacementWidget(width: 10),
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: GREY,
                      ),
                      child: HeroIcon(
                        widget.icon,
                        size: 25,
                        color: widget.color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future popTypeProduit(BuildContext context, {required List<dynamic> array}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: .4,
          minChildSize: .1,
          maxChildSize: .4,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 5, color: GREY)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              child: ListView.builder(
                controller: scrollController,
                itemCount: array.length,
                itemBuilder: (BuildContext context, int index) {
                  return customlistTile(
                    title: array[index].title,
                    subtitle: array[index].subtitle,
                    press: () => {
                      widget.onSelectedItem.call(array[index]),
                      Navigator.pop(context),
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================================
// ============================================================================
// ================================ MAIN FILTER ===============================
// ============================================================================
// ============================================================================

class MyFilterWidget extends StatefulWidget {
  const MyFilterWidget({super.key, this.top = 240});
  final double top;

  @override
  State<MyFilterWidget> createState() => _MyFilterWidgetState();
}

class _MyFilterWidgetState extends State<MyFilterWidget> {
  // Selected Taille item

  List<TailleProduitModel> selectedTailleItem = [];

  List<TailleProduitModel> allTailles = <TailleProduitModel>[];

  getAllTailles() async {
    setState(() {
      allTailles = [];
    });

    var tailles = [];

    tailles.forEach((taille) {
      setState(() {
        allTailles.add(
          TailleProduitModel(
            code_taille: taille['code_taille'],
            nom_taille: taille['nom_taille'],
            taille_id: taille['taille_id'],
          ),
        );
      });
    });
  }

  // Selected Couleur item

  List<ProduitCouleurModel> selectedCouleurItem = [];

  List<ProduitCouleurModel> allCouleurs = <ProduitCouleurModel>[];

  getAllCouleurs() async {
    setState(() {
      allCouleurs = [];
    });

    var couleurs = [];
    couleurs.forEach((couleur) {
      setState(() {
        allCouleurs.add(
          ProduitCouleurModel(
            code_couleur: formatColor(couleur['code_couleur']),
            nom_couleur: couleur['nom_couleur'],
            couleur_id: couleur['couleur_id'].toString(),
          ),
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();

    // Load filters
    getAllCouleurs();
    getAllTailles();
  }

  @override
  Widget build(BuildContext context) {
    return produitFilters(context);
  }

  SingleChildScrollView produitFilters(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // [Type produit]
          MyFiltreItemWidget(
            typeItem: 1, //[ Type produit]
            color: PRIMARY,
            text: 'Type',
            arrayList: <TypeProduit>[
              TypeProduit(
                title: 'Recommander',
                subtitle: 'Produit recommander par qirha ',
              ),
              TypeProduit(
                title: 'Les plus vendu',
                subtitle: 'Produit les plus dans les derniers 30jrs',
              ),
              TypeProduit(
                title: 'Les plus populaires',
                subtitle: 'Produit les plus demandes dans les derniers 30jrs ',
              ),
              TypeProduit(
                title: 'En reduction',
                subtitle: "Produit en reduction jusqu'a -30% ",
              ),
            ],
            onSelectedItem: (selectedItem) => {print(selectedItem)},
            icon: HeroIcons.chevronDown,
          ),

          // [ Type Taille]
          MyOverlayWidget(
            top: widget.top,
            onSelectedTailles: (TailleProduitModel item) {
              selectedTailleItem.add(item);
            },
            onSelectedCouleurs: (item) {},
            defaultCouleurs: [],
            defaultTailles: selectedTailleItem,
            text: 'Taille',
            type: 1,
            tailles: allTailles,
            couleurs: [],
          ),

          // [ Type Couleur]
          MyOverlayWidget(
            top: widget.top,
            onSelectedTailles: (item) {},
            onSelectedCouleurs: (ProduitCouleurModel item) {
              selectedCouleurItem.add(item);
            },
            defaultCouleurs: selectedCouleurItem,
            defaultTailles: [],
            text: 'Couleur',
            type: 2,
            tailles: [],
            couleurs: allCouleurs,
          ),

          // boxFiltreItem(
          //     color: PRIMARY,
          //     text: 'Filtre',
          //     icon: HeroIcons.adjustmentsVertical,
          //     onTap: () {
          //       triggerDynamicCustomModal(context,
          //           opacity: .3,
          //           top: 0,
          //           offset: const Offset(1, 0),
          //           fullscreen: false, view: AdvancedFilter(
          //         selectedFilter: (List<FilterModelGroup> selectedItems) {
          //           // print(selectedItems.length);
          //         },
          //       ));
          //     }),
        ],
      ),
    );
  }

  boxFiltreItem({
    required String text,
    required HeroIcons icon,
    required Color color,
    required Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 35,
            decoration: BoxDecoration(color: WHITE),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    customText(
                      text,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: DARK, fontSize: 13),
                    ),
                    espacementWidget(width: 10),
                    Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: GREY,
                      ),
                      child: HeroIcon(icon, size: 25, color: color),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
