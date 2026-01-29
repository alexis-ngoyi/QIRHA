import 'package:flutter/material.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({
    super.key,
    required this.onChange,
    this.defaultValue = true,
  });

  final void Function(bool active)? onChange;
  final bool defaultValue;

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool active = false;

  @override
  void initState() {
    super.initState();
    active = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          active = !active;
          widget.onChange?.call(active);
        });
      },
      child: Row(
        children: [
          customText(
            active ? 'Oui' : 'Non',
            style: TextStyle(color: LIGHT, fontSize: 11),
          ),
          espacementWidget(width: 5),
          Container(
            width: 40,
            height: 20,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: active ? PRIMARY : Colors.black.withOpacity(.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
              mainAxisAlignment: active
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: WHITE,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
