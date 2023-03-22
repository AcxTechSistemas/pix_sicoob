import 'dart:io';
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

  test('A Conversao do certificado deve retornar uma String', () {
    // Verifica se o resultado foi o esperado
    expect(certificateBase64String, isA<String>());
  });

  group('SecurityContext', () {
    test('O Metodo deve retornar um Security Context', () {
      final result = sicoobSecurity.getContext(
        certificateBase64String: certificateBase64String,
        certificatePassword: certificatePassword,
      );
      final securityContext = result.getOrThrow();
      expect(securityContext, isA<SecurityContext>());
    });

    test('Deve retornar um PixError se a senha for inválida', () {
      // Executa o método que está sendo testado
      final response = sicoobSecurity.getContext(
        certificateBase64String: certificateBase64String,
        certificatePassword: '123',
      );

      // Verifica se o resultado foi o esperado
      final result = response.exceptionOrNull();
      expect(result, isA<PixError>());
      expect(result!.message, isNotNull);
      expect(result.message.values, contains('incorrect_certificate_password'));
    });

    test('Deve retornar um PixError se o certificado for inválido', () {
      // Executa o método que está sendo testado
      final response = sicoobSecurity.getContext(
        certificateBase64String: '${certificateBase64String}1123',
        certificatePassword: '1234',
      );

      // Verifica se o resultado foi o esperado
      final result = response.exceptionOrNull();
      expect(result, isA<PixError>());
      expect(result!.message, isNotNull);
      expect(result.message.values, contains('invalid_pkcs12_certificate'));
    });
  });
}
