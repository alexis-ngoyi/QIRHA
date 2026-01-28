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
