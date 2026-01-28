import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:glass/glass.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class ImageScannerSimulator extends StatefulWidget {
  const ImageScannerSimulator({super.key, required this.selectedImage});
  final AssetEntity selectedImage;

  @override
  State<ImageScannerSimulator> createState() => _ImageScannerSimulatorState();
}

class _ImageScannerSimulatorState extends State<ImageScannerSimulator> {
  int _counter = 0;
  bool enableCounter = true;

  void startCounter(BuildContext context) {
    if (enableCounter) {
      if (_counter < 100) {
        Timer(const Duration(milliseconds: 1), () {
          setState(() {
            _counter++;
          });
        });
      } else if (_counter == 100) {
        setState(() {
          enableCounter = false;
          Future.delayed(
            const Duration(seconds: 4),
            _openSearchResult(context),
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Excute after build context completed
    WidgetsBinding.instance.addPostFrameCallback((_) => startCounter(context));

    return Material(
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image(
              image: AssetEntityImageProvider(widget.selectedImage),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customText(
                  '$_counter%',
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                espacementWidget(height: 10),
                customText(
                  'Nous effectuons une recherche pour vous',
                  style: TextStyle(
                    color: WHITE,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                espacementWidget(height: 10),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: BLUE,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: customText(
                      'Annuler',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: WHITE,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).asGlass(tintColor: BLUE, blurX: 2.0, blurY: 2.0),
        ],
      ),
    );
  }

  _openSearchResult(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: .8,
          child: Container(
            color: WHITE,
            child: Column(
              children: [
                showModalSmallBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: StaggeredGrid.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 12,
                            children: [
                              // for (var i = 0;
                              //     i < nouveauteImageList.length;
                              //     i++)
                              //   ProduitCardView(context,
                              //       reduction: false,
                              //       i: i,
                              //       image: nouveauteImageList[i],
                              //       gallerie: nouveauteImageList),
                            ],
                          ),
                        ),
                        espacementWidget(height: 50),
                        noMoreProduit(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
