// ignore_for_file: non_constant_identifier_names

class ProduitModel {
  String? img;
  String? libelle;
  String? reduction;
  String? prix;
  String? taux;
  String? produit_id;
  String? description;
  String? prix_promo;
  String? quantite_en_stock;
  String? cree_le;
  bool? isReduction;
  String? date_fin;
  ProduitModel({
    this.img,
    this.libelle,
    this.prix,
    this.reduction,
    this.taux,
    this.produit_id,
    this.description,
    this.isReduction,
    this.prix_promo,
    this.quantite_en_stock,
    this.cree_le,
    this.date_fin,
  });
}
