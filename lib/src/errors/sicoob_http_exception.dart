import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';

/// Exception thrown when an HTTP request fails.
class SicoobHttpException implements PixException {
  final String _error;

  final Map<String, dynamic>? _errorData;

  SicoobHttpException({
    required String error,
    required Map<String, dynamic>? errorData,
  })  : _error = error,
        _errorData = errorData;

  @override
  Map<String, dynamic>? get errorData => _errorData;

  @override
  String get message => _error;

  /// Factory method for creating an instance of [SicoobHttpException].
  ///
  /// [exception] is the underlying exception that caused the HTTP request to fail.
  static PixException httpException(Object exception) {
    return PixException(
      error: exception.toString(),
      errorData: {'error': '$exception'},
    );
  }

  @override
  String toString() =>
      'SicoobHttpException: error: $_error,  errorData: $_errorData';
}
