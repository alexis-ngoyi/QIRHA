// Format prix

String promoPrix(prix, taux) {
  prix = double.parse(prix.toString());
  taux = double.parse(taux.toString());
  return '${prix - (prix * taux / 100)}';
}
