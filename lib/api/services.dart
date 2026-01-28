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
      Response response = await dio.post('/login', data: jsonData);
      return response.data;
    } catch (error) {
      print("EXCEPTION [loginUser] (/login) : $error");
      return [];
    }
  }

  getCategories() async {
    try {
      Response response = await dio.post('/categories');
      return response.data;
    } catch (error) {
      print("EXCEPTION [getCategories] (/categories) : $error");
      return [];
    }
  }

  getHotCategories() async {
    try {
      Response response = await dio.post('/hot/categories');
      return response.data;
    } catch (error) {
      print("EXCEPTION [getHotCategories] (/hot/categories) : $error");
      return [];
    }
  }

  getProduits() async {
    try {
      Response response = await dio.post('/produits');
      return response.data;
    } catch (error) {
      print("EXCEPTION [getProduits] (/produits) : $error");
      return [];
    }
  }

  getProduitsBazard() async {
    try {
      Response response = await dio.post('/produits/bazard');
      return response.data;
    } catch (error) {
      print("EXCEPTION [getProduitsBazard] (/produits/bazard) : $error");
      return [];
    }
  }

  getProduitGallery(String produit_id) async {
    try {
      Response response = await dio.post('/produit-gallery/$produit_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitGallery] (/produit-gallery/$produit_id) : $error",
      );
      return [];
    }
  }

  getMainCategorie() async {
    try {
      Response response = await dio.post('/main-categories');
      return response.data;
    } catch (error) {
      print("EXCEPTION [getMainCategorie] (/main-categories) : $error");
      return [];
    }
  }

  getallGroupeByMainCategorie(mainCategorieId) async {
    try {
      Response response = await dio.post(
        '/groupe-categories/main/$mainCategorieId',
      );
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getallGroupeByMainCategorie] (/groupe-categories/main/$mainCategorieId) : $error",
      );
      return [];
    }
  }

  getProduitsCouleurs(String? produit_id) async {
    try {
      Response response = await dio.post('/produit-couleur/$produit_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitsCouleurs] (/produit-couleur/$produit_id) : $error",
      );
      return [];
    }
  }

  getProduitsGallery(String? produit_id, String? produit_couleur_id) async {
    try {
      Response response = await dio.post(
        '/produits/gallery/$produit_id/$produit_couleur_id',
      );
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitsGallery] (/produits/gallery/$produit_id/$produit_couleur_id) : $error",
      );
      return [];
    }
  }

  getProduitsTailles(String? produit_id) async {
    try {
      Response response = await dio.post('/produit-taille/$produit_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitsTailles] (/produit-taille/$produit_id) : $error",
      );
      return [];
    }
  }

  getProduitCaracteristique(String? produit_id) async {
    try {
      Response response = await dio.post(
        '/produit-caracteristique/$produit_id',
      );
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitCaracteristique] (/produit-caracteristique/$produit_id) : $error",
      );
      return [];
    }
  }

  getProduitOfCategorie(String? categorie_id) async {
    try {
      Response response = await dio.post('/produits/categorie/$categorie_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitOfCategorie] (/produits/categorie/$categorie_id) : $error",
      );
      return [];
    }
  }

  getAllTailles() async {
    try {
      Response response = await dio.post('/tailles');
      return response.data;
    } catch (error) {
      print("EXCEPTION [getAllTailles] (/tailles) : $error");
      return [];
    }
  }

  getAllCouleurs() async {
    try {
      Response response = await dio.post('/couleurs');
      return response.data;
    } catch (error) {
      print("EXCEPTION [getAllCouleurs] (/couleurs) : $error");
      return [];
    }
  }

  getMainCategorieGroupes(String? main_categorie_id) async {
    try {
      Response response = await dio.post(
        '/groupe-categories/main/$main_categorie_id',
      );
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getMainCategorieGroupes] (/groupe-categories/main/$main_categorie_id) : $error",
      );
      return [];
    }
  }

  getCategoriesOfGroupe(String? groupe_id) async {
    try {
      Response response = await dio.post('/categories/groupe/$groupe_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getCategoriesOfGroupe] (/categories/groupe/$groupe_id) : $error",
      );
      return [];
    }
  }

  getProduitOfMainCategorie(String? main_categorie_id) async {
    try {
      Response response = await dio.post(
        '/produits/main-categorie/$main_categorie_id',
      );
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitOfMainCategorie] (/produits/main-categorie/$main_categorie_id) : $error",
      );
      return [];
    }
  }

  getProduitOfGroupe(String? groupe_id) async {
    try {
      Response response = await dio.post('/produits/groupe/$groupe_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitOfGroupe] (/produits/groupe/$groupe_id) : $error",
      );
      return [];
    }
  }

  getProduitAvisStats(String? produit_id) async {
    try {
      Response response = await dio.post('/produit-avis-type/$produit_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitAvisStats] (/produit-avis-type/$produit_id) : $error",
      );
      return [];
    }
  }

  getProduitAvis(String? produit_id) async {
    try {
      Response response = await dio.post('/produit-avis/produit/$produit_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitAvis] (/produit-avis/produit/$produit_id) : $error",
      );
      return [];
    }
  }

  getCommandes(String? utilisateur_id) async {
    try {
      Response response = await dio.post('/commandes/user/$utilisateur_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getCommandes] (/commandes/user/$utilisateur_id) : $error",
      );
      return [];
    }
  }

  getArticlesCommande(String? commande_id) async {
    try {
      Response response = await dio.post('/articles-commande/$commande_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getArticlesCommande] (/articles-commande/$commande_id) : $error",
      );
      return [];
    }
  }

  getPanierUtilisateur(String? utilisateur_id) async {
    try {
      Response response = await dio.post('/panier-utilisateur/$utilisateur_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getPanierUtilisateur] (/panier-utilisateur/$utilisateur_id) : $error",
      );
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
      );
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [addPanierItem] (/panier-utilisateur/$utilisateur_id) : $error",
      );
      return [];
    }
  }

  deleteAllPanierUtilisateur(String? utilisateur_id) async {
    try {
      Response response = await dio.delete(
        '/delete-all/panier-utilisateur/$utilisateur_id',
      );
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [deleteAllPanierUtilisateur] (/delete-all/panier-utilisateur/$utilisateur_id) : $error",
      );
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
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [deletePanierItem] (/delete-one/panier-utilisateur/$utilisateur_id) : $error",
      );
      return [];
    }
  }

  enregisterCommande(
    String? utilisateur_id,
    double prixTotal,
    List<ArticlesCommandeModel> panierArticles,
  ) async {
    try {
      var articles = panierArticles
          .map(
            (e) => {
              'produit_id': e.produit_id,
              'photo_cover': e.image_id,
              'quantite': e.quantite,
              'prix_unitaire': e.prix_unitaire,
              'taille_id': e.taille_id,
              'couleur_id': e.couleur_id,
            },
          )
          .toList();

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
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [enregisterCommande] (/enregistrement-commande-complete/$utilisateur_id) : $error",
      );
      return [];
    }
  }
}
