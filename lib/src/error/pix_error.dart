///A custom exception class for handling errors related to the Pix Sicoob API.

class PixError implements Exception {
  /// The error message or object that caused the exception.
  dynamic error;

  ///Constructs a new PixError object with the given error message or object.
  PixError(this.error);

  /// Returns a map representation of the error message or object.
  /// If the error message is already a Map object, returns it as-is. Otherwise,
  /// creates a new map with a single key-value pair, where the key is "error" and
  /// the value is the string representation of the error message.
  ///
  /// @return A Map object representing the error message or object.
  Map<String, dynamic> get message {
    if (error is Map) {
      return error;
    } else {
      return {'error': error.toString()};
    }
  }

  /// Returns a map representation of the error message or object.
  /// If the error message is already a Map object, returns it as-is. Otherwise,
  /// creates a new map with a single key-value pair, where the key is "error" and
  /// the value is the string representation of the error message.
  ///
  /// @return A Map object representing the error message or object.
  @override
  String toString() => 'PixError(error: $message)';
}
