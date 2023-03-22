// This package provides an abstract class for client authentication and security using certificates.
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:result_dart/result_dart.dart';

import '../error/pix_error.dart';

abstract class ClientSecurity {
  /// Returns a [SecurityContext] object for secure communication with a server,
  /// given a base64-encoded certificate string and its password.
  ///
  /// Throws a [PixError] if the certificate is invalid or the password is incorrect.
  Result<SecurityContext, PixError> getContext({
    required String certificateBase64String,
    required String certificatePassword,
  });

  /// Reads a PKCS12 certificate file from [pkcs12CertificateFile] and returns its
  /// base64-encoded string representation, for use in secure communication.
  ///
  /// Throws a [PixError] if the file is not found, is not a valid PKCS12 file,
  /// or cannot be read for any reason.
  String certFileToBase64String({required File pkcs12CertificateFile});

  /// Converts a base64-encoded certificate string to a byte array, for use in secure communication.
  ///
  /// Returns a [Uint8List] object that contains the byte array, or a [PixError] if the string is invalid.
  Result<Uint8List, PixError> certificateStringToBytes(
    String certificateBase64String,
  );
}
