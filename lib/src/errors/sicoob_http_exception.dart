import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';

/// Exception thrown when an HTTP request fails.
class SicoobHttpException implements PixException {
  final String _error;

  final String _errorDescription;

  SicoobHttpException({
    required String error,
    required String errorDescription,
  })  : _error = error,
        _errorDescription = errorDescription;

  @override
  String get error => _error;

  @override
  String get errorDescription => _errorDescription;

  /// Factory method for creating an instance of [SicoobHttpException].
  ///
  /// [exception] is the underlying exception that caused the HTTP request to fail.
  static PixException httpException(Object exception) {
    return SicoobHttpException(
      error: 'network-error',
      errorDescription: exception.toString(),
    );
  }

  @override
  String toString() =>
      'SicoobHttpException: error: $error,  errorData: $errorDescription';
}
