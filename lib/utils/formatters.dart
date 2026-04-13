import 'package:intl/intl.dart';

String formatCurrency(double amount, {String symbol = '¥'}) {
  final formatter = NumberFormat.currency(
    locale: 'zh_CN',
    symbol: symbol,
    decimalDigits: amount % 1 == 0 ? 0 : 2,
  );
  return formatter.format(amount);
}

String formatDateTime(DateTime dateTime) {
  return DateFormat('MM-dd HH:mm').format(dateTime);
}

String formatDateOnly(DateTime dateTime) {
  return DateFormat('yyyy-MM-dd').format(dateTime);
}
