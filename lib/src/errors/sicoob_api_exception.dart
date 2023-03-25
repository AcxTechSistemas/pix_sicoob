// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';

enum ApiExceptionType {
  clientIDCannotBeEmpty,
  unknown,
}

/// An exception representing an error response from the Sicoob API.
class SicoobApiException implements PixException {
  final String _error;

  final Map<String, dynamic> _errorData;

  final ApiExceptionType _type;

  SicoobApiException({
    required String error,
    required Map<String, dynamic> errorData,
    required ApiExceptionType type,
  })  : _error = error,
        _errorData = errorData,
        _type = type;

  /// The error message returned by the API.
  @override
  dynamic get message => _error;

  /// The error data returned by the API.
  Map<String, dynamic> get errorData => _errorData;

  /// The type of exception, which in this case is always [ApiErrorType.apiErrorType].
  @override
  Enum get exceptionType => _type;

  /// Creates a new [PixException] instance for an API error with the given [error].
  static PixException apiError(Map<String, dynamic> errorMap) {
    String errorMessage = 'uncaughtMessage';
    if (errorMap.containsKey('message')) {
      errorMessage = errorMap['message'];
      if (errorMessage.contains('ClientID cannot be empty')) {
        return SicoobApiException(
          error: 'ClientID está vazio ou não definido',
          errorData: errorMap,
          type: ApiExceptionType.clientIDCannotBeEmpty,
        );
      }
    }

    return SicoobApiException(
      error: errorMessage,
      errorData: errorMap,
      type: ApiExceptionType.unknown,
    );
  }

  @override
  String toString() => '''
SicoobApiException:
      error: $_error,
      errorData: $_errorData,
      type: $_type''';
}
