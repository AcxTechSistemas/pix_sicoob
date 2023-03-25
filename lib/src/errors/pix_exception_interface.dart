/// The base class for all exceptions related to the Pix feature.
abstract class PixException implements Exception {
  /// The error that caused the exception.
  final dynamic _error;

  /// The type of the exception.
  final Enum _exceptionType;

  /// Creates a new instance of the [PixException] class with the given error
  /// and exception type.
  PixException({
    required dynamic error,
    required Enum exceptionType,
  })  : _error = error,
        _exceptionType = exceptionType;

  /// Gets the error message associated with this exception.
  dynamic get message => _error;

  /// Gets the type of this exception.
  Enum get exceptionType => _exceptionType;

  /// Returns a string representation of this exception.
  @override
  String toString() => 'PixError(error: $message)';
}
