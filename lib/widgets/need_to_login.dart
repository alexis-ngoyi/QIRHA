import 'package:flutter/material.dart';
import 'package:qirha/auth/authentification.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/combo/custom_button.dart';
import 'package:qirha/widgets/image_svg.dart';

class NeedToLogin extends StatefulWidget {
  const NeedToLogin({super.key});

  @override
  State<NeedToLogin> createState() => _NeedToLoginState();
}

class _NeedToLoginState extends State<NeedToLogin> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [requestLogin(context)],
      ),
    );
  }
}

Center requestLogin(BuildContext context) {
  return Center(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          espacementWidget(height: 30),
          const Center(
            child: MySvgImageWidget(
              asset: need_to_login,
              height: 130,
              width: 130,
            ),
          ),
          espacementWidget(height: 30),
          customCenterText(
            'Aucune session detectée',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: DARK,
              fontWeight: FontWeight.bold,
            ),
          ),
          espacementWidget(height: 20),
          customCenterText(
            'Connectez-vous pour profiter de toutes les fonctionnalités de Qirha',
            maxLines: 4,
            textAlign: TextAlign.center,
            style: TextStyle(color: DARK, fontSize: 12),
          ),
          espacementWidget(height: 10),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  child: Expanded(
                    flex: 2,
                    child: MyButtonWidget(
                      onPressed: () => triggerAuthentification(context),
                      label: "JE M'INSCRIS",
                      bgColor: WHITE,
                      labelColor: DARK,
                    ),
                  ),
                ),
                espacementWidget(width: 10),
                SizedBox(
                  height: 40,
                  child: Expanded(
                    flex: 3,
                    child: MyButtonWidget(
                      onPressed: () => triggerAuthentification(context),
                      label: 'JE ME CONNECTE',
                      bgColor: PRIMARY,
                      labelColor: WHITE,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

triggerAuthentification(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: .8,
        minChildSize: 0.1,
        maxChildSize: .8,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 5, color: WHITE)),
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const NeverScrollableScrollPhysics(),
              child: const SizedBox(
                height: 900,
                child: AuthentificationScreen(),
              ),
            ),
          );
        },
      );
    },
  );
}
