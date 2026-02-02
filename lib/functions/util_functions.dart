// ignore_for_file: unused_element

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qirha/res/colors.dart';

String formatMoney(String money) {
  double amount = double.parse(money);

  NumberFormat currencyFormat = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: 'XAF',
  );

  // Format the number as currency
  String formattedAmount = currencyFormat.format(amount);

  return formattedAmount;
}

double? parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

// Format prix

String promoPrix(prix, taux) {
  prix = double.parse(prix.toString());
  taux = double.parse(taux.toString());
  return '${prix - (prix * taux / 100)}';
}

String _twoDigits(int n) {
  if (n >= 10) {
    return "$n";
  }
  return "0$n";
}

getFullDateString() {
  DateTime now = DateTime.now();
  return '${now.day}/${_twoDigits(now.month)}/${_twoDigits(now.year)} ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';
}

String statusCommande(String status) {
  switch (status) {
    case "1":
      return "Validée";

    case "2":
      return "Annulée";

    case "3":
      return "En attente";

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

Color formatColor(String originalHexCode) {
  // Convert hexadecimal color code to Color
  Color color = Color(int.parse(originalHexCode.replaceAll("#", "0x")));

  // Extract RGB values
  int red = color.red;
  int green = color.green;
  int blue = color.blue;

  return Color.fromARGB(255, red, green, blue);
}

void downloadFile(String url) async {
  Dio dio = Dio();
  try {
    var dir = await getTemporaryDirectory();
    String savePath = "${dir.path}/downloaded_file.pdf";

    await dio.download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print("${(received / total * 100).toStringAsFixed(0)}%");
        }
      },
    );

    print("Download complete");
  } catch (e) {
    print("Error during download: $e");
  }
}

String _formatDouble(double value) {
  //this also rounds (so 0.8999999999999999 becomes '0.9000')
  var verbose = value.toStringAsFixed(4);
  var trimmed = verbose;
  //trim all trailing 0's after the decimal point (and the decimal point if applicable)
  for (var i = verbose.length - 1; i > 0; i--) {
    if (trimmed[i] != '0' && trimmed[i] != '.' || !trimmed.contains('.')) {
      break;
    }
    trimmed = trimmed.substring(0, i);
  }
  return trimmed;
}
