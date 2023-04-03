// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
import 'package:pix_sicoob/src/errors/sicoob_unknown_exception.dart';

/// Exception thrown when an error occurs with the certificate used for Pix
class SicoobCertificateException implements PixException {
  final String _error;

  final String _errorDescription;

  SicoobCertificateException({
    required String error,
    required String errorDescription,
  })  : _error = error,
        _errorDescription = errorDescription;

  @override
  String get error => _error;

  @override
  String get errorDescription => _errorDescription;

  /// Creates a new [SicoobCertificateException] based on a [TlsException]
  static PixException tlsException(TlsException tlsException) {
    final osErrorMessage = tlsException.osError?.message ?? '';
    if (osErrorMessage.contains('INCORRECT_PASSWORD')) {
      return SicoobCertificateException(
        error: 'the-certificate-password-is-incorrect',
        errorDescription: 'A Senha do certificado está incorreta',
      );
    } else if (osErrorMessage.contains('BAD_PKCS12_DATA')) {
      return SicoobCertificateException(
        error: 'invalid-certificate-file',
        errorDescription: 'O Arquivo do certificado e inválido',
      );
    } else {
      return SicoobUnknownException.unknownException(tlsException);
    }
  }

  /// Creates a new [SicoobCertificateException] based on a [FormatException]
  static PixException formatException(FormatException formatException) {
    return SicoobCertificateException(
      error: 'invalid-certificate-base64string',
      errorDescription: 'A string base64 do certificado é inválida',
    );
  }

  /// Creates a new [SicoobCertificateException] based on a [PathNotFoundException]
  static PixException cannotBeEmpty(String error) {
    if (error.contains('Certificate password cannot be empty')) {
      return SicoobCertificateException(
        error: 'empty-certificate-password',
        errorDescription: 'A Senha do Certificado está vazia ou não definida',
      );
    } else if (error.contains('Certificate Base64string cannot be empty')) {
      return SicoobCertificateException(
        error: 'empty-certificate-base64string',
        errorDescription: 'A string base64 do certificado está vazia',
      );
    } else {
      return SicoobCertificateException(
        error: 'unknown-certificate-error',
        errorDescription: error,
      );
    }
  }

  static PixException pathNotFoundException(
      PathNotFoundException pathNotFoundException) {
    return SicoobCertificateException(
      error: 'could-not-find-the-certificate-path',
      errorDescription: 'O caminho para o certificado não pôde ser encontrado',
    );
  }

  @override
  String toString() =>
      'SicoobCertificateException: error: $error, errorData: $errorDescription';
}
