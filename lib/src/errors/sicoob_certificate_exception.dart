// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
import 'package:pix_sicoob/src/errors/sicoob_unknown_exception.dart';

enum CertificateExceptionType {
  incorrectCertificatePassword,
  invalidPkcs12Certificate,
  invalidCertificateBase64String,
  certificateFilePathNotFound,
  certificatePasswordCannotBeEmpty,
  certificateStringCannotBeEmpty,
  unknown,
}

/// Exception thrown when an error occurs with the certificate used for Pix
class SicoobCertificateException implements PixException {
  final String _error;

  final CertificateExceptionType _type;

  SicoobCertificateException({
    required String error,
    required CertificateExceptionType type,
  })  : _error = error,
        _type = type;

  @override
  dynamic get message => _error;

  @override
  Enum get exceptionType => _type;

  /// Creates a new [SicoobCertificateException] based on a [TlsException]
  static PixException tlsException(TlsException tlsException) {
    final osErrorMessage = tlsException.osError?.message ?? '';
    if (osErrorMessage.contains('INCORRECT_PASSWORD')) {
      return SicoobCertificateException(
        error: 'INCORRECT_PASSWORD',
        type: CertificateExceptionType.incorrectCertificatePassword,
      );
    } else if (osErrorMessage.contains('BAD_PKCS12_DATA')) {
      return SicoobCertificateException(
        error: 'BAD_PKCS12_DATA',
        type: CertificateExceptionType.invalidPkcs12Certificate,
      );
    } else {
      return SicoobUnknownException.unknownException(tlsException);
    }
  }

  /// Creates a new [SicoobCertificateException] based on a [FormatException]
  static PixException formatException(FormatException formatException) {
    return SicoobCertificateException(
      error: 'INVALID_CERTIFICATE_BASE64STRING',
      type: CertificateExceptionType.invalidCertificateBase64String,
    );
  }

  /// Creates a new [SicoobCertificateException] based on a [PathNotFoundException]
  static PixException cannotBeEmpty(String error) {
    if (error.contains('Certificate password cannot be empty')) {
      return SicoobCertificateException(
        error: 'A Senha do Certificado está vazia ou não definida',
        type: CertificateExceptionType.certificatePasswordCannotBeEmpty,
      );
    } else if (error.contains('Certificate String cannot be empty')) {
      return SicoobCertificateException(
        error: 'A String do Certificado está vazia ou não definida',
        type: CertificateExceptionType.certificateStringCannotBeEmpty,
      );
    } else {
      return SicoobCertificateException(
        error: error,
        type: CertificateExceptionType.unknown,
      );
    }
  }

  static PixException pathNotFoundException(
      PathNotFoundException pathNotFoundException) {
    return SicoobCertificateException(
      error: 'CERTIFICATE_FILE_PATH_NOT_FOUND',
      type: CertificateExceptionType.certificateFilePathNotFound,
    );
  }

  @override
  String toString() => '''
SicoobCertificateException:
      error: $_error,
      _type: $_type''';
}

/// The possible types of exceptions related to Sicoob certificates
