import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/widgets/custom_item_picker.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class AdvancedFilter extends StatefulWidget {
  const AdvancedFilter({super.key, required this.selectedFilter});
  final void Function(List<FilterModelGroup> selectedItems) selectedFilter;

  @override
  State<AdvancedFilter> createState() => _AdvancedFilterState();
}

class _AdvancedFilterState extends State<AdvancedFilter> {
  List<FilterModelGroup> selectedfilterTabList = [];

  final List<FilterModel> filterTabList = <FilterModel>[
    FilterModel(id: 0, label: 'Type'),
    FilterModel(id: 1, label: 'Categorie'),
    FilterModel(id: 2, label: 'Prix'),
    FilterModel(id: 3, label: 'Taille'),
    FilterModel(id: 4, label: 'Couleur'),
    FilterModel(id: 5, label: 'Style'),
    FilterModel(id: 6, label: 'Col'),
    FilterModel(id: 7, label: 'Genre'),
    FilterModel(id: 8, label: 'Reduction'),
    FilterModel(id: 9, label: 'Marque'),
    FilterModel(id: 10, label: 'Motif'),
  ];

  late FilterModel _currentFiltreTab = filterTabList[0];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return myScaffold(context);
  }

  Scaffold myScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: WHITE,
      body: Column(
        children: [
          espacementWidget(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => {Navigator.pop(context)},
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    child: HeroIcon(HeroIcons.xMark, size: 20),
                  ),
                ),
                customText(
                  'FILTRE',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: DARK,
                  ),
                ),
                espacementWidget(width: 20),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: GREY),
          Expanded(
            child: Row(children: [leftSide(context), mainSide(context)]),
          ),
          Divider(height: 1, thickness: 1, color: GREY),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: GREY),
                  ),
                  child: customText(
                    'EFFACER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: DARK,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  color: PRIMARY,
                  padding: const EdgeInsets.all(6),
                  child: customText(
                    'VALIDER',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: WHITE,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded mainSide(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: CustomItemPicker(
            selectedTab: _currentFiltreTab,
            selectedItems: (FilterModel selectedItems) {
              selectedfilterTabList.add(
                FilterModelGroup(list: [_currentFiltreTab, _currentFiltreTab]),
              );
              widget.selectedFilter.call(selectedfilterTabList);
            },
          ),
        ),
      ),
    );
  }

  Container leftSide(BuildContext context) {
    return Container(
      width: 90,
      height: MediaQuery.of(context).size.height,
      color: GREY,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var i = 0; i < filterTabList.length; i++)
              GestureDetector(
                onTap: () => setState(() {
                  _currentFiltreTab = filterTabList[i];
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: _currentFiltreTab.id == i ? WHITE : GREY,
                  ),
                  width: double.infinity,
                  child: Center(
                    child: customText(
                      filterTabList[i].label as String,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: _currentFiltreTab.id == i ? PRIMARY : DARK,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
