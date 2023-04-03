import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';

/// An exception representing an error response from the Sicoob API.
class SicoobApiException implements PixException {
  final String _error;

  final String _errorDescription;

  SicoobApiException({
    required String error,
    required String errorDescription,
  })  : _error = error,
        _errorDescription = errorDescription;

  /// The error message returned by the API.
  @override
  String get error => _error;

  /// Gets the information of this exception.
  @override
  String get errorDescription => _errorDescription;

  /// Creates a new [PixException] instance for an API error with the given [error].
  static PixException apiError(Map<String, dynamic> errorMap) {
    String error = errorMap['error'] ?? 'uncaughtError';
    String errorDescription =
        errorMap['error_description'] ?? errorMap.toString();

    return SicoobApiException(
      error: error,
      errorDescription: errorDescription,
    );
  }

  @override
  String toString() =>
      'SicoobApiException: error: $error,  errorData: $errorDescription';
}
