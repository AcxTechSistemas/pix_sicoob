import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';

enum ApiErrorType {
  apiErrorType,
}

/// An exception representing an error response from the Sicoob API.
class SicoobApiException implements PixException {
  final Map<String, dynamic> _error;

  final ApiErrorType _type;

  SicoobApiException({
    required Map<String, dynamic> error,
    required ApiErrorType type,
  })  : _error = error,
        _type = type;

  /// The error message returned by the API.
  @override
  dynamic get message => _error;

  /// The type of exception, which in this case is always [ApiErrorType.apiErrorType].
  @override
  Enum get exceptionType => _type;

  /// Creates a new [PixException] instance for an API error with the given [error].
  static PixException apiError(Map<String, dynamic> error) {
    return SicoobApiException(error: error, type: ApiErrorType.apiErrorType);
  }
}
