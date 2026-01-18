import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CustomExpandableWidget extends StatefulWidget {
  const CustomExpandableWidget(
      {super.key,
      required this.label,
      this.content = const Center(
        child: Text('Expanded widget'),
      ),
      this.isExpanded = false,
      this.last = false,
      this.size = 14});
  final String label;
  final Widget content;
  final bool isExpanded;
  final bool last;
  final double size;

  @override
  State<CustomExpandableWidget> createState() => _CustomExpandableWidgetState();
}

class _CustomExpandableWidgetState extends State<CustomExpandableWidget> {
  late bool isExpanded = widget.isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
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
      decoration: BoxDecoration(
          border: !widget.last
              ? Border(
                  bottom: BorderSide(
                      width: 1, color: Colors.black.withOpacity(.05)))
              : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => {
              setState(() {
                isExpanded = !isExpanded;
              })
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: customText(widget.label,
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: widget.size,
                              color: DARK,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  HeroIcon(
                    isExpanded ? HeroIcons.chevronUp : HeroIcons.chevronDown,
                    size: 15,
                    color: DARK,
                  )
                ],
              ),
            ),
          ),
          if (isExpanded) widget.content
        ],
      ),
    );
  }
}
