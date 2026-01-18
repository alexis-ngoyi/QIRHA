import 'package:flutter/material.dart';

class MyButtonWidget extends StatefulWidget {
  const MyButtonWidget({
    super.key,
    required this.onPressed,
    required this.label,
    required this.bgColor,
    required this.labelColor,
    this.style = const TextStyle(fontSize: 11),
    this.padding = const EdgeInsets.all(12.0),
  });
  final Function() onPressed;
  final String label;
  final Color bgColor;
  final Color labelColor;
  final TextStyle style;
  final EdgeInsets padding;

  @override
  State<MyButtonWidget> createState() => _MyButtonWidgetState();
}

class _MyButtonWidgetState extends State<MyButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          widget.bgColor,
        ), // Background color when the button is not pressed
        foregroundColor: WidgetStateProperty.all<Color>(
          widget.labelColor,
        ), // Text color
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(widget.padding),
      ),
      onPressed: widget.onPressed,
      child: Text(widget.label, style: widget.style),
    );
  }
}
