import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
import 'package:result_dart/result_dart.dart';

/// An abstract class that provides methods for client security management.
abstract class ClientSecurity {
  /// Returns a [Result] containing a [SecurityContext] if successful, or a [PixException] if an error occurred.
  ///
  /// The [certificateBase64String] and [certificatePassword] parameters are used to create a [SecurityContext] object that can be used to communicate securely with the server.
  ///
  /// Throws a [PixException] if an error occurred.
  Result<SecurityContext, PixException> getContext({
    required String certificateBase64String,
    required String certificatePassword,
  });

  /// Returns a [Result] containing a base64 encoded certificate string if successful, or a [PixException] if an error occurred.
  ///
  /// The [pkcs12CertificateFile] parameter is used to convert the PKCS12 certificate file to a base64 encoded string.
  ///
  /// Throws a [PixException] if an error occurred.
  Result<String, PixException> certFileToBase64String(
      {required File pkcs12CertificateFile});

  /// Returns a [Result] containing a [Uint8List] of bytes representing the certificate string if successful, or a [PixException] if an error occurred.
  ///
  /// The [certificateBase64String] parameter is used to convert the base64 encoded string to bytes.
  ///
  /// Throws a [PixException] if an error occurred.
  Result<Uint8List, PixException> certificateStringToBytes(
    String certificateBase64String,
  );
}
