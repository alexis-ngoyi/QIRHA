import 'package:flutter/material.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class MyComboCouleurWidget extends StatefulWidget {
  const MyComboCouleurWidget({
    super.key,
    required this.onSelectedCouleurList,
    required this.allCouleurs,
    required this.defaultItems,
  });
  final Function(List<ProduitCouleurModel> listTaille) onSelectedCouleurList;
  final List<ProduitCouleurModel> allCouleurs;
  final List<ProduitCouleurModel> defaultItems;

  @override
  State<MyComboCouleurWidget> createState() => _MyComboCouleurWidgetState();
}

class _MyComboCouleurWidgetState extends State<MyComboCouleurWidget> {
  late List<ProduitCouleurModel> currentCouleurItems = widget.defaultItems;

  @override
  void didUpdateWidget(covariant MyComboCouleurWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currentCouleurItems = widget.defaultItems;
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
              for (var index = 0; index < widget.allCouleurs.length; index++)
                GestureDetector(
                  onTap: () {
                    // supprime si existe deja
                    if (currentCouleurItems.contains(
                      widget.allCouleurs[index],
                    )) {
                      setState(() {
                        currentCouleurItems.remove(widget.allCouleurs[index]);
                        widget.onSelectedCouleurList.call(currentCouleurItems);
                      });
                    }
                    // Ajoute si nouveau
                    else {
                      setState(() {
                        currentCouleurItems.add(widget.allCouleurs[index]);
                        widget.onSelectedCouleurList.call(currentCouleurItems);
                      });
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(6),
                    //width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        width: 1,
                        color:
                            currentCouleurItems.contains(
                              widget.allCouleurs[index],
                            )
                            ? PRIMARY
                            : Colors.black.withOpacity(.1),
                      ),
                    ),
                    child: customCenterText(
                      widget.allCouleurs[index].nom_couleur as String,
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
