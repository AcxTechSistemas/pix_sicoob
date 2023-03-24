import 'package:result_dart/result_dart.dart';

import '../error/pix_error.dart';

abstract class ClientService {
  Future<Result<Map<String, dynamic>, PixError>> get(
    Uri uri, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  });

  Future<Result<Map<String, dynamic>, PixError>> post(
    Uri uri, {
    Map<String, String>? headers,
    dynamic body,
  });
}
