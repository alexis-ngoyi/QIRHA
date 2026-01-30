import 'package:flutter/material.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class MyComboTailleWidget extends StatefulWidget {
  const MyComboTailleWidget({
    super.key,
    required this.onSelectedTailleList,
    required this.allTailles,
    required this.defaultItems,
  });
  final Function(List<TailleProduitModel> listTaille) onSelectedTailleList;
  final List<TailleProduitModel> allTailles;
  final List<TailleProduitModel> defaultItems;

  @override
  State<MyComboTailleWidget> createState() => _MyComboTailleWidgetState();
}

class _MyComboTailleWidgetState extends State<MyComboTailleWidget> {
  late List<TailleProduitModel> currentTailleItems = widget.defaultItems;

  @override
  void didUpdateWidget(covariant MyComboTailleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currentTailleItems = widget.defaultItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            children: [
              for (var index = 0; index < widget.allTailles.length; index++)
                GestureDetector(
                  onTap: () {
                    // supprime si existe deja
                    if (currentTailleItems.contains(widget.allTailles[index])) {
                      setState(() {
                        currentTailleItems.remove(widget.allTailles[index]);
                        widget.onSelectedTailleList.call(currentTailleItems);
                      });
                    }
                    // Ajoute si nouveau
                    else {
                      setState(() {
                        currentTailleItems.add(widget.allTailles[index]);
                        widget.onSelectedTailleList.call(currentTailleItems);
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(6),
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        width: 1,
                        color:
                            currentTailleItems.contains(
                              widget.allTailles[index],
                            )
                            ? PRIMARY
                            : Colors.black.withOpacity(.1),
                      ),
                    ),
                    child: customCenterText(
                      widget.allTailles[index].code_taille as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: DARK),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
