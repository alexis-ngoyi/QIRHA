import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CustomTextCollapse extends StatefulWidget {
  const CustomTextCollapse({super.key, required this.label});
  final String label;

  @override
  State<CustomTextCollapse> createState() => _CustomTextCollapseState();
}

class _CustomTextCollapseState extends State<CustomTextCollapse> {
  late int maxLines;

  @override
  void initState() {
    super.initState();
    maxLines = 1;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SizedBox(
              child: customText(widget.label,
                  maxLines: maxLines,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 11, color: DARK)),
            ),
          ),
          if (maxLines == 1)
            GestureDetector(
              onTap: () {
                setState(() {
                  maxLines = 100;
                });
              },
              child: HeroIcon(
                HeroIcons.chevronDown,
                size: 15,
                color: DARK,
              ),
            )
        ],
      ),
    );
  }
}
