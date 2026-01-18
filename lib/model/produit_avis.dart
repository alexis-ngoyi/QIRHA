// ignore_for_file: non_constant_identifier_names

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

  ProduitAvisModel(
      {this.commentaire,
      this.note,
      required this.images,
      this.nom_couleur,
      this.code_taille,
      this.est_verifie,
      this.produit_avis_id,
      this.utilisateur_id,
      this.nom_utilisateur});
}

class ImageModel {
  String? url;
  ImageModel({this.url});
}
