import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class TextInputWidget extends StatefulWidget {
  const TextInputWidget({
    super.key,
    required this.controller,
    required this.formKey,
    required this.labelText,
    this.isPassword = false,
    required this.keyboardType,
    required this.maxLines,
  });
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final String labelText;
  final bool isPassword;
  final TextInputType keyboardType;
  final int maxLines;

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  bool raiseError = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        //   child: customText(widget.labelText,
        //       style: TextStyle(
        //           fontSize: 13, color: DARK, fontWeight: FontWeight.bold)),
        // ),
        Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 4,
            bottom: 5,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: WHITE,
            border: raiseError == false
                ? Border.all(width: 1, color: GREY)
                : Border.all(width: 1, color: DANGER),
          ),
          child: TextFormField(
            autocorrect: true,
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            style: const TextStyle(fontSize: 13),
            controller: widget.controller,
            obscureText: widget.isPassword,
            decoration: InputDecoration(
              hintText: widget.labelText,
              border: InputBorder.none,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              errorStyle: const TextStyle(fontSize: 11),
              labelText: null,
              labelStyle: const TextStyle(fontSize: 18),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                setState(() {
                  raiseError = true;
                });
                return 'Obligatoire';
              }
              setState(() {
                raiseError = false;
              });
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class InputDropdownWidget extends StatefulWidget {
  const InputDropdownWidget({
    super.key,
    required this.getSelectedItem,
    required this.labelText,
    required this.placeholder,
    required this.typeQuestion,
    required this.raiseError,
  });
  final Function(String selectedItem) getSelectedItem;
  final String labelText;
  final String placeholder;
  final List<String> typeQuestion;
  final bool raiseError;

  @override
  State<InputDropdownWidget> createState() => _InputDropdownWidgetState();
}

class _InputDropdownWidgetState extends State<InputDropdownWidget> {
  String selectedItem = '';
  bool raiseError = false;

  @override
  void didUpdateWidget(covariant InputDropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      raiseError = widget.raiseError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
          child: customText(
            widget.labelText,
            style: TextStyle(
              fontSize: 13,
              color: DARK,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return DraggableScrollableSheet(
                  initialChildSize: .3,
                  minChildSize: .3,
                  maxChildSize: .3,
                  expand: false,
                  builder:
                      (
                        BuildContext context,
                        ScrollController scrollController,
                      ) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: widget.typeQuestion.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    selectedItem = widget.typeQuestion[index];
                                  });
                                  widget.getSelectedItem.call(
                                    widget.typeQuestion[index],
                                  );
                                  Navigator.of(context).pop();
                                },
                                trailing: HeroIcon(
                                  HeroIcons.arrowUpOnSquare,
                                  color: PRIMARY,
                                  size: 17,
                                ),
                                title: customText(
                                  widget.typeQuestion[index],
                                  style: TextStyle(fontSize: 15, color: DARK),
                                ),
                                subtitle: customText(
                                  widget.typeQuestion[index],
                                  style: TextStyle(fontSize: 12, color: LIGHT),
                                ),
                              );
                            },
                          ),
                        );
                      },
                );
              },
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: WHITE,
              borderRadius: BorderRadius.circular(4),
              border: raiseError == false
                  ? null
                  : Border.all(width: 1, color: DANGER),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                selectedItem.isNotEmpty
                    ? customText(
                        selectedItem,
                        style: const TextStyle(fontSize: 13),
                      )
                    : customText(
                        widget.placeholder,
                        style: TextStyle(fontSize: 12, color: LIGHT),
                      ),
                HeroIcon(HeroIcons.chevronRight, color: LIGHT, size: 17),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
