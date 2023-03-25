// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
import 'package:pix_sicoob/src/errors/sicoob_unknown_exception.dart';

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
  static PixException pathNotFoundException(
      PathNotFoundException pathNotFoundException) {
    return SicoobCertificateException(
      error: 'CERTIFICATE_FILE_PATH_NOT_FOUND',
      type: CertificateExceptionType.certificateFilePathNotFound,
    );
  }
}

/// The possible types of exceptions related to Sicoob certificates
enum CertificateExceptionType {
  incorrectCertificatePassword,
  invalidPkcs12Certificate,
  invalidCertificateBase64String,
  certificateFilePathNotFound,
}
