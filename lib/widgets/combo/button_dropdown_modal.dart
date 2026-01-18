import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class MyButtonDropdownModalWidget extends StatefulWidget {
  const MyButtonDropdownModalWidget(
      {super.key,
      required this.text,
      required this.icon,
      required this.color,
      required this.onTap});
  final String text;
  final Color color;
  final HeroIcons icon;
  final Function() onTap;

  @override
  State<MyButtonDropdownModalWidget> createState() =>
      _MyButtonDropdownModalWidgetState();
}

class _MyButtonDropdownModalWidgetState
    extends State<MyButtonDropdownModalWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 35,
              decoration: BoxDecoration(color: WHITE),
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Row(
                    children: [
                      customText(
                        widget.text,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: DARK, fontSize: 13),
                      ),
                      espacementWidget(
                        width: 10,
                      ),
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
      ],
    );
  }
}
