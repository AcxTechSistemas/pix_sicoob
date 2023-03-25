// ignore_for_file: public_member_api_docs

import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';

enum HttpExceptionType {
  networkError,
}

/// Exception thrown when an HTTP request fails.
class SicoobHttpException implements PixException {
  final String _error;

  final HttpExceptionType _type;

  SicoobHttpException({
    required String error,
    required HttpExceptionType type,
  })  : _error = error,
        _type = type;

  @override
  Enum get exceptionType => _type;

  @override
  String get message => _error;

  /// Factory method for creating an instance of [SicoobHttpException].
  ///
  /// [exception] is the underlying exception that caused the HTTP request to fail.
  static PixException httpException(Object exception) {
    return SicoobHttpException(
      error: exception.toString(),
      type: HttpExceptionType.networkError,
    );
  }
}
