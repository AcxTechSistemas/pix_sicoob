/// The base class for all exceptions related to the Pix feature.
abstract class PixException implements Exception {
  /// The error that caused the exception.
  final dynamic _error;

  /// The type of the exception.
  final Map<String, dynamic>? _errorData;

  /// Creates a new instance of the [PixException] class with the given error
  /// and exception type.
  PixException({
    required dynamic error,
    required Map<String, dynamic>? errorData,
  })  : _error = error,
        _errorData = errorData;

  /// Gets the error message associated with this exception.
  dynamic get message => _error;

  /// Gets the information of this exception.
  Map<String, dynamic>? get errorData => _errorData;

  /// Returns a string representation of this exception.
  @override
  String toString() => 'PixError(error: $message errorData:$_errorData)';
}
