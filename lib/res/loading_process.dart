import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:qirha/res/custom_loading.dart';

class LoadingProcess {
  static void showLoading({String text = 'Loading...'}) {
    var maskWidget = Opacity(
      opacity: 1,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white, // or your WHITE constant
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
