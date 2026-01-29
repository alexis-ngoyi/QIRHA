import 'package:intl/intl.dart';

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
