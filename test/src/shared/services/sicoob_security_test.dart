import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pix_sicoob/src/error/pix_error.dart';
import 'package:pix_sicoob/src/services/client_security.dart';
import 'package:pix_sicoob/src/services/sicoob_security.dart';

void main() {
  late ClientSecurity sicoobSecurity;
  late String certificateBase64String;
  const certificatePassword = '1234';

  setUp(() {
    sicoobSecurity = SicoobSecurity();
    certificateBase64String = sicoobSecurity.certFileToBase64String(
      pkcs12CertificateFile: File('test/cert/cert_for_test.pfx'),
    );
  });

  group('Security Context: ', () {
    test('A Conversao do certificado deve retornar uma String', () {
      // Verifica se o resultado foi o esperado
      expect(certificateBase64String, isA<String>());
    });
    test('O Metodo deve retornar um Security Context', () {
      final result = sicoobSecurity.getContext(
        certificateBase64String: certificateBase64String,
        certificatePassword: certificatePassword,
      );
      final securityContext = result.getOrThrow();
      expect(securityContext, isA<SecurityContext>());
    });

    test(r'''Caso a senha do certificado esteja incorreta:
    Deverá retornar um PixError do tipo: incorrectCertificatePassword''', () {
      // Executa o método que está sendo testado
      final response = sicoobSecurity.getContext(
        certificateBase64String: certificateBase64String,
        certificatePassword: '123',
      );

      // Verifica se o resultado foi o esperado
      final result = response.exceptionOrNull();
      expect(result, isA<PixError>());
      expect(result!.type, equals(PixErrorType.incorrectCertificatePassword));
    });

    test(r'''Caso o certificado seja invalido:
    Deverá retornar um PixError do tipo: invalidPkcs12Certificate''', () {
      // Executa o método que está sendo testado
      final response = sicoobSecurity.getContext(
        certificateBase64String: '${certificateBase64String}1123',
        certificatePassword: '1234',
      );

      // Verifica se o resultado foi o esperado
      final result = response.exceptionOrNull();
      expect(result, isA<PixError>());
      expect(result!.type, equals(PixErrorType.invalidPkcs12Certificate));
    });

    test(r'O metodo deve retornar uma uma lista de Bytes Uint8List', () {
      // Executa o método que está sendo testado
      final response = sicoobSecurity.certificateStringToBytes(
        certificateBase64String,
      );

      // Verifica se o resultado foi o esperado
      final result = response.getOrThrow();
      expect(result, isA<Uint8List>());
      expect(result, isNotEmpty);
    });

    test(r'''Caso o certificado em base64String seja invalido:
    Deverá retornar um PixError do tipo: invalidCertificateBase64String''', () {
      // Executa o método que está sendo testado
      final response = sicoobSecurity.certificateStringToBytes(
        '$certificateBase64String unk',
      );

      // Verifica se o resultado foi o esperado
      final result = response.exceptionOrNull();
      expect(result, isA<PixError>());
      expect(result!.type, equals(PixErrorType.invalidCertificateBase64String));
    });
  });
}
