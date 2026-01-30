// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:glass/glass.dart';
import 'package:heroicons/heroicons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:qirha/api/services.dart';
import 'package:qirha/api/shared_preferences.dart';
import 'package:qirha/main/tabs/tabLayout.dart';
import 'package:qirha/model/all_model.dart';
import 'package:qirha/widgets/image_scanner_simulator.dart';
import 'package:qirha/main/bottom_nav/tab_categorie.dart';
import 'package:qirha/main/bottom_nav/tab_mes_commandes.dart';
import 'package:qirha/main/bottom_nav/tab_mon_compte.dart';
import 'package:qirha/main/bottom_nav/tab_panier.dart';
import 'package:qirha/main/search.dart';
import 'package:qirha/res/colors.dart';
import 'package:qirha/res/miss_permissions.dart';
import 'package:qirha/res/utils.dart';
import 'package:qirha/widgets/camera_gallery_preview.dart';
import 'package:qirha/main/tabs/tout.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<CameraDescription> _cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // available only on IOS | Android
  if (Platform.isAndroid || Platform.isIOS) {
    await PhotoManager.clearFileCache();
    _cameras = await availableCameras();
  }

  // Initialize shared_preferences
  prefs = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/recherche':
            return MaterialPageRoute(
              builder: (BuildContext context) => const SearchBarScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (BuildContext context) => const MyHomePage(),
            );
        }
      },
      initialRoute: '/',
      title: 'Qirha',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: PRIMARY),
        useMaterial3: true,
        fontFamily: 'Lato',
      ),
      home: const HeroIconTheme(
        style: HeroIconStyle.outline,
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  int nbCommandes = 0;
  int totalCart = 0;
  bool isLogged = false;

  late List<Widget> tabBottomNav = [
    const Center(),
    const TabCategorieScreen(),
    const TabMesCommandesScreen(initialIndex: 0, canReturn: false),
    TabPanierScreen(canReturn: false),
    const TabMonCompteScreen(),
  ];

  void _onTabTapped(int int) {
    setState(() {
      _currentIndex = int;
    });
  }

  late List<BottomNavigationBarItem> _bottomNavigationItems;

  final List<MainCategorieModel> main_categories = <MainCategorieModel>[];

  List<Tab> tabs = <Tab>[];

  List<Widget> tabViews = const <Widget>[];

  getMainCategorie() async {
    var main_categorie = await ApiServices().getMainCategorie();

    var newTabs = <Tab>[const Tab(text: 'Tout')];
    var newTabViews = <Widget>[ToutTabScreen()];
    var newCategories = <MainCategorieModel>[];

    for (var main in main_categorie) {
      final model = MainCategorieModel(
        main_categorie_id: main['main_categorie_id'].toString(),
        nom_main_categorie: main['nom_main_categorie'],
      );

      newCategories.add(model);
      newTabs.add(Tab(text: model.nom_main_categorie));
      newTabViews.add(TabLayout(mainCategorie: model));
    }

    setState(() {
      tabs = newTabs;
      tabViews = newTabViews;
    });
  }

  Future<void> checkIf1stUsage() async {
    var isFirstUsage = prefs.getString('first_usage');

    if (isFirstUsage == null) {
      prefs.setString('first_usage', "0");
    }
  }

  late Timer main_timer;
  loadBadges() async {
    var utilisateur_id = prefs.getString('utilisateur_id');

    // Define the interval duration in milliseconds
    const intervalDuration = Duration(seconds: 1);

    if (utilisateur_id != null) {
      // Set up a periodic timer
      main_timer = Timer.periodic(intervalDuration, (timer) async {
        var articles = await ApiServices().getPanierUtilisateur(
          utilisateur_id.toString(),
        );

        var commandes = await ApiServices().getCommandes(utilisateur_id);

        setState(() {
          totalCart = articles.length;
          nbCommandes = commandes.length;
          isLogged = true;

          refreshBottomNavItems();
        });

        timer.cancel();
      });
    }
  }

  refreshBottomNavItems() {
    setState(() {
      _bottomNavigationItems = <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: HeroIcon(HeroIcons.home),
          label: 'Acceuil',
        ),
        const BottomNavigationBarItem(
          icon: HeroIcon(HeroIcons.shoppingBag),
          label: 'Categorie',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: isLogged,
            backgroundColor: PRIMARY,
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Text('$nbCommandes', style: const TextStyle(fontSize: 6)),
            ),
            child: const HeroIcon(HeroIcons.sparkles),
          ),
          label: 'Commandes',
        ),
        BottomNavigationBarItem(
          icon: Badge(
            isLabelVisible: isLogged,
            backgroundColor: const Color.fromARGB(255, 0, 43, 153),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                totalCart.toString(),
                style: const TextStyle(fontSize: 6),
              ),
            ),
            child: const HeroIcon(HeroIcons.shoppingCart),
          ),
          label: 'Panier',
        ),
        const BottomNavigationBarItem(
          icon: HeroIcon(HeroIcons.user),
          label: 'Compte',
        ),
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    getMainCategorie();
    refreshBottomNavItems();
    checkIf1stUsage();
    loadBadges();
  }

  @override
  void dispose() {
    super.dispose();
    main_timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return appWillPopScope(context);
            },
          );
          return shouldPop!;
        },
        child: Scaffold(
          backgroundColor: GREY,
          appBar: _currentIndex == 0 ? MyAppBar(context, tabs: tabs) : null,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            items: _bottomNavigationItems,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
          ),
          body: IconTheme(
            data: const IconThemeData(color: Colors.black),
            child: _currentIndex == 0
                ? TabBarView(children: tabViews)
                : tabBottomNav[_currentIndex],
          ),
        ),
      ),
    );
  }
}

class SearchWithCamera extends StatefulWidget {
  const SearchWithCamera({super.key});

  @override
  State<SearchWithCamera> createState() => _SearchWithCameraState();
}

class _SearchWithCameraState extends State<SearchWithCamera>
    with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isFront = false;
  bool isFlashActived = false;
  bool isAuth = true;
  List<AssetEntity> _imagesGallery = [];
  List<AssetPathEntity> _albums = [];
  AssetPathEntity? _currentAlbum;

  @override
  void initState() {
    super.initState();
    fetchAlbums();
    _initializeCamera();
    WidgetsBinding.instance.addObserver(this);
    isFront = false;
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed ||
  //       state == AppLifecycleState.hidden ||
  //       state == AppLifecycleState.inactive ||
  //       state == AppLifecycleState.paused) {
  //     _controller =
  //         CameraController(_controller.description, ResolutionPreset.max);
  //     _initializeControllerFuture = _controller.initialize();
  //   }

  //   super.didChangeAppLifecycleState(state);
  // }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const MissingPermissionScreen();
            }

            return Stack(
              children: [
                Stack(
                  children: [cameraFullScreen(), cameraControlsArea(context)],
                ),
                buttonToTakePhoto(context),
              ],
            );
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ).asGlass(tintColor: Colors.black);
          }
        },
      ),
    );
  }

  Positioned buttonToTakePhoto(BuildContext context) {
    return Positioned(
      bottom: 130,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: GestureDetector(
            onTap: _takePicture,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white.withOpacity(.35),
              ),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: PRIMARY,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column cameraControlsArea(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        cameraTopControls(context),
        cameraBottomControls(context).asGlass(
          tintColor: isAuth ? Colors.black : DANGER,
          blurX: 60,
          blurY: 60,
        ),
      ],
    );
  }

  SizedBox cameraBottomControls(BuildContext context) {
    return SizedBox(
      height: 110,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: isAuth
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          'Photos (${_imagesGallery.length})',
                          style: TextStyle(
                            fontSize: 14,
                            color: WHITE,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => customModalResizable(
                            context,
                            home: ImagePickerScreen(
                              onImageSelected: (AssetEntity selectedImage) =>
                                  CustomPageRoute(
                                    ImageScannerSimulator(
                                      selectedImage: selectedImage,
                                    ),
                                    context,
                                  ),
                            ),
                            heightPercent: .9,
                          ),
                          child: Container(
                            child: Row(
                              children: [
                                espacementWidget(width: 3),
                                customText(
                                  "Gallerie",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: WHITE,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                espacementWidget(width: 3),
                                HeroIcon(
                                  HeroIcons.chevronRight,
                                  color: WHITE,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: customText(
                        "Acces photos & Videos refuse",
                        style: TextStyle(
                          fontSize: 14,
                          color: isAuth ? WHITE : DANGER,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ).asGlass(tintColor: PRIMARY),
          espacementWidget(height: 10),
          isAuth
              ? photoManagerAlbumList(context)
              : Center(
                  child: GestureDetector(
                    onTap: () async => await PhotoManager.openSetting(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: DANGER,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: customText(
                        'Autoriser ?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: WHITE,
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  SingleChildScrollView photoManagerAlbumList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 10, height: 10),
          for (var index = 0; index < _imagesGallery.length; index++)
            GestureDetector(
              onTap: () => CustomPageRoute(
                ImageScannerSimulator(selectedImage: _imagesGallery[index]),
                context,
              ),
              child: SizedBox(
                width: 57,
                height: 57,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image(
                      image: AssetEntityImageProvider(_imagesGallery[index]),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text('Failed to load image'),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Positioned cameraTopControls(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            espacementWidget(height: 150),
            controlsIconItem(
              context,
              icon: HeroIcons.chevronLeft,
              onTap: () => Navigator.of(context).pop(),
            ),
            espacementWidget(height: 30),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(width: 1, color: GREY),
              ),
              child: customText(
                'MAX',
                style: TextStyle(fontSize: 8, color: GREY),
              ),
            ),
            espacementWidget(height: 30),
            controlsIconItem(
              context,
              icon: isFlashActived ? HeroIcons.bolt : HeroIcons.boltSlash,
              onTap: () => {
                setState(() {
                  isFlashActived = !isFlashActived;
                }),
                onSetFlashModeButtonPressed(),
              },
            ),
            espacementWidget(height: 30),
            controlsIconItem(
              context,
              icon: HeroIcons.arrowPathRoundedSquare,
              onTap: _changeCamera,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector controlsIconItem(
    BuildContext context, {
    required HeroIcons icon,
    Function()? onTap,
    bool isRotate = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: HeroIcon(icon, color: GREY, size: 20),
      ),
    );
  }

  Widget cameraFullScreen() {
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Align(
      alignment: Alignment.center,
      child: Transform.scale(
        scale: scale,
        child: GestureDetector(
          onDoubleTap: refreshCamera,
          child: CameraPreview(_controller),
        ),
      ),
    );
  }

  void _initializeCamera() async {
    _controller = CameraController(_cameras[0], ResolutionPreset.max);

    _initializeControllerFuture = _controller.initialize();
  }

  _takePicture() async {
    var image = await _controller.takePicture();
    final String path = image.path;
    final File file = File(path);

    // Custom directory name
    final String directoryName = 'qirha';

    final Directory directory = Directory(
      '${(await getApplicationDocumentsDirectory()).path}/$directoryName',
    );

    // Create the custom directory if it doesn't exist
    if (!directory.existsSync()) {
      directory.createSync();
    }

    final String imagePath = '${directory.path}/${idGenerator()}.jpg';

    // Save the XFile to the custom directory
    file.copy(imagePath);

    final AssetEntity assetEntity = await PhotoManager.editor.saveImageWithPath(
      file.path,
      title: 'qirha',
    );

    // ignore: use_build_context_synchronously
    return CustomPageRoute(
      ImageScannerSimulator(selectedImage: assetEntity),
      context,
    );
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  Future<void> _changeCamera() async {
    if (_cameras.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera frontale non disponible')),
      );
      return;
    }

    setState(() {
      isFront = !isFront;
    });

    try {
      await _controller.setDescription(isFront ? _cameras[1] : _cameras[0]);
    } on CameraException catch (e) {
      print("[CAMERA EXCEPTION] : ${e.description}");
      rethrow;
    }
  }

  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await _controller.setFlashMode(mode);
    } on CameraException catch (e) {
      print("[CAMERA EXCEPTION] : ${e.description}");
      rethrow;
    }
  }

  void onSetFlashModeButtonPressed() {
    FlashMode mode = isFlashActived ? FlashMode.torch : FlashMode.off;
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Flash mode set to ${mode.toString().split('.').last}'),
        ),
      );
    });
  }

  refreshCamera() {
    setState(() {
      _initializeControllerFuture = _controller.initialize();
    });
  }

  Future<void> fetchAlbums() async {
    _albums = await PhotoManager.getAssetPathList();
    if (_albums.isNotEmpty) {
      setState(() {
        _currentAlbum = _albums[0]; // Sélection du premier album par défaut
        fetchImages(_currentAlbum!);
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  Future<void> fetchImages(AssetPathEntity album) async {
    _currentAlbum = album;
    List<AssetEntity> images = await album.getAssetListRange(
      start: 0,
      end: 100,
    );
    setState(() {
      _imagesGallery = images;
      isAuth = _imagesGallery.isEmpty ? false : true;
    });
  }
}
