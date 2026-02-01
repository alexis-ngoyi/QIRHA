import 'package:flutter/material.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class LoadingProcess {
  static void showLoading({String text = 'Loading...'}) {
    var maskWidget = Opacity(
      opacity: 1,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );

    SmartDialog.showLoading(
      maskWidget: maskWidget,
      clickMaskDismiss: true,
      backDismiss: true,
      animationType: SmartAnimationType.scale,
      builder: (_) => CustomLoading(type: 2, text: text),
    );
  }

  static void dismissLoading() {
    SmartDialog.dismiss();
  }
}

class CustomLoading extends StatefulWidget {
  const CustomLoading({super.key, this.type = 0, this.text = ""});

  final int type;
  final String text;

  @override
  _CustomLoadingState createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // normal
        Visibility(visible: widget.type == 2, child: _buildLoadingThree()),
      ],
    );
  }

  Widget _buildLoadingThree() {
    return Center(
      child: Container(
        height: 120,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RotationTransition(
              alignment: Alignment.center,
              turns: _controller,
              child: Image.asset(pin_circle, height: 50, width: 50),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: customCenterText(
                widget.text,
                style: TextStyle(fontSize: 13, color: DARK),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
