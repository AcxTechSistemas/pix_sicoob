import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:pix_sicoob/src/error/pix_error.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';

class SicoobClient implements ClientService {
  final SecurityContext securityContext;
  late HttpClient httpClient;
  late IOClient ioClient;

  SicoobClient(this.securityContext) {
    httpClient = HttpClient(context: securityContext);
    ioClient = IOClient(httpClient);
  }

  @override
  Future<Result<Map<String, dynamic>, PixError>> get(
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
      return Failure(PixError(e.toString(), PixErrorType.networkError));
    }
  }

  @override
  Future<Result<Map<String, dynamic>, PixError>> post(
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
      return Failure(PixError(e.toString(), PixErrorType.networkError));
    }
  }
}
