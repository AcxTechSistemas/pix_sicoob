import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
import 'package:result_dart/result_dart.dart';

/// This abstract class represents a client service that can perform GET and POST requests
/// and returns a Result object that contains either a Map<String, dynamic> with the response body
/// or a PixException if an error occurs.
abstract class ClientService {
  /// Performs a GET request to the specified [uri] and returns a [Result] object
  /// containing either a [Map<String, dynamic>] with the response body or a [PixException] if an error occurs.
  ///
  /// Optional [headers] and [queryParameters] can be provided for the request.
  Future<Result<Map<String, dynamic>, PixException>> get(
    Uri uri, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  });

  /// Performs a POST request to the specified [uri] and returns a [Result] object
  /// containing either a [Map<String, dynamic>] with the response body or a [PixException] if an error occurs.
  ///
  /// An optional [headers] and [body] can be provided for the request.
  Future<Result<Map<String, dynamic>, PixException>> post(
    Uri uri, {
    Map<String, String>? headers,
    dynamic body,
  });
}
