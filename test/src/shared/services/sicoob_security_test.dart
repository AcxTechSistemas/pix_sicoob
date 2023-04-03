import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
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
    Deverá retornar uma PixException''', () {
      final response = clientSecurity.getContext(
        certificateBase64String: certificateBase64String,
        certificatePassword: '123',
      );

      final result = response.exceptionOrNull();
      expect(result, isNotNull);
      expect(result!.error, equals('the-certificate-password-is-incorrect'));
      expect(result, isA<PixException>());
    });

    test(r'''Caso o certificado seja invalido:
    Deverá retornar uma PixException''', () {
      final response = clientSecurity.getContext(
        certificateBase64String: '${certificateBase64String}1123',
        certificatePassword: '1234',
      );

      final result = response.exceptionOrNull();
      expect(result, isNotNull);
      expect(result!.error, equals('invalid-certificate-file'));
      expect(result, isA<PixException>());
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
    Deverá retornar uma PixException''', () {
      final response = clientSecurity.certificateStringToBytes(
        '$certificateBase64String unk',
      );

      final result = response.exceptionOrNull();
      expect(result, isNotNull);
      expect(result!.error, equals('invalid-certificate-base64string'));
      expect(result, isA<PixException>());
    });

    test(r'''Caso certificado não for encontrado:
    Deverá retornar uma PixException''', () {
      final response = clientSecurity.certFileToBase64String(
          pkcs12CertificateFile: File('invalidPath'));
      final result = response.exceptionOrNull();

      expect(result, isNotNull);
      expect(result!.error, equals('could-not-find-the-certificate-path'));
      expect(result, isA<PixException>());
    });
  });
}
