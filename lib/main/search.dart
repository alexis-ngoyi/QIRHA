import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/widgets/suggestion_produit.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  late bool _isTypingKeyWord = false;
  late TextEditingController _isTypingKeyWordController =
      TextEditingController();

  // EDITING IN SEARCH KEY
  void _isEditingWord() {
    // check if editing
    setState(() {
      _isTypingKeyWord = _isTypingKeyWordController.text.toString().isNotEmpty
          ? true
          : false;
    });
  }

  // CLEAR SEARCH BAR
  void _clearSearchInput() {
    _isTypingKeyWordController.clear();
    setState(() {
      _isTypingKeyWord = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _isTypingKeyWord = false;
    _isTypingKeyWordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GREY,
      body: IconTheme(
        data: const IconThemeData(color: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpacerHeight(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const HeroIcon(HeroIcons.chevronLeft, size: 25),
                  ),
                  espacementWidget(width: 15),
                  _searchBarInput(),
                  espacementWidget(width: 10),
                ],
              ),
            ),
            espacementWidget(height: 15),
            Expanded(
              child: Container(
                color: GREY,
                child: Column(
                  children: [
                    espacementWidget(height: 10),
                    !_isTypingKeyWord
                        ? Expanded(
                            child: SingleChildScrollView(
                              child: _placeholderSearchHistory(),
                            ),
                          )
                        : _searchResultKeyPreview(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _searchResultKeyPreview() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              child: customText(
                'Categorie',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            _ListTileSearchItem(
              text: 'Pommeau de douche > Tetes de douche',
              press: () => {},
            ),
            _ListTileSearchItem(
              text: 'Pommeau de douche > Pommes de douche',
              press: () => {},
            ),
            _ListTileSearchItem(
              text: 'Pommeau de douche > Systeme de douche',
              press: () => {},
            ),
            Container(color: GREY, height: 10),
            espacementWidget(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              child: customText(
                'Similaire',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            _ListTileSearchItem(text: 'Pompier', press: () => {}),
            _ListTileSearchItem(text: 'Pompon', press: () => {}),
            _ListTileSearchItem(text: 'Pomme', press: () => {}),
            _ListTileSearchItem(text: 'Pompe', press: () => {}),
            _ListTileSearchItem(text: 'Coupe Pomme', press: () => {}),
            _ListTileSearchItem(text: 'Pompe', press: () => {}),
            _ListTileSearchItem(text: 'Pom Pom girl', press: () => {}),
            _ListTileSearchItem(text: 'Pommade', press: () => {}),
            _ListTileSearchItem(text: 'Bonnet Pompon', press: () => {}),
          ],
        ),
      ),
    );
  }

  GestureDetector _ListTileSearchItem({String text = '', Function()? press}) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            title: customText(text, style: const TextStyle(fontSize: 13.5)),
            trailing: const HeroIcon(HeroIcons.arrowUpLeft, size: 15),
          ),
          const Divider(height: 1, thickness: .7),
        ],
      ),
    );
  }

  Column _placeholderSearchHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(
                'Derniere recherche',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const HeroIcon(HeroIcons.trash, size: 17),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
          child: Wrap(
            spacing: 8,
            children: [
              _tagSearchItem(text: 'Pantalon', press: () => {}),
              _tagSearchItem(text: 'Chemise', press: () => {}),
              _tagSearchItem(text: 'Iphone', press: () => {}),
            ],
          ),
        ),
        espacementWidget(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customText(
                'Ce que les autres cherchent',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6),
          child: Wrap(
            spacing: 8,
            children: [
              _tagSearchItem(text: 'Jean', press: () => {}),
              _tagSearchItem(text: 'Pijama', press: () => {}),
              _tagSearchItem(text: 'Coussin', press: () => {}),
              _tagSearchItem(text: 'Bottine', press: () => {}),
              _tagSearchItem(text: 'Rideau', press: () => {}),
              _tagSearchItem(text: 'Ordinateur', press: () => {}),
              _tagSearchItem(text: 'Ecran', press: () => {}),
              _tagSearchItem(text: 'Robe', press: () => {}),
            ],
          ),
        ),
        espacementWidget(height: 30),
        const SuggestionProduitWidget(),
      ],
    );
  }

  GestureDetector _tagSearchItem({String text = '', Function()? press}) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3.5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: WHITE,
          borderRadius: BorderRadius.circular(5),
        ),
        child: customText(text, style: const TextStyle(fontSize: 13)),
      ),
    );
  }

  Flexible _searchBarInput() {
    return Flexible(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 43,
          decoration: BoxDecoration(color: WHITE),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: TextField(
                    onChanged: (val) {
                      _isEditingWord();
                    },
                    controller: _isTypingKeyWordController,
                    style: TextStyle(
                      color: DARK,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: DARK,
                        fontWeight: FontWeight.normal,
                      ),
                      fillColor: Colors.transparent,
                      hintText: 'Pantalon pour homme',
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  _isTypingKeyWord
                      ? GestureDetector(
                          onTap: _clearSearchInput,
                          child: const SizedBox(
                            width: 50,
                            height: 45,
                            child: Center(
                              child: HeroIcon(HeroIcons.xCircle, size: 20),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => checkPermissionAndOpenCanera(context),
                          child: const SizedBox(
                            width: 50,
                            height: 45,
                            child: Center(
                              child: HeroIcon(HeroIcons.camera, size: 20),
                            ),
                          ),
                        ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 50,
                      height: 45,
                      decoration: BoxDecoration(color: PRIMARY),
                      child: HeroIcon(
                        HeroIcons.magnifyingGlass,
                        size: 20,
                        color: WHITE,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
