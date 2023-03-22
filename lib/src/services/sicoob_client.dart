// This class implements a client service using the Sicoob API, with client authentication and security using certificates.

import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';

class SicoobClient implements ClientService {
  /// Inject a [SecurityContext] with a valid pkcs12 certificate
  final SecurityContext securityContext;
  late HttpClient httpClient;
  late IOClient ioClient;

  /// Constructs a new instance of [SicoobClient] with the given [securityContext].
  ///
  /// Creates an [HttpClient] instance with the given [securityContext], and an [IOClient] instance
  /// using that [httpClient].
  SicoobClient(this.securityContext) {
    httpClient = HttpClient(context: securityContext);
    ioClient = IOClient(httpClient);
  }

  /// Sends an HTTP GET request to the specified [uri], with optional [headers] and [queryParameters].
  ///
  /// Returns a [Future] that completes with a [Result] object that contains a map of response data,
  /// or an [Exception] if the request fails.
  @override
  Future<Result<Map<String, dynamic>, Exception>> get(
    Uri uri, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final getUri = uri.replace(queryParameters: queryParameters);
      final response = await ioClient.get(
        getUri,
        headers: headers,
      );
      var jsonBody = jsonDecode(response.body);
      return Success(jsonBody);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  /// Sends an HTTP POST request to the specified [uri], with optional [headers] and [body].
  ///
  /// Returns a [Future] that completes with a [Result] object that contains a map of response data,
  /// or an [Exception] if the request fails.
  @override
  Future<Result<Map<String, dynamic>, Exception>> post(
    Uri uri, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    try {
      final response = await ioClient.post(
        uri,
        headers: headers,
        body: body,
      );
      var jsonBody = jsonDecode(response.body);
      return Success(jsonBody);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
