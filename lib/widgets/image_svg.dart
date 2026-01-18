import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MySvgImageWidget extends StatefulWidget {
  const MySvgImageWidget(
      {super.key, required this.asset, this.width = 90, this.height = 100});
  final String asset;
  final double width;
  final double height;

  @override
  State<MySvgImageWidget> createState() => _MySvgImageWidgetState();
}

class _MySvgImageWidgetState extends State<MySvgImageWidget> {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      widget.asset,
      semanticsLabel: 'Image',
      width: widget.width,
      height: widget.height,
      placeholderBuilder: (BuildContext context) =>
          const CircularProgressIndicator(),
    );
  }
}
