import 'package:intl/intl.dart';

abstract final class AppDateFormat {
  static final _api = DateFormat('yyyy-MM-dd');
  static final _display = DateFormat('MMM d, yyyy');
  static final _year = DateFormat('yyyy');

  static DateTime? parseApi(String? value) =>
      value == null || value.isEmpty ? null : _api.tryParseStrict(value);

  static String? toApi(DateTime? value) => value == null ? null : _api.format(value);

  static String display(DateTime value) => _display.format(value);

  static String year(DateTime value) => _year.format(value);
}
