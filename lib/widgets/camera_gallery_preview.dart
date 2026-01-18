import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/utils.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key, this.onImageSelected});

  /// Called when an image. is selected
  final void Function(AssetEntity selectedImage)? onImageSelected;

  @override
  _ImagePickerScreenState createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  List<AssetEntity> _images = [];
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _currentAlbum;

  // EMITTED WHEN AN IMAGE IS SELECTED
  void _onSelectedImage(AssetEntity selectedImage) {
    widget.onImageSelected?.call(selectedImage);
  }

  @override
  void initState() {
    super.initState();
    fetchAlbums();
  }

  Future<void> fetchAlbums() async {
    var isPermissionGranted = await PhotoManager.requestPermissionExtend();
    // ignore: unnecessary_null_comparison
    if (isPermissionGranted == null) {
      PhotoManager.openSetting();
      print("Permission rejected");
      fetchAlbums();
      return;
    }

    _albums = await PhotoManager.getAssetPathList();
    if (_albums.isNotEmpty) {
      setState(() {
        _currentAlbum = _albums[0]; // Sélection du premier album par défaut
        fetchImages(_currentAlbum!);
      });
    }
  }

  Future<void> fetchImages(AssetPathEntity album) async {
    _currentAlbum = album;
    List<AssetEntity> images =
        await album.getAssetListRange(start: 0, end: 100);
    setState(() {
      _images = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<AssetPathEntity>(
          isExpanded: true,
          value: _currentAlbum,
          dropdownColor: DARK,
          items: _albums
              .map((album) => DropdownMenuItem<AssetPathEntity>(
                    value: album,
                    child: customText(
                        album.name == 'Recent'
                            ? "Toute les photos"
                            : album.name,
                        style: TextStyle(color: WHITE, fontSize: 14)),
                  ))
              .toList(),
          onChanged: (selectedAlbum) {
            if (selectedAlbum != null) {
              fetchImages(selectedAlbum);
            }
          },
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _onSelectedImage(_images[index]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image(
                    image: AssetEntityImageProvider(_images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
