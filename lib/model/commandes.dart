// ignore_for_file: non_constant_identifier_names
class CommandeModel {
  String? date_commande;
  int? commande_id;
  String? montant_total;
  String? status;
  String? nom_utilisateur;
  String? utilisateur_id;
  String accepte_la_livraison;

  CommandeModel(
      {required this.date_commande,
      required this.commande_id,
      required this.montant_total,
      required this.status,
      required this.nom_utilisateur,
      required this.utilisateur_id,
      this.accepte_la_livraison = "0"});
}

class ArticlesCommandeModel {
  String? code_taille;
  String? nom_couleur;
  String? couleur_id;
  String? taille_id;
  String? image_id;
  String? produit_id;
  String? nom_produit;
  String? photo_cover;
  String? prix_unitaire;
  String? quantite;
  String? quantite_en_stock;

  ArticlesCommandeModel(
      {required this.code_taille,
      required this.nom_couleur,
      required this.nom_produit,
      required this.photo_cover,
      required this.prix_unitaire,
      required this.quantite,
      required this.quantite_en_stock,
      required this.couleur_id,
      required this.taille_id,
      required this.produit_id,
      required this.image_id});
}

class AddPanierModel {
  String? taille_id;
  String? couleur_id;
  String? produit_id;
  String? utilisateur_id;
  String? quantite;
  String? image_id;

  AddPanierModel(
      {required this.taille_id,
      required this.couleur_id,
      required this.produit_id,
      required this.utilisateur_id,
      required this.quantite,
      required this.image_id});
}
