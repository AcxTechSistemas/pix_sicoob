import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';

enum UnknownExceptionType {
  unknown,
}

/// An exception that represents an unknown error in the Pix Sicoob API.
///
/// This exception can be used to wrap any kind of error that cannot be classified
/// into any of the other types of exceptions in this library. It holds an [_error]
/// object that can be of any type, and an [_type] that is always [UnknownExceptionType.unknown].
class SicoobUnknownException implements PixException {
  final dynamic _error;

  final UnknownExceptionType _type;

  /// Creates a new [SicoobUnknownException] with the given [_error] object and [_type].
  const SicoobUnknownException({
    required dynamic error,
    required UnknownExceptionType type,
  })  : _error = error,
        _type = type;

  /// The error message returned.
  @override
  dynamic get message => _error;

  /// The type of exception, which in this case is always [UnknownExceptionType.unknown].
  @override
  Enum get exceptionType => _type;

  /// Creates a new [PixException] from the given [e] object, wrapping it in a
  /// [SicoobUnknownException] with [_error] equal to [e.toString()] and [_type]
  /// equal to [UnknownExceptionType.unknown].
  static PixException unknownException(dynamic e) {
    return SicoobUnknownException(
      error: e.toString(),
      type: UnknownExceptionType.unknown,
    );
  }
}
