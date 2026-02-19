// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glass/glass.dart';
import 'package:heroicons/heroicons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/res/constantes.dart';
import 'package:qirha/widgets/cart_widget.dart';
import 'package:qirha/main.dart';
import 'package:qirha/main/produits/detail_produit.dart';
import 'package:qirha/main/messagerie/main_screen.dart';
import 'package:qirha/main/recherche/search.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/images.dart';
import 'package:qirha/res/miss_permissions.dart';

Padding lightDivider({double padding = 10}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: padding),
    child: Divider(
      color: Colors.black.withOpacity(.08),
      height: 1,
      thickness: 1,
    ),
  );
}

copyToClipBoard(
  BuildContext context, {
  required String text,
  String msg = "Copie reussie",
}) {
  Clipboard.setData(ClipboardData(text: text)).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  });
}

buildSnack(BuildContext context, {String msg = "test"}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: PRIMARY,
      dismissDirection: DismissDirection.horizontal,
      content: Text(msg),
    ),
  );
}

checkPermissionAndOpenCanera(BuildContext context) async {
  final PermissionState ps = await PhotoManager.requestPermissionExtend();

  const pCamera = Permission.camera;
  const pMicro = Permission.microphone;

  if (await pCamera.isDenied) {
    await pCamera.request();
  } else if (await pCamera.isPermanentlyDenied) {
    await PhotoManager.openSetting();
  }

  if (await pMicro.isDenied) {
    await pMicro.request();
  } else if (await pMicro.isPermanentlyDenied) {
    await PhotoManager.openSetting();
  }

  print("PHOTO MANAGER HAS ACCESS : ${ps.hasAccess}");
  print("PHOTO MANAGER IS ATH : ${ps.isAuth}");

  print("//////////////////////////////////////////////////////////");

  print("CAMERA GRANTED : ${await pCamera.status.isGranted}");
  print("CAMERA DENIED : ${await pCamera.status.isDenied}");
  print(
    "CAMERA PERMANANT DENIED : ${await pCamera.status.isPermanentlyDenied}",
  );

  print("CAMERA PROVISOIRE : ${await pCamera.status.isProvisional}");
  print("CAMERA LIMITED : ${await pCamera.status.isLimited}");
  print("CAMERA  : ${await pCamera.status.isRestricted}");
  print("//////////////////////////////////////////////////////////");
  print("MICRO GRANTED : ${await pMicro.status.isGranted}");
  print("MICRO DENIED : ${await pMicro.status.isDenied}");
  print("MICRO PERMANANT DENIED : ${await pMicro.status.isPermanentlyDenied}");

  print("MICRO PROVISOIRE : ${await pMicro.status.isProvisional}");
  print("MICRO LIMITED : ${await pMicro.status.isLimited}");
  print("MICRO  : ${await pMicro.status.isRestricted}");

  if (await pCamera.status.isGranted && await pMicro.status.isGranted) {
    // ignore: use_build_context_synchronously
    CustomPageRoute(const SearchWithCamera(), context);
  } else {
    // ignore: use_build_context_synchronously
    CustomPageRoute(const MissingPermissionScreen(), context);
  }
}

reloadPermissions(BuildContext context) async {
  Navigator.pop(context);
  checkPermissionAndOpenCanera(context);
}

Padding labelWithIcon({required String label, required HeroIcons icon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        HeroIcon(icon, size: 20, color: PRIMARY, style: HeroIconStyle.solid),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: customText(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

Text customText(
  String text, {
  int maxLines = 1,
  bool softWrap = true,
  TextOverflow overflow = TextOverflow.ellipsis,
  TextAlign textAlign = TextAlign.start,
  TextStyle? style,
}) {
  return Text(text, softWrap: softWrap, maxLines: maxLines, style: style);
}

customCenterText(
  String text, {
  int maxLines = 1,
  bool softWrap = true,
  TextOverflow overflow = TextOverflow.ellipsis,
  TextAlign textAlign = TextAlign.left,
  TextStyle? style,
}) {
  return RichText(
    textAlign: textAlign,
    overflow: overflow,
    maxLines: maxLines,
    softWrap: softWrap,
    text: TextSpan(
      children: [TextSpan(text: text, style: style)],
    ),
  );
}

Future<dynamic> CustomPageRoute(Widget widget, BuildContext context) {
  return Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      pageBuilder: (context, animation, secondaryAnimation) => widget,
    ),
  );
}

SizedBox SpacerHeight({double? height}) {
  return SizedBox(height: height);
}

triggerGetBack(context) {
  return Navigator.pop(context);
}

triggerCustomModal(context, {Widget? view, double per = .7}) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        child: Container(
          height: MediaQuery.of(context).size.height * per,
          color: Colors.transparent,
          child: view,
        ),
      );
    },
  );
}

triggerDynamicCustomModal(
  context, {
  Widget? view,
  double top = 100,
  Offset offset = const Offset(0, 1),
  double opacity = .2,
  bool fullscreen = true,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    transitionDuration: const Duration(milliseconds: 100),
    barrierLabel: MaterialLocalizations.of(context).dialogLabel,
    barrierColor: Colors.black.withOpacity(opacity),
    pageBuilder: (context, _, __) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            crossAxisAlignment: fullscreen
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.end,
            mainAxisAlignment: fullscreen
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: fullscreen
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                child: Container(
                  margin: EdgeInsets.only(top: top),
                  width:
                      MediaQuery.of(context).size.width * (fullscreen ? 1 : .9),
                  height:
                      MediaQuery.of(context).size.height *
                      (!fullscreen ? 1 : .7),
                  color: WHITE,
                  child: view,
                ),
              ),
            ],
          );
        },
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ).drive(Tween<Offset>(begin: offset, end: Offset.zero)),
        child: child,
      );
    },
  );
}

customNetWorkImage({
  required String image,
  required double radius,
  BoxFit fit = BoxFit.cover,
}) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(radius),
    child: FadeInImage.assetNetwork(
      placeholder: placeholder,
      image: image,
      fit: fit,
    ),
  );
}

Column ProduitDetailView({ProduitModel? produit}) {
  return Column(
    children: [
      Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 200,
              child: FadeInImage.assetNetwork(
                placeholder: placeholder,
                image: (produit?.url_image?.isEmpty ?? true)
                    ? demoPic
                    : produit!.url_image!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (produit?.est_en_promo == true)
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(color: DANGER, width: .6),
                ),
                child: customCenterText(
                  '- ${((produit?.taux_reduction ?? 0) * 100).toStringAsFixed(0)}%',
                  style: TextStyle(color: DANGER, fontSize: 8),
                ),
              ),
            ),
        ],
      ),
      Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(144, 239, 239, 240),
        ),
        height: 75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  produit?.est_en_promo == true
                      ? Row(
                          children: [
                            customText(
                              formatMoney(
                                produit?.prix_promo?.toString() ?? '0',
                              ),
                              style: TextStyle(
                                color: PRIMARY,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            espacementWidget(width: 5),
                            customText(
                              formatMoney(
                                produit?.prix_minimum?.toString() ?? '0',
                              ),
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.lineThrough,
                                decorationThickness: 1.0,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            customText(
                              formatMoney(
                                produit?.prix_minimum?.toString() ?? '0',
                              ),
                              style: TextStyle(
                                color: PRIMARY,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                  customText(
                    produit?.nom ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                      color: Color.fromARGB(225, 0, 0, 0),
                      fontSize: 11,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

GestureDetector ProduitCardView(
  BuildContext context, {
  required ProduitModel produit,
}) {
  return GestureDetector(
    onTap: () => CustomPageRoute(DetailProduit(produit: produit), context),
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Container(
        decoration: BoxDecoration(color: WHITE),
        child: Stack(
          children: [
            ProduitDetailView(produit: produit),
            Positioned(
              left: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: GREY,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: HeroIcon(
                  HeroIcons.shoppingCart,
                  size: 14,
                  color: PRIMARY,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Row customModalCloseButton(BuildContext context) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: HeroIcon(HeroIcons.xMark, color: DARK, size: 20),
        ),
      ),
    ],
  );
}

Column customDivider({Color? color}) {
  return Column(
    children: [
      espacementWidget(height: 3),
      Divider(thickness: 1, color: color ?? GREY),
      espacementWidget(height: 3),
    ],
  );
}

SizedBox espacementWidget({double height = 5, double width = 5}) {
  return SizedBox(height: height, width: width);
}

Container customSizeContainer({required String label}) {
  return Container(
    margin: const EdgeInsets.all(3),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      border: Border.all(width: 1, color: GREY),
    ),
    child: customText(label, style: const TextStyle(fontSize: 12)),
  );
}

Container roundedImageContainer({
  required String image,
  double width = 100,
  double height = 100,
  bool http = true,
}) {
  return Container(
    margin: http
        ? const EdgeInsets.all(3)
        : const EdgeInsets.symmetric(horizontal: 3),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: http
            ? FadeInImage.assetNetwork(
                placeholder: placeholder,
                image: image,
                fit: BoxFit.cover,
              )
            : Image.asset(image, fit: BoxFit.cover),
      ),
    ),
  );
}

Column customTailleWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: customText(
          'TAILLE',
          style: TextStyle(
            color: DARK,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      espacementWidget(height: 3),
      Wrap(
        children: [
          customSizeContainer(label: 'S'),
          customSizeContainer(label: 'M'),
          customSizeContainer(label: 'L'),
          customSizeContainer(label: 'XL'),
          customSizeContainer(label: 'XXL'),
        ],
      ),
    ],
  );
}

Column customCouleurWidget() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: customText(
          'COULEUR',
          style: TextStyle(
            color: DARK,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      espacementWidget(height: 2),
      Wrap(
        children: [
          roundedImageContainer(
            width: 50,
            height: 30,
            image:
                'https://m.media-amazon.com/images/I/81Dh3-zHCsL._AC_SY675_.jpg',
          ),
          roundedImageContainer(
            width: 50,
            height: 30,
            image:
                'https://m.media-amazon.com/images/I/71-og9SGxtL._AC_SY741_.jpg',
          ),
          roundedImageContainer(
            width: 50,
            height: 30,
            image:
                'https://m.media-amazon.com/images/I/71n-feem8lS._AC_SY679_.jpg',
          ),
          roundedImageContainer(
            width: 50,
            height: 30,
            image:
                'https://m.media-amazon.com/images/I/71Gymmqy2TL._AC_SY675_.jpg',
          ),
          roundedImageContainer(
            width: 50,
            height: 30,
            image:
                'https://m.media-amazon.com/images/I/81Dh3-zHCsL._AC_SY675_.jpg',
          ),
        ],
      ),
    ],
  );
}

AppBar MyAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,

    leading: GestureDetector(
      onTap: () => CustomPageRoute(const MessagerieScreen(), context),
      child: HeroIcon(HeroIcons.envelope, size: 25, color: WHITE),
    ),
    title: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(color: WHITE),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {
                  CustomPageRoute(const SearchBarScreen(), context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 15,
                  ),
                  child: customText(
                    'Rechercher',
                    style: TextStyle(fontSize: 14, color: DARK),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => checkPermissionAndOpenCanera(context),
                  child: SizedBox(
                    width: 50,
                    height: 40,
                    child: HeroIcon(HeroIcons.camera, size: 20, color: PRIMARY),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    CustomPageRoute(const SearchBarScreen(), context);
                  },
                  child: Container(
                    width: 50,
                    height: 40,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Container(
                      decoration: BoxDecoration(
                        color: PRIMARY,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: HeroIcon(
                        HeroIcons.magnifyingGlass,
                        size: 20,
                        color: WHITE,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    actions: [
      GestureDetector(
        onTap: () {},
        child: HeroIcon(HeroIcons.heart, size: 25, color: WHITE),
      ),
      espacementWidget(width: 14),
      MyCartWidget(size: 25, color: WHITE),
      espacementWidget(width: 10),
    ],
  );
}

Container simpleSearchBar(BuildContext context) {
  return Container(
    height: 45,
    decoration: BoxDecoration(color: GREY),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: GestureDetector(
            onTap: () {
              CustomPageRoute(const SearchBarScreen(), context);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: customText(
                'Rechercher',
                style: TextStyle(fontSize: 16, color: DARK),
              ),
            ),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => checkPermissionAndOpenCanera(context),
              child: const SizedBox(
                width: 50,
                height: 45,
                child: HeroIcon(HeroIcons.camera, size: 20),
              ),
            ),
            GestureDetector(
              onTap: () {
                CustomPageRoute(const SearchBarScreen(), context);
              },
              child: Container(
                width: 50,
                height: 45,
                decoration: BoxDecoration(color: PRIMARY),
                child: HeroIcon(
                  HeroIcons.magnifyingGlass,
                  size: 20,
                  color: WHITE,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Center customCenterTitle({required String title}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(25.0),
      child: customText(
        title,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

GestureDetector customCardCategorie({
  required String title,
  required String image,
  Function()? press,
}) {
  return GestureDetector(
    onTap: press,
    child: Column(
      children: [
        SizedBox(
          width: 80,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FadeInImage.assetNetwork(
              placeholder: placeholder,
              image: image.isNotEmpty ? image : demoPic,
              fit: BoxFit.contain,
            ),
          ),
        ),
        SizedBox(
          width: 75,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
            child: customCenterText(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              softWrap: true,
              style: TextStyle(fontSize: 11, color: DARK),
            ),
          ),
        ),
      ],
    ),
  );
}

Padding customAppSearchBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 42,
        decoration: BoxDecoration(color: WHITE),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: GestureDetector(
                onTap: () {
                  CustomPageRoute(const SearchBarScreen(), context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 10,
                  ),
                  child: customText(
                    'Habit Homme',
                    style: TextStyle(fontSize: 12, color: DARK),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => checkPermissionAndOpenCanera(context),
                  child: const SizedBox(
                    width: 50,
                    height: 45,
                    child: HeroIcon(HeroIcons.camera, size: 20),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    CustomPageRoute(const SearchBarScreen(), context);
                  },
                  child: Container(
                    width: 50,
                    height: 45,
                    decoration: BoxDecoration(color: PRIMARY),
                    child: HeroIcon(
                      HeroIcons.magnifyingGlass,
                      size: 20,
                      color: WHITE,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Container BazardRapidItem(
  BuildContext context, {
  required ProduitModel produit,
  double margin = 5,
  required bool reduction,
}) {
  return Container(
    margin: EdgeInsets.all(margin),
    child: GestureDetector(
      onTap: () => CustomPageRoute(DetailProduit(produit: produit), context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 200,
                  width: 170,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FadeInImage.assetNetwork(
                      placeholder: placeholder,
                      image: produit.url_image?.isNotEmpty == true
                          ? produit.url_image!
                          : demoPic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          customText(
                            formatMoney(produit.prix_promo?.toString() ?? '0'),
                            style: TextStyle(
                              color: PRIMARY,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          espacementWidget(width: 5),
                          customText(
                            formatMoney(
                              produit.prix_minimum?.toString() ?? '0',
                            ),
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 1.0,
                            ),
                          ),
                        ],
                      ),
                      espacementWidget(width: 5, height: 0),
                      SizedBox(
                        width: 120,
                        child: customText(
                          produit.nom ?? '',
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Positioned(
              top: 0,
              left: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(0),
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(8),
                ),
                child: Container(
                  decoration: BoxDecoration(color: PRIMARY),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      HeroIcon(HeroIcons.bolt, size: 12, color: WHITE),
                      espacementWidget(width: 5),
                      customText(
                        '-${((produit.taux_reduction ?? 0) * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 9,
                          color: WHITE,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

FonctionnaliteAccessRapideItem(
  HeroIcons icon,
  String text,
  Color color,
  void Function()? press,
) {
  return GestureDetector(
    onTap: press,
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: SizedBox(
        width: 160,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 50,
            decoration: BoxDecoration(color: WHITE),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: GREY,
                      ),
                      child: HeroIcon(icon, size: 15, color: color),
                    ),
                    espacementWidget(width: 10),
                    customText(
                      text,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: color, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

GestureDetector customlistTile({
  required String title,
  required String subtitle,
  Function()? press,
  bool last = false,
}) {
  return GestureDetector(
    onTap: press,
    child: Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: DARK,
            ),
          ),
          customText(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: DARK),
          ),
        ],
      ),
    ),
  );
}

GestureDetector showModalSmallBar(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Column(
      children: [
        espacementWidget(height: 20),
        Center(
          child: Container(
            width: 70,
            height: 3,
            decoration: BoxDecoration(
              color: GREY,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        espacementWidget(height: 10),
      ],
    ),
  );
}

AppBar MesCommandesAppBar(
  BuildContext context, {
  required List<Widget> tabs,
  required TabController controller,
  required bool canReturn,
}) {
  return AppBar(
    backgroundColor: WHITE,
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(30),
      child: Container(
        color: WHITE,
        height: 48,
        child: Scrollbar(
          controller: ScrollController(),
          child: TabBar(
            controller: controller,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: tabs,
          ),
        ),
      ),
    ),
    leading: GestureDetector(
      onTap: () => canReturn ? Navigator.of(context).pop() : {},
      child: HeroIcon(
        canReturn ? HeroIcons.chevronLeft : HeroIcons.printer,
        size: 25,
      ),
    ),
    title: customText(
      'Mes commandes',
      style: TextStyle(fontSize: 17, color: DARK, fontWeight: FontWeight.bold),
    ),
    actions: [
      GestureDetector(
        onTap: () => CustomPageRoute(SearchBarScreen(), context),
        child: const HeroIcon(HeroIcons.magnifyingGlass, size: 24),
      ),
      espacementWidget(width: 20),
      GestureDetector(
        onTap: () {},
        child: const HeroIcon(HeroIcons.heart, size: 24),
      ),
      espacementWidget(width: 10),
    ],
  );
}

Padding informationLivraisonView() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(width: 50, height: 1, color: PRIMARY),
        SizedBox(
          width: 200,
          child: customCenterText(
            "Achetez plus et faites vos livrer dans les 24h partout au congo",
            softWrap: true,
            maxLines: 10,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: DARK),
          ),
        ),
        Container(width: 50, height: 1, color: PRIMARY),
      ],
    ),
  );
}

Column noMoreProduit() {
  return Column(
    children: [
      espacementWidget(height: 30),
      Center(
        child: customText(
          'Oups!! vous avez atteint le fond!',
          softWrap: true,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ),
      espacementWidget(height: 30),
    ],
  );
}

AlertDialog appWillPopScope(BuildContext context) {
  return AlertDialog(
    backgroundColor: WHITE,
    titlePadding: const EdgeInsets.all(5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    title: Column(
      children: [
        espacementWidget(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(app_icon, fit: BoxFit.cover),
          ),
        ),
        espacementWidget(height: 10),
        customText(
          "Assistant qirha",
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        espacementWidget(height: 5),
        customText(
          "Voulez-vous fermer l'app ?",
          style: const TextStyle(fontSize: 13),
        ),
      ],
    ),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
        child: customText("OUI", style: const TextStyle(fontSize: 14)),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context, false);
        },
        child: customText("NON", style: const TextStyle(fontSize: 14)),
      ),
    ],
  );
}

customModalResizable(
  BuildContext context, {
  required Widget home,
  required double heightPercent,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: heightPercent,
        child: Container(
          color: DARK,
          child: Column(
            children: [
              showModalSmallBar(context),
              Expanded(child: home),
            ],
          ),
        ),
      ).asGlass();
    },
  );
}

GestureDetector listLinkItem(
  BuildContext context, {
  required String label,
  String trailingLabel = '',
  required List<Widget> actions,
  Widget? route,
}) {
  return GestureDetector(
    onTap: () => CustomPageRoute(route as Widget, context),
    child: Container(
      color: WHITE,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          customText(label, style: const TextStyle(fontSize: 13)),
          (actions.isEmpty)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    trailingLabel.isNotEmpty
                        ? SizedBox(
                            child: customText(
                              trailingLabel,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12, color: LIGHT),
                            ),
                          )
                        : const Text(''),
                    espacementWidget(width: 5),
                    const HeroIcon(HeroIcons.chevronRight, size: 14),
                  ],
                )
              : Row(children: actions),
        ],
      ),
    ),
  );
}

Container cardStatus({
  required Color color,
  required HeroIcons icon,
  required String label,
  bool hide = false,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      border: Border.all(width: 1, color: color),
    ),
    child: Row(
      children: [
        if (!hide) HeroIcon(icon, color: color, size: 9),
        espacementWidget(width: 4),
        customText(label, style: TextStyle(fontSize: 8, color: color)),
      ],
    ),
  );
}
