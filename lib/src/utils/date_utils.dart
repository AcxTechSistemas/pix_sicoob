import 'package:intl/intl.dart';

/// Formats a [DateTime] object to ISO 8601 format with time zone information
/// required by the Sicoob Pix API.
///
/// Returns a [String] containing the formatted date string.
String formatToIso8601TimeZone({required DateTime date}) {
  return DateFormat('yyyy-MM-ddTHH:mm:ss.00-03:00').format(date);
}
