import 'package:flutter/material.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';

class SelectableContainerLivraison extends StatefulWidget {
  const SelectableContainerLivraison({super.key, required this.onSelect});

  final void Function(
    (String img, String label, String prix, int value) selected,
  )
  onSelect;

  @override
  State<SelectableContainerLivraison> createState() =>
      _SelectableContainerLivraisonState();
}

class _SelectableContainerLivraisonState
    extends State<SelectableContainerLivraison> {
  (String img, String label, String prix, int value) selectedValue = (
    homme_marchant,
    "Je n'accepte pas la livraison",
    '0',
    1,
  );

  List<(String img, String label, String prix, int value)> livraisonsList =
      <(String img, String label, String prix, int value)>[
        (homme_marchant, "Je n'accepte pas la livraison", '0', 1),
        (livraison_a_domicile, 'Livraison a domicile', '1000', 2),
        (expedition_exterieur, 'Expedition hors Brazzaville', '3000', 3),
      ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < livraisonsList.length; i++)
          GestureDetector(
            onTap: () => {
              setState(() {
                selectedValue = livraisonsList[i];
                widget.onSelect.call(livraisonsList[i]);
              }),
            },
            child: Stack(
              children: [
                Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width / 3 - 12,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: WHITE,
                    border: Border.all(
                      width: 1,
                      color: selectedValue == livraisonsList[i]
                          ? PRIMARY
                          : WHITE,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                livraisonsList[i].$1,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              espacementWidget(height: 80),
                              customCenterText(
                                livraisonsList[i].$2,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: DARK, fontSize: 11),
                              ),
                              customCenterText(
                                "A partir de",
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: LIGHT, fontSize: 10),
                              ),
                              espacementWidget(height: 3),
                              customCenterText(
                                "${livraisonsList[i].$3} XAF",
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: PRIMARY,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: selectedValue == livraisonsList[i]
                          ? PRIMARY
                          : GREY,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(Icons.check, size: 11, color: WHITE),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
