// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
import 'package:pix_sicoob/src/errors/sicoob_unknown_exception.dart';

/// Exception thrown when an error occurs with the certificate used for Pix
class SicoobCertificateException implements PixException {
  final String _error;

  final Map<String, dynamic>? _errorData;

  SicoobCertificateException({
    required String error,
    required Map<String, dynamic>? errorData,
  })  : _error = error,
        _errorData = errorData;

  @override
  dynamic get message => _error;

  @override
  Map<String, dynamic>? get errorData => _errorData;

  /// Creates a new [SicoobCertificateException] based on a [TlsException]
  static PixException tlsException(TlsException tlsException) {
    final osErrorMessage = tlsException.osError?.message ?? '';
    if (osErrorMessage.contains('INCORRECT_PASSWORD')) {
      return PixException(
        error: 'A Senha do certificado está incorreta',
        errorData: {'error': 'the-certificate-password-is-incorrect'},
      );
    } else if (osErrorMessage.contains('BAD_PKCS12_DATA')) {
      return PixException(
        error: 'Certificado e inválido',
        errorData: {'error': 'invalid-certificate-file'},
      );
    } else {
      return SicoobUnknownException.unknownException(tlsException);
    }
  }

  /// Creates a new [SicoobCertificateException] based on a [FormatException]
  static PixException formatException(FormatException formatException) {
    return PixException(
      error: 'O Certificado em Base64 String é invalido',
      errorData: {'error': 'invalid-certificate-base64string'},
    );
  }

  /// Creates a new [SicoobCertificateException] based on a [PathNotFoundException]
  static PixException cannotBeEmpty(String error) {
    if (error.contains('Certificate password cannot be empty')) {
      return PixException(
        error: 'A Senha do Certificado está vazia ou não definida',
        errorData: {'error': 'empty-certificate-password'},
      );
    } else if (error.contains('Certificate Base64string cannot be empty')) {
      return PixException(
        error: 'A String em Base64 do Certificado está vazia ou não definida',
        errorData: {'error': 'empty-certificate-base64string'},
      );
    } else {
      return PixException(
        error: 'Unknown error',
        errorData: {'error': error},
      );
    }
  }

  static PixException pathNotFoundException(
      PathNotFoundException pathNotFoundException) {
    return PixException(
      error: 'Não foi possivel encontrar o caminho do certificado',
      errorData: {'error': 'could-not-find-the-certificate-path'},
    );
  }

  @override
  String toString() =>
      'SicoobCertificateException: error: $_error, errorData: $_errorData';
}
