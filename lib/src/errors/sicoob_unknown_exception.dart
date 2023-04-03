// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';

/// An exception that represents an unknown error in the Pix Sicoob API.
///
/// This exception can be used to wrap any kind of error that cannot be classified
class SicoobUnknownException implements PixException {
  final dynamic _error;

  final Map<String, dynamic> _errorData;

  /// Creates a new [SicoobUnknownException] with the given [_error] object and [_errorData].
  const SicoobUnknownException({
    required dynamic error,
    required Map<String, dynamic> errorData,
  })  : _error = error,
        _errorData = errorData;

  /// The error message returned.
  @override
  dynamic get message => _error;

  /// The data of exception
  @override
  Map<String, dynamic> get errorData => _errorData;

  /// Creates a new [PixException] from the given [e] object, wrapping it in a
  static PixException unknownException(dynamic e) {
    return SicoobUnknownException(
      error: 'Unknown Error',
      errorData: {'error': '$e'},
    );
  }

  @override
  String toString() =>
      'SicoobUnknownException: error: $_error, errorData: $_errorData';
}
