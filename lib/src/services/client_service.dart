// This package provides an abstract class for client service implementation, for making HTTP requests.

import 'package:result_dart/result_dart.dart';

abstract class ClientService {
  /// Sends an HTTP GET request to the specified [uri], with optional [headers] and [queryParameters].
  ///
  /// Returns a [Future] that completes with a [Result] object that contains a map of response data,
  /// or an [Exception] if the request fails.
  Future<Result<Map<String, dynamic>, Exception>> get(
    Uri uri, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  });

  /// Sends an HTTP POST request to the specified [uri], with optional [headers] and [body].
  ///
  /// Returns a [Future] that completes with a [Result] object that contains a map of response data,
  /// or an [Exception] if the request fails.
  Future<Result<Map<String, dynamic>, Exception>> post(
    Uri uri, {
    Map<String, String>? headers,
    dynamic body,
  });
}
