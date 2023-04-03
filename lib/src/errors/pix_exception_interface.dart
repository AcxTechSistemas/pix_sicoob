/// The base class for all exceptions related to the Pix feature.
abstract class PixException implements Exception {
  /// The error that caused the exception.
  final String _error;

  /// The data of the exception.
  final String _errorDescription;

  /// Creates a new instance of the [PixException] class with the given error
  /// and exception data.
  PixException({
    required String errorDescription,
    required String error,
  })  : _error = error,
        _errorDescription = errorDescription;

  /// Gets the error message associated with this exception.
  String get error => _error;

  /// Gets the information of this exception.
  String? get errorDescription => _errorDescription;

  /// Returns a string representation of this exception.
  @override
  String toString() =>
      'PixError(error: $error errorDescription:$errorDescription)';
}
