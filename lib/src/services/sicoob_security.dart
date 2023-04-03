import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pix_sicoob/src/errors/sicoob_certificate_exception.dart';
import 'package:pix_sicoob/src/errors/sicoob_unknown_exception.dart';
import 'package:pix_sicoob/src/services/client_security.dart';
import 'package:result_dart/result_dart.dart';

import '../errors/pix_exception_interface.dart';

/// This class implements the [ClientSecurity] interface and provides methods
/// for managing and retrieving security context and certificates.
class SicoobSecurity implements ClientSecurity {
  /// Returns a [Result] object containing a [SecurityContext] object on success
  /// or a [PixException] on failure. The [SecurityContext] object is created with
  /// the certificate chain and private key extracted from the given certificate
  /// base64 string and password.
  ///
  /// Throws a [SicoobCertificateException] if there is an issue with the certificate,
  /// or a [SicoobUnknownException] for any other type of error.
  @override
  Result<SecurityContext, PixException> getContext({
    required String certificateBase64String,
    required String certificatePassword,
  }) {
    if (certificatePassword.isEmpty) {
      return Failure(SicoobCertificateException.cannotBeEmpty(
        'Certificate password cannot be empty',
      ));
    }
    if (certificateBase64String.isEmpty) {
      return Failure(SicoobCertificateException.cannotBeEmpty(
        'Certificate Base64string cannot be empty',
      ));
    }

    final certificateBytes =
        certificateStringToBytes(certificateBase64String).getOrThrow();

    try {
      final securityContext = SecurityContext.defaultContext
        ..useCertificateChainBytes(
          certificateBytes,
          password: certificatePassword,
        )
        ..usePrivateKeyBytes(
          certificateBytes,
          password: certificatePassword,
        );
      return Success(securityContext);
    } on TlsException catch (e) {
      final error = SicoobCertificateException.tlsException(e);
      return Failure(error);
    } catch (e) {
      final unknownError = SicoobUnknownException.unknownException(e);
      return Failure(unknownError);
    }
  }

  /// Returns a [Result] object containing a base64-encoded string on success or
  /// a [PixException] on failure. The certificate file is read from the given file
  /// path, converted to a byte array, and then encoded as a base64 string.
  ///
  /// Throws a [SicoobCertificateException] if there is an issue with the certificate,
  /// or a [SicoobUnknownException] for any other type of error.
  @override
  Result<String, PixException> certFileToBase64String(
      {required File pkcs12CertificateFile}) {
    try {
      final bytes = pkcs12CertificateFile.readAsBytesSync();
      final certString = base64Encode(bytes);
      return Success(certString);
    } on PathNotFoundException catch (e) {
      final error = SicoobCertificateException.pathNotFoundException(e);
      return Failure(error);
    } catch (e) {
      final unknownError = SicoobUnknownException.unknownException(e);
      return Failure(unknownError);
    }
  }

  /// Returns a [Result] object containing a byte array on success or a [PixException]
  /// on failure. The input is a base64-encoded string that is first decoded into a
  /// byte array.
  ///
  /// Throws a [SicoobCertificateException] if there is an issue with the certificate,
  /// or a [SicoobUnknownException] for any other type of error
  @override
  Result<Uint8List, PixException> certificateStringToBytes(
      String certificateBase64String) {
    try {
      var certificateBytes = base64.decode(certificateBase64String);
      return Success(certificateBytes);
    } on FormatException catch (e) {
      final error = SicoobCertificateException.formatException(e);
      return Failure(error);
    } catch (e) {
      final unknownError = SicoobUnknownException.unknownException(e);
      return Failure(unknownError);
    }
  }
}
