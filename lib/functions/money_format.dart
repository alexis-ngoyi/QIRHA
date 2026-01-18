import 'package:intl/intl.dart';

String formatMoney(String money) {
  double amount = double.parse(money);

  NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'fr_FR', symbol: 'XAF');

  // Format the number as currency
  String formattedAmount = currencyFormat.format(amount);

  return formattedAmount;
}
