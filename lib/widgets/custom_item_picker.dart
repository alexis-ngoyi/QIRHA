import 'package:flutter/material.dart';
import 'package:qirha/model/filter_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CustomItemPicker extends StatefulWidget {
  const CustomItemPicker({
    super.key,
    required this.selectedItems,
    required this.selectedTab,
  });
  final void Function(FilterModel selectedItems) selectedItems;
  final FilterModel selectedTab;

  @override
  State<CustomItemPicker> createState() => _CustomItemPickerState();
}

class _CustomItemPickerState extends State<CustomItemPicker> {
  late List<FilterModel> currentItems = [];

  final List<FilterModel> itemList = [
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
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Wrap(
        children: [
          for (var index = 0; index < itemList.length; index++)
            GestureDetector(
              onTap: () {
                setState(() {
                  currentItems.add(itemList[index]);
                  widget.selectedItems.call(itemList[index]);
                });
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 1,
                    color: currentItems.contains(itemList[index])
                        ? PRIMARY
                        : Colors.black.withOpacity(.1),
                  ),
                ),
                child: customText(
                  itemList[index].label as String,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
