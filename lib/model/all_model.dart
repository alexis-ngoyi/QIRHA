import 'package:flutter/material.dart';

class MainCarouselModel {
  String? img;
  Widget? route;

  MainCarouselModel({this.img, this.route});
}

class CategorieModel {
  String? img;
  String? libelle;
  String? categorie_id;

  CategorieModel({this.img, this.libelle, this.categorie_id});
  factory CategorieModel.fromJson(Map<String, dynamic> json) {
    return CategorieModel(
      categorie_id: json['categorie_id'],
      img: json['img'],
      libelle: json['libelle'],
    );
  }
}

class GroupeCategorieModel {
  String? groupe;
  String? id;
  List<CategorieModel>? categorie;

  GroupeCategorieModel({this.groupe, this.categorie, this.id});
  factory GroupeCategorieModel.fromJson(Map<String, dynamic> json) {
    return GroupeCategorieModel(
      id: json['id'],
      groupe: json['groupe'],
      categorie: json['categorie'],
    );
  }
}

class CommandeModel {
  int commande_id;
  int utilisateur_id;
  String nom_utilisateur;
  String? date_commande;
  double? montant_total;
  String status;
  String accepte_la_livraison;
  String? code_commande;

  CommandeModel({
    required this.commande_id,
    required this.utilisateur_id,
    required this.nom_utilisateur,
    required this.date_commande,
    required this.montant_total,
    required this.status,
    required this.accepte_la_livraison,
    this.code_commande,
  });

  // Méthode pour convertir depuis JSON
  factory CommandeModel.fromJson(Map<String, dynamic> json) {
    return CommandeModel(
      commande_id: json['commande_id'],
      utilisateur_id: json['utilisateur_id'],
      nom_utilisateur: json['nom_utilisateur'],
      date_commande: json['date_commande'],
      montant_total: (json['montant_total'] as num).toDouble(),
      status: json['status'],
      accepte_la_livraison: json['accepte_la_livraison'],
      code_commande: json['code_commande'],
    );
  }

  // Méthode pour convertir en JSON
  Map<String, dynamic> toJson() {
    return {
      'commande_id': commande_id,
      'utilisateur_id': utilisateur_id,
      'nom_utilisateur': nom_utilisateur,
      'date_commande': date_commande,
      'montant_total': montant_total,
      'status': status,
      'accepte_la_livraison': accepte_la_livraison,
      'code_commande': code_commande,
    };
  }
}

class AddPanierModel {
  String? panier_utilisateur_id;
  String? produit_id;
  String? utilisateur_id;
  int? quantite;
  String? photo_cover;
  String? prix_produit_id;

  AddPanierModel({
    this.panier_utilisateur_id,
    this.produit_id,
    this.utilisateur_id,
    this.quantite,
    this.photo_cover,
    this.prix_produit_id,
  });
}

class DiscussionModel {
  String img;
  String time;
  String msg;
  int pending;
  String sender;
  bool isCommande;

  DiscussionModel({
    required this.sender,
    required this.isCommande,
    required this.img,
    required this.time,
    required this.pending,
    required this.msg,
  });
}

class FilterModel {
  int? id;
  String? label;

  FilterModel({this.id, this.label});
}

class FilterModelGroup {
  List<FilterModel> list;

  FilterModelGroup({required this.list});
}

class MainCategorieModel {
  String? main_categorie_id;
  String? nom_main_categorie;

  MainCategorieModel({this.main_categorie_id, this.nom_main_categorie});
}

class MessageModel {
  String img;
  String time;
  String msg;
  bool isPending;
  String user;
  bool inbox;

  MessageModel({
    required this.user,
    required this.img,
    required this.inbox,
    required this.time,
    required this.isPending,
    required this.msg,
  });
}

class ProduitCouleurModel {
  String? couleur_id;
  Color? code_couleur;
  String? nom_couleur;
  ProduitCouleurModel({this.couleur_id, this.code_couleur, this.nom_couleur});
}

class ProduitTailleModel {
  String? taille_id;
  String? code_taille;
  String? nom_taille;
  ProduitTailleModel({this.taille_id, this.code_taille, this.nom_taille});
}

class GalleryProduitModel {
  int? produit_gallery_id;
  String? url_image;

  GalleryProduitModel({
    required this.produit_gallery_id,
    required this.url_image,
  });
}

class ProduitAvisModel {
  String? commentaire;
  String? nom_couleur;
  String? code_taille;
  List<ImageModel> images;
  int? note;
  int? produit_avis_id;
  String? nom_utilisateur;
  int? est_verifie;
  int? utilisateur_id;

  ProduitAvisModel({
    this.commentaire,
    this.note,
    required this.images,
    this.nom_couleur,
    this.code_taille,
    this.est_verifie,
    this.produit_avis_id,
    this.utilisateur_id,
    this.nom_utilisateur,
  });
}

class ImageModel {
  String? url;
  ImageModel({this.url});
}

class ProduitCaracteristiqueModel {
  String? caracteristique_id;
  String? contenu;
  String? est_un_argument_de_vente;
  String? caracteristique;

  ProduitCaracteristiqueModel({
    this.caracteristique_id,
    this.contenu,
    this.est_un_argument_de_vente,
    this.caracteristique,
  });
}

class ProduitStatsModel {
  int? totaux_avis;
  int? effectif_par_element;
  int? percentage;
  String? nom_type_avis;

  ProduitStatsModel({
    this.totaux_avis,
    this.nom_type_avis,
    this.percentage,
    this.effectif_par_element,
  });
}

// ignore_for_file: non_constant_identifier_names

class ProduitModel {
  String? nom;
  String? url_image;
  String? status;
  String? description;
  bool? est_en_promo;
  double? taux_reduction;
  double? prix_promo;
  double? prix_minimum;
  String? cree_le;
  String? date_fin;
  String? fournisseur_id;
  String? nom_fournisseur;
  String? produit_id;
  String? prix_produit_id;

  ProduitModel({
    this.nom,
    this.url_image,
    this.status,
    this.description,
    this.est_en_promo,
    this.taux_reduction,
    this.prix_promo,
    this.prix_minimum,
    this.cree_le,
    this.date_fin,
    this.fournisseur_id,
    this.nom_fournisseur,
    this.produit_id,
    this.prix_produit_id,
  });

  // Factory pour convertir le JSON en objet ProduitModel
  factory ProduitModel.fromJson(Map<String, dynamic> json) {
    return ProduitModel(
      nom: json['nom'],
      url_image: json['url_image'],
      status: json['status'],
      description: json['description'],
      est_en_promo: json['est_en_promo'],
      taux_reduction: (json['taux_reduction'] as num?)?.toDouble(),
      prix_promo: (json['prix_promo'] as num?)?.toDouble(),
      prix_minimum: (json['prix_minimum'] as num?)?.toDouble(),
      cree_le: json['cree_le'],
      date_fin: json['date_fin'],
      fournisseur_id: json['fournisseur_id'],
      nom_fournisseur: json['nom_fournisseur'],
      produit_id: json['produit_id'],
    );
  }

  // Méthode pour convertir l’objet en JSON (utile pour envoi API)
  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'url_image': url_image,
      'status': status,
      'description': description,
      'est_en_promo': est_en_promo,
      'taux_reduction': taux_reduction,
      'prix_promo': prix_promo,
      'prix_minimum': prix_minimum,
      'cree_le': cree_le,
      'date_fin': date_fin,
      'fournisseur_id': fournisseur_id,
      'nom_fournisseur': nom_fournisseur,
      'produit_id': produit_id,
    };
  }
}

class TailleProduitModel {
  String? code_taille;
  String? nom_taille;
  int? taille_id;

  TailleProduitModel({this.code_taille, this.nom_taille, this.taille_id});
}

class TypeProduit {
  String? title;
  String? subtitle;

  TypeProduit({this.title, this.subtitle});
}

class SelectedAttribut {
  final int attributs_produit_caracteristiques_id;
  final int attributs_produit_id;

  SelectedAttribut({
    required this.attributs_produit_caracteristiques_id,
    required this.attributs_produit_id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SelectedAttribut &&
        other.attributs_produit_caracteristiques_id ==
            attributs_produit_caracteristiques_id &&
        other.attributs_produit_id == attributs_produit_id;
  }

  @override
  int get hashCode =>
      attributs_produit_caracteristiques_id.hashCode ^
      attributs_produit_id.hashCode;
}
