import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';

/// An exception representing an error response from the Sicoob API.
class SicoobApiException implements PixException {
  final String _error;

  final Map<String, dynamic> _errorData;

  SicoobApiException({
    required String error,
    required Map<String, dynamic> errorData,
  })  : _error = error,
        _errorData = errorData;

  /// The error message returned by the API.
  @override
  dynamic get message => _error;

  /// The error data returned by the API.
  @override
  Map<String, dynamic> get errorData => _errorData;

  /// Creates a new [PixException] instance for an API error with the given [error].
  static PixException apiError(Map<String, dynamic> errorMap) {
    String errorMessage = 'sicoobApiError';
    if (errorMap.containsKey('error')) {
      errorMessage = errorMap['error'];
    } else if (errorMap.containsKey('message')) {
      errorMessage = errorMap['message'];
      if (errorMessage.contains('client-id-cannot-be-empty')) {
        return SicoobApiException(
          error: 'ClientID está vazio ou não definido',
          errorData: errorMap,
        );
      }
    }

    return SicoobApiException(
      error: errorMessage,
      errorData: errorMap,
    );
  }

  @override
  String toString() =>
      'SicoobApiException: error: $_error,  errorData: $_errorData';
}
