import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/model/model_produit_couleur.dart';
import 'package:qirha/model/taille_produit_model.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/combo/combo_couleur_widget.dart';
import 'package:qirha/widgets/combo/combo_taille_widget.dart';
import 'package:qirha/widgets/combo/custom_button.dart';

class MyOverlayWidget extends StatefulWidget {
  final String text;

  final int type;
  final List<TailleProduitModel> tailles;
  final List<ProduitCouleurModel> couleurs;
  final List<TailleProduitModel> defaultTailles;
  final List<ProduitCouleurModel> defaultCouleurs;
  final Function(TailleProduitModel item) onSelectedTailles;
  final Function(ProduitCouleurModel item) onSelectedCouleurs;
  final double top;

  const MyOverlayWidget({
    super.key,
    required this.text,
    required this.type,
    this.tailles = const [],
    this.couleurs = const [],
    this.defaultTailles = const [],
    this.defaultCouleurs = const [],
    required this.onSelectedTailles,
    required this.onSelectedCouleurs,
    this.top = 240.0,
  });
  @override
  _MyOverlayWidgetState createState() => _MyOverlayWidgetState();
}

class _MyOverlayWidgetState extends State<MyOverlayWidget> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = createOverlayEntry();
  }

  @override
  void dispose() {
    closeOverlay();
    super.dispose();
  }

  openOverlay() {
    Overlay.of(context).insert(_overlayEntry!);
  }

  closeOverlay() {
    _overlayEntry?.remove();
  }

  OverlayEntry createOverlayEntry() {
    // Create your overlay widget here
    return OverlayEntry(
      builder: (context) => Positioned(
        top: widget.top,
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: 200.0,
          color: Colors.white,
          child: Column(
            children: [
              if (widget.type == 1)
                MyComboTailleWidget(
                  allTailles: widget.tailles,
                  defaultItems: widget.defaultTailles,
                  onSelectedTailleList: (List<TailleProduitModel> listTaille) {
                    print(listTaille);
                  },
                ),
              if (widget.type == 2)
                MyComboCouleurWidget(
                  allCouleurs: widget.couleurs,
                  defaultItems: widget.defaultCouleurs,
                  onSelectedCouleurList:
                      (List<ProduitCouleurModel> listCouleurs) {
                        print(listCouleurs);
                      },
                ),
              MyButtonWidget(
                onPressed: closeOverlay,
                label: 'Fermer',
                bgColor: DANGER,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                labelColor: WHITE,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Main widget build method
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: openOverlay,
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
                        HeroIcons.chevronDown,
                        size: 25,
                        color: PRIMARY,
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
}
