// ignore_for_file: non_constant_identifier_names
import 'package:dio/dio.dart';
import 'package:qirha/functions/full_date.dart';
import 'package:qirha/model/commandes.dart';

class ApiServices {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.0.104:5000/api/v1',
      connectTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 40),
    ),
  );

  loginUser(String login, String password) async {
    try {
      Map<String, dynamic> jsonData = {
        "login": login,
        "mot_de_passe": password,
      };

      // Make the API call
      Response response = await dio.post('/login', data: jsonData);
      dynamic responseData = response.data;

      return responseData;
    } catch (error) {
      print("LOGIN EXCEPTION : $error");
      print("EXCEPTION : $error");
      return [];
    }
  }

  getCategories() async {
    try {
      Response response = await dio.get('/categories');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getHotCategories() async {
    try {
      Response response = await dio.get('/hot/categories');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduits() async {
    try {
      Response response = await dio.get('/produits');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduitsBazard() async {
    try {
      Response response = await dio.get('/produits/bazard');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduitGallery(String produit_id) async {
    try {
      Response response = await dio.get('/produit-gallery/$produit_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getMainCategorie() async {
    try {
      Response response = await dio.get('/main-categories');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getallGroupeByMainCategorie(mainCategorieId) async {
    try {
      Response response = await dio.get(
        '/groupe-categories/main/$mainCategorieId',
      );
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduitsCouleurs(String? produit_id) async {
    try {
      Response response = await dio.get('/produit-couleur/$produit_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduitsGallery(String? produit_id, String? produit_couleur_id) async {
    try {
      Response response = await dio.get(
        '/produits/gallery/$produit_id/$produit_couleur_id',
      );
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduitsTailles(String? produit_id) async {
    try {
      Response response = await dio.get('/produit-taille/$produit_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduitCaracteristique(String? produit_id) async {
    try {
      Response response = await dio.get('/produit-caracteristique/$produit_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduitOfCategorie(String? categorie_id) async {
    try {
      Response response = await dio.get('/produits/categorie/$categorie_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getAllTailles() async {
    try {
      Response response = await dio.get('/tailles');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getAllCouleurs() async {
    try {
      Response response = await dio.get('/couleurs');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getMainCategorieGroupes(String? main_categorie_id) async {
    try {
      Response response = await dio.get(
        '/groupe-categories/main/$main_categorie_id',
      );
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getCategoriesOfGroupe(String? groupe_id) async {
    try {
      Response response = await dio.get('/categories/groupe/$groupe_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduitOfMainCategorie(String? main_categorie_id) async {
    try {
      Response response = await dio.get(
        '/produits/main-categorie/$main_categorie_id',
      );
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduitOfGroupe(String? groupe_id) async {
    try {
      Response response = await dio.get('/produits/groupe/$groupe_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduitAvisStats(String? produit_id) async {
    try {
      Response response = await dio.get('/produit-avis-type/$produit_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getProduitAvis(String? produit_id) async {
    try {
      Response response = await dio.get('/produit-avis/produit/$produit_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getCommandes(String? utilisateur_id) async {
    try {
      Response response = await dio.get('/commandes/user/$utilisateur_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getArticlesCommande(String? commande_id) async {
    try {
      Response response = await dio.get('/articles-commande/$commande_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  getPanierUtilisateur(String? utilisateur_id) async {
    try {
      Response response = await dio.get('/panier-utilisateur/$utilisateur_id');
      List<dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  addPanierItem(String? utilisateur_id, AddPanierModel panierItem) async {
    try {
      Object data = {
        'taille_id': panierItem.taille_id,
        'couleur_id': panierItem.couleur_id,
        'produit_id': panierItem.produit_id,
        'utilisateur_id': panierItem.utilisateur_id,
        'quantite': panierItem.quantite,
        'photo_cover': panierItem.image_id,
      };

      Response response = await dio.post(
        '/panier-utilisateur/$utilisateur_id',
        data: data,
        onSendProgress: (int sent, int total) {
          print('sending panier item : $sent / $total');
        },
      );
      Map<String, dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  deleteAllPanierUtilisateur(String? utilisateur_id) async {
    try {
      Response response = await dio.delete(
        '/delete-all/panier-utilisateur/$utilisateur_id',
      );
      Map<String, dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  deletePanierItem(String? utilisateur_id, AddPanierModel panierItem) async {
    try {
      Object data = {
        'taille_id': panierItem.taille_id,
        'couleur_id': panierItem.couleur_id,
        'produit_id': panierItem.produit_id,
        'utilisateur_id': panierItem.utilisateur_id,
        'quantite': panierItem.quantite,
        'image_id': panierItem.image_id,
      };

      Response response = await dio.post(
        '/delete-one/panier-utilisateur/$utilisateur_id',
        data: data,
      );
      Map<String, dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }

  enregisterCommande(
    String? utilisateur_id,
    double prixTotal,
    List<ArticlesCommandeModel> panierArticles,
  ) async {
    try {
      var articles = [];

      for (var i = 0; i < panierArticles.length; i++) {
        articles.add({
          'produit_id': panierArticles[i].produit_id,
          'photo_cover': panierArticles[i].image_id,
          'quantite': panierArticles[i].quantite,
          'prix_unitaire': panierArticles[i].prix_unitaire,
          'taille_id': panierArticles[i].taille_id,
          'couleur_id': panierArticles[i].couleur_id,
        });
      }
      Object data = {
        'utilisateur_id': utilisateur_id,
        'date_commande': getFullDateString(),
        'accepte_la_livraison': "0",
        'montant_total': "$prixTotal",
        'articles': articles,
      };

      Response response = await dio.post(
        '/enregistrement-commande-complete/$utilisateur_id',
        data: data,
      );
      Map<String, dynamic> responseData = response.data;

      return responseData;
    } catch (error) {
      print("EXCEPTION : $error");
      return [];
    }
  }
}
