import 'package:flutter/material.dart';
import 'package:qirha/res/colors.dart';

class MyReactiveIconWidget extends StatefulWidget {
  const MyReactiveIconWidget({
    super.key,
    required this.icon,
    required this.size,
    required this.padding,
    required this.onTap,
    required this.color,
    required this.activeIcon,
    required this.activeColor,
    required this.isActive,
    required this.isLoading,
  });

  final IconData icon;
  final IconData activeIcon;
  final double size;
  final double padding;
  final Function() onTap;
  final Color color;
  final Color activeColor;
  final bool isActive;
  final bool isLoading;

  @override
  State<MyReactiveIconWidget> createState() => _MyReactiveIconWidgetState();
}

class _MyReactiveIconWidgetState extends State<MyReactiveIconWidget> {
  bool isActive = false;
  bool isLoading = false;

  @override
  void didUpdateWidget(covariant MyReactiveIconWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // avoid the process of building widgets error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isLoading = widget.isLoading;
        isActive = widget.isActive;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            margin: const EdgeInsets.only(left: 15),
            height: 10,
            width: 10,
            child: CircularProgressIndicator(color: PRIMARY, strokeWidth: 2),
          )
        : GestureDetector(
            onTap: widget.onTap,
            child: Padding(
              padding: EdgeInsets.all(widget.padding),
              child: Icon(
                widget.isActive ? widget.activeIcon : widget.icon,
                size: widget.size,
                color: widget.isActive ? widget.activeColor : widget.color,
              ),
            ),
          );
  }
}
