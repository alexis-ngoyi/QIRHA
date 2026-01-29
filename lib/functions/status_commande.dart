import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qirha/res/colors.dart';

String statusCommande(String status) {
  switch (status) {
    case "1":
      return "Validée";

    case "2":
      return "Supprimée";

    case "3":
      return "En attente de paiement";

    case "4":
      return "Expediée";

    case "5":
      return "Non payée";

    case "6":
      return "En preparation de livraison";

    default:
      return "Non defini";
  }
}

Color statusCommandeColor(String status) {
  switch (status) {
    case "1":
      return GREEN;

    case "2":
      return DANGER;

    case "3":
      return PRIMARY;

    case "4":
      return GREEN;

    case "5":
      return DANGER;

    case "6":
      return PRIMARY;

    default:
      return DARK;
  }
}

HeroIcons statusCommandeIcon(String status) {
  switch (status) {
    case "1":
      return HeroIcons.checkBadge;

    case "2":
      return HeroIcons.trash;

    case "3":
      return HeroIcons.clock;

    case "4":
      return HeroIcons.arrowRightOnRectangle;

    case "5":
      return HeroIcons.banknotes;

    case "6":
      return HeroIcons.adjustmentsVertical;

    default:
      return HeroIcons.exclamationTriangle;
  }
}
