import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class MyShimmerWidget extends StatefulWidget {
  const MyShimmerWidget({super.key, required this.width, required this.height});
  final double width;
  final double height;

  @override
  State<MyShimmerWidget> createState() => _MyShimmerWidgetState();
}

class _MyShimmerWidgetState extends State<MyShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return FadeShimmer(
      height: widget.height,
      width: widget.width,
      radius: 4,
      highlightColor: Color(0xffF9F9FB),
      baseColor: Color(0xffE6E8EB),
    );
  }
}
