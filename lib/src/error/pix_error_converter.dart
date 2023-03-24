import 'dart:io';
import 'package:pix_sicoob/src/error/pix_error.dart';

class PixErrorConverter {
  static PixError certificateException(TlsException tlsException) {
    final osErrorMessage = tlsException.osError?.message ?? '';
    if (osErrorMessage.contains('INCORRECT_PASSWORD')) {
      return PixError(
        'INCORRECT_PASSWORD',
        PixErrorType.incorrectCertificatePassword,
      );
    } else if (osErrorMessage.contains('BAD_PKCS12_DATA')) {
      return PixError(
        'BAD_PKCS12_DATA',
        PixErrorType.invalidPkcs12Certificate,
      );
    } else {
      return unknownError(tlsException);
    }
  }

  static PixError formatException(FormatException formatException) {
    return PixError('INVALID_CERTIFICATE_BASE64STRING',
        PixErrorType.invalidCertificateBase64String);
  }

  static PixError unknownError(dynamic e) {
    return PixError(e, PixErrorType.unknown);
  }
}
