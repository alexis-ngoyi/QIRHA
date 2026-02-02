// ignore_for_file: non_constant_identifier_names
import 'package:dio/dio.dart';
import 'package:qirha/functions/util_functions.dart';
import 'package:qirha/model/all_model.dart';

class ApiServices {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.0.104:5000/api/v1',
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
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

  getProduitsGallery(String? produit_id) async {
    try {
      Response response = await dio.post('/produit/uploaded-image/$produit_id');
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitsGallery] (/produit/uploaded-image/$produit_id) : $error",
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

  getProduitAllCaracteristiques(String? produit_id) async {
    try {
      Response response = await dio.post(
        '/attributs-produit/$produit_id/all-caracteristiques',
      );

      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitAllCaracteristiques] ('/attributs-produit/$produit_id/all-caracteristiques) : $error",
      );
      return [];
    }
  }

  getProduitPrixMinimumParams(String? prix_produit_id) async {
    try {
      Response response = await dio.post(
        '/prix-produit/prix-produit-id/$prix_produit_id',
      );

      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitPrixMinimumParams] ('/prix-produit/prix-produit-id/$prix_produit_id) : $error",
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

  getProduitPrixParCombinaison({
    String? produit_id,
    required List<SelectedAttribut> selected,
  }) async {
    try {
      var json = [];

      selected.forEach((item) {
        json.add({
          "attributs_produit_caracteristiques_id":
              item.attributs_produit_caracteristiques_id,
          "attributs_produit_id": item.attributs_produit_id,
        });
      });

      Map<String, dynamic> jsonData = {
        "produit_id": produit_id,
        "combinaison_attribut_produit_caracteristique_ids": json,
      };
      Response response = await dio.post(
        '/prix-produit/by-combinaison',
        data: jsonData,
      );
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [getProduitPrixParAttributSelectionne] (//prix-produit/by-combinaison) : $error",
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
      print('commande_id $commande_id');
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
        'produit_id': panierItem.produit_id,
        'utilisateur_id': panierItem.utilisateur_id,
        'quantite': panierItem.quantite,
        'photo_cover': panierItem.photo_cover,
        'prix_produit_id': panierItem.prix_produit_id,
      };

      print(data);

      Response response = await dio.post(
        '/panier-utilisateur/$utilisateur_id/create',
        data: data,
      );
      return response.data;
    } catch (error) {
      print(
        "EXCEPTION [addPanierItem] (/panier-utilisateur/$utilisateur_id/create) : $error",
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

  deletePanierItem(String? utilisateur_id, panierItem) async {
    try {
      Object data = {
        'panier_utilisateur_id': panierItem['panier_utilisateur_id'],
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

  createCommande({
    String? utilisateur_id,
    double? montant_total,
    panierItems,
  }) async {
    try {
      var panier = [];

      // formatage liste des articles
      panierItems.forEach((item) {
        panier.add({
          'produit_id': item['produit_id'],
          'photo_cover': item['photo_cover'],
          'quantite': item['quantite'],
          'prix_produit_id': item['prix_produit_id'],
        });
      });

      // objet de la commande
      Object data = {
        'utilisateur_id': utilisateur_id,
        'montant_total': montant_total,
        'panier': panier,
      };
      Response response = await dio.post('/commandes/create', data: data);
      return response.data;
    } catch (error) {
      print("EXCEPTION [createCommande] (/commandes/create) : $error");
      return [];
    }
  }
}
