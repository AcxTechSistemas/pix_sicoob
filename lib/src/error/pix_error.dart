enum PixErrorType {
  incorrectCertificatePassword,
  invalidPkcs12Certificate,
  invalidCertificateBase64String,
  unknown,
}

class PixError implements Exception {
  final PixErrorType? type;

  dynamic error;

  Map<String, dynamic>? data;

  PixError(
    this.error, [
    this.type,
    this.data,
  ]);

  String get message => error;

  Map<String, dynamic>? get errorData => data;

  @override
  String toString() => 'PixError(error: $message)';
}
