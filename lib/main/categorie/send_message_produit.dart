import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/widgets/combo/custom_button.dart';
import 'package:qirha/widgets/input/text_input_widget.dart';
import 'package:qirha/main/search.dart';
import 'package:qirha/model/produit.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key, required this.produit});
  final ProduitModel produit;

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titreQuestionController = TextEditingController();
  TextEditingController contenuQuestionController = TextEditingController();
  String selectedItem = '';
  bool raiseErrorDropdown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WHITE,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: HeroIcon(HeroIcons.chevronLeft, color: DARK),
        ),
        title: customText(
          'Poser votre question',
          style: TextStyle(
            fontSize: 17,
            color: DARK,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => CustomPageRoute(SearchBarScreen(), context),
            child: const HeroIcon(HeroIcons.magnifyingGlass, size: 24),
          ),
          espacementWidget(width: 20),
          MyCartWidget(color: DARK),
          espacementWidget(width: 10),
        ],
      ),
      backgroundColor: GREY,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputDropdownWidget(
                  raiseError: raiseErrorDropdown,
                  labelText: 'Type de question',
                  placeholder: 'Type de question',
                  typeQuestion: const [
                    "Description du produit",
                    "Expedition ou paiement",
                    "Adresse a qirha Team",
                  ],
                  getSelectedItem: (String item) {
                    setState(() {
                      selectedItem = item;
                    });
                  },
                ),
                espacementWidget(height: 10),
                TextInputWidget(
                  maxLines: 1,
                  keyboardType: TextInputType.name,
                  isPassword: false,
                  controller: titreQuestionController,
                  formKey: formKey,
                  labelText: 'Titre',
                ),
                espacementWidget(height: 10),
                TextInputWidget(
                  maxLines: 4,
                  keyboardType: TextInputType.name,
                  isPassword: false,
                  controller: contenuQuestionController,
                  formKey: formKey,
                  labelText: 'Contenu',
                ),
                espacementWidget(height: 30),
                customCenterText(
                  "Pour des question d'ordres technique, veuillez directement ecrire a l'equipe qirha, nous vous repondrons dans un delai maximum 72 heures ",
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withOpacity(.4),
                  ),
                ),
                espacementWidget(height: 15),
                MyButtonWidget(
                  bgColor: PRIMARY,
                  label: 'ENVOYEZ MAINTENANT',
                  labelColor: WHITE,
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        selectedItem.isNotEmpty) {
                      // print('titre: ${titreQuestionController.text}');
                      // print('contenu: ${contenuQuestionController.text}');
                      // print('item: ${selectedItem}');
                    }

                    if (selectedItem.isNotEmpty) {
                      setState(() {
                        raiseErrorDropdown = false;
                      });
                    }

                    if (selectedItem.isEmpty) {
                      setState(() {
                        raiseErrorDropdown = true;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
