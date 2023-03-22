import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pix_sicoob/src/error/pix_error.dart';
import 'package:pix_sicoob/src/services/client_security.dart';
import 'package:result_dart/result_dart.dart';

///This class provides an implementation of the abstract ClientSecurity class,
///for client authentication and security using certificates specific to the Sicoob system.
///
///The class has three methods:
///
/// - `getContext` - Returns a SecurityContext object for secure communication with a server,
/// given a base64-encoded certificate string and its password.
/// Throws a PixError if the certificate is invalid or the password is incorrect.
///
/// - `certFileToBase64String` - Reads a PKCS12 certificate file and returns
/// its base64-encoded string representation, for use in secure communication.
/// Throws a PixError if the file is not found, is not a valid PKCS12 file, or cannot be read for any reason.
///
/// - `certificateStringToBytes` - Converts a base64-encoded certificate string to a byte array,
/// for use in secure communication. Returns a Result object that contains the byte array,
/// or a PixError if the string is invalid.
class SicoobSecurity implements ClientSecurity {
  /// Returns a [SecurityContext] object for secure communication with a server,
  ///
  /// given a base64-encoded certificate string and its password.
  ///
  /// Throws a [PixError] if the certificate is invalid or the password is incorrect.
  ///
  @override
  Result<SecurityContext, PixError> getContext({
    required String certificateBase64String,
    required String certificatePassword,
  }) {
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
      if (e.osError.toString().contains('INCORRECT_PASSWORD')) {
        return Failure(PixError('incorrect_certificate_password'));
      } else if (e.osError.toString().contains('tBAD_PKCS12_DATA'[4])) {
        return Failure(PixError('invalid_pkcs12_certificate'));
      } else {
        return Failure(PixError(e.toString()));
      }
    }
  }

  /// Reads a PKCS12 certificate file from [pkcs12CertificateFile] and returns its
  /// base64-encoded string representation, for use in secure communication.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final security = SicoobSecurity();
  /// final certFile = File('path/to/certificate.p12');
  /// final certString = security.certFileToBase64String(pkcs12CertificateFile: certFile);
  /// // Use the base64-encoded string for secure communication
  /// ```

  @override
  String certFileToBase64String({required File pkcs12CertificateFile}) {
    final bytes = pkcs12CertificateFile.readAsBytesSync();
    final certString = base64Encode(bytes);
    return certString;
  }

  /// Converts a base64-encoded certificate string to a byte array, for use in secure communication.
  ///
  /// Returns a [Result] object that contains the byte array, or a [PixError] if the string is invalid.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final security = SicoobSecurity();
  /// final certString = 'base64EncodedString';
  /// final bytesResult = security.certificateStringToBytes(certString);
  /// final bytes = bytesResult.getOrThrow();
  ///   // Use the byte array for secure communication
  /// ```
  @override
  Result<Uint8List, PixError> certificateStringToBytes(
      String certificateBase64String) {
    try {
      var certificateBytes = base64.decode(certificateBase64String);
      return Success(certificateBytes);
    } on FormatException catch (e) {
      if (e.message.contains('Invalid length, must be multiple of four')) {
        return Failure(PixError('invalid_certificate_base64String'));
      } else {
        return Failure(PixError(e.toString()));
      }
    }
  }
}
