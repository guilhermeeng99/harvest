import 'package:intl/intl.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static final _formatter = NumberFormat.currency(
    symbol: r'$',
    decimalDigits: 2,
  );

  static String format(double amount) => _formatter.format(amount);

  static String formatCompact(double amount) {
    if (amount >= 1000) {
      return NumberFormat.compactCurrency(symbol: r'$').format(amount);
    }
    return format(amount);
  }
}
