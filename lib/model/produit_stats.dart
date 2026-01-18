// ignore_for_file: non_constant_identifier_names

class ProduitStatsModel {
  int? totaux_avis;
  int? effectif_par_element;
  int? percentage;
  String? nom_type_avis;

  ProduitStatsModel(
      {this.totaux_avis,
      this.nom_type_avis,
      this.percentage,
      this.effectif_par_element});
}
