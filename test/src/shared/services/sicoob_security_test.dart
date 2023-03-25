import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pix_sicoob/src/errors/sicoob_certificate_exception.dart';
import 'package:pix_sicoob/src/services/client_security.dart';
import 'package:pix_sicoob/src/services/sicoob_security.dart';

void main() {
  late ClientSecurity clientSecurity;
  late String certificateBase64String;
  const certificatePassword = '1234';

  setUp(() {
    clientSecurity = SicoobSecurity();
    certificateBase64String = clientSecurity
        .certFileToBase64String(
            pkcs12CertificateFile: File('test/cert/cert_for_test.pfx'))
        .getOrThrow();
  });

  group('Security Context: ', () {
    test('A Conversao do certificado deve retornar uma String', () {
      expect(certificateBase64String, isA<String>());
    });

    test('O Metodo deve retornar um Security Context', () {
      final result = clientSecurity.getContext(
        certificateBase64String: certificateBase64String,
        certificatePassword: certificatePassword,
      );
      final securityContext = result.getOrThrow();
      expect(securityContext, isA<SecurityContext>());
    });

    test(r'''Caso a senha do certificado esteja incorreta:
    Deverá retornar um SicoobCertificateException do tipo: incorrectCertificatePassword''',
        () {
      final response = clientSecurity.getContext(
        certificateBase64String: certificateBase64String,
        certificatePassword: '123',
      );

      final result = response.exceptionOrNull();
      expect(result, isA<SicoobCertificateException>());
      expect(result!.exceptionType,
          equals(CertificateExceptionType.incorrectCertificatePassword));
    });

    test(r'''Caso o certificado seja invalido:
    Deverá retornar um SicoobCertificateException do tipo: invalidPkcs12Certificate''',
        () {
      final response = clientSecurity.getContext(
        certificateBase64String: '${certificateBase64String}1123',
        certificatePassword: '1234',
      );

      final result = response.exceptionOrNull();
      expect(result, isA<SicoobCertificateException>());
      expect(
        result!.exceptionType,
        equals(CertificateExceptionType.invalidPkcs12Certificate),
      );
    });

    test(r'O metodo deve retornar uma uma lista de Bytes Uint8List', () {
      final response = clientSecurity.certificateStringToBytes(
        certificateBase64String,
      );

      final result = response.getOrThrow();
      expect(result, isA<Uint8List>());
      expect(result, isNotEmpty);
    });

    test(r'''Caso o certificado em base64String seja invalido:
    Deverá retornar um SicoobCertificateException do tipo: invalidCertificateBase64String''',
        () {
      final response = clientSecurity.certificateStringToBytes(
        '$certificateBase64String unk',
      );

      final result = response.exceptionOrNull();
      expect(result, isA<SicoobCertificateException>());
      expect(
        result!.exceptionType,
        equals(CertificateExceptionType.invalidCertificateBase64String),
      );
    });

    test(r'''Caso certificado não for encontrado:
    Deverá retornar um SicoobCertificateException do tipo: certificateFilePathNotFound''',
        () {
      final response = clientSecurity.certFileToBase64String(
          pkcs12CertificateFile: File('invalidPath'));
      final result = response.exceptionOrNull();
      expect(result, isA<SicoobCertificateException>());
      expect(
        result!.exceptionType,
        equals(CertificateExceptionType.certificateFilePathNotFound),
      );
    });
  });
}
