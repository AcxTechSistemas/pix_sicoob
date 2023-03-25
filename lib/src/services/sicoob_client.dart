import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
import 'package:pix_sicoob/src/errors/sicoob_http_exception.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';

/// A Sicoob implementation of the [ClientService] interface, which provides methods for making HTTP GET and POST requests.
///
/// This implementation uses an instance of [IOClient] from the `http` package to make HTTP requests with an [HttpClient]
/// configured with a [SecurityContext]. Responses are parsed as JSON and returned as a [Map] of key-value pairs.
///
/// Example usage:
/// ```dart
/// final sicoobClient = SicoobClient(securityContext);
/// final result = await sicoobClient.get(Uri.parse('https://example.com'));
/// if (result.isSuccess) {
///   final responseBody = result.successValue;
///   // process responseBody
/// } else {
///   final exception = result.failureValue;
///   // handle exception
/// }
/// ```
class SicoobClient implements ClientService {
  final SecurityContext securityContext;
  late HttpClient httpClient;
  late IOClient ioClient;

  /// Creates an instance of [SicoobClient] with the specified [securityContext] for making secure HTTP requests.
  ///
  /// The [securityContext] must be initialized with the appropriate certificate and key data for the desired server.
  SicoobClient(this.securityContext) {
    httpClient = HttpClient(context: securityContext);
    ioClient = IOClient(httpClient);
  }

  @override

  /// Sends an HTTP GET request to the specified [uri], with optional [headers] and [queryParameters].
  ///
  /// Returns a [Result] object containing a [Map] of key-value pairs representing the JSON response body if the request is successful.
  /// Otherwise, returns a [Failure] containing a [PixException] indicating the reason for the failure.
  Future<Result<Map<String, dynamic>, PixException>> get(
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
    } catch (e) {
      return Failure(SicoobHttpException.httpException(e));
    }
  }

  @override

  /// Sends an HTTP POST request to the specified [uri], with optional [headers] and [body].
  ///
  /// Returns a [Result] object containing a [Map] of key-value pairs representing the JSON response body if the request is successful.
  /// Otherwise, returns a [Failure] containing a [PixException] indicating the reason for the failure.
  Future<Result<Map<String, dynamic>, PixException>> post(
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
    } catch (e) {
      return Failure(SicoobHttpException.httpException(e));
    }
  }
}
