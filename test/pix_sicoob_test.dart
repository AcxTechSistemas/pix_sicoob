@Skip('''
These tests serve to test the package in production with real credentials,
and should not be tested outside the development environment.
''')
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pix_sicoob/pix_sicoob.dart';
import 'package:pix_sicoob/src/features/token/model/token.dart';

void main() {
  late PixSicoob pixSicoob;
  late String certificateBase64String;
  const certificatePassword = '';
  const clientID = '';

  setUp(() {
    certificateBase64String = PixSicoob.certFileToBase64String(
      pkcs12CertificateFile: File(''),
    );
    pixSicoob = PixSicoob(
      clientID: clientID,
      certificateBase64String: certificateBase64String,
      certificatePassword: certificatePassword,
    );
  });
  test('Metodo getToken deve retornar um Token', () async {
    final token = await pixSicoob.getToken();

    expect(token, isNotNull);
    expect(token.accessToken, isNotNull);
    expect(token, isA<Token>());
  });

  test('Metodo fetchTransactions deve retornar uma  Lista de Pix', () async {
    final token = await pixSicoob.getToken();
    final listPix = await pixSicoob.fetchTransactions(
      token: token,
      dateTimeRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 10)),
        end: DateTime.now(),
      ),
    );
    expect(listPix, isNotNull);
    expect(listPix, isA<List<Pix>>());
    expect(listPix[0], isA<Pix>());
  });

  test('Metodo createBilling deve retornar uma instancia de Billing', () async {
    final token = await pixSicoob.getToken();
    final response = await pixSicoob.createBilling(
      instaBill: InstaBill(
        calendario: Calendario(),
        devedor: Devedor(nome: 'Teste'),
        valor: Valor(original: 9999),
        chave: '+559999999999',
        solicitacaoPagador: 'Teste',
        infoAdicionais: [
          InfoAdicionais(nome: 'teste', valor: 9999),
        ],
      ),
      token: token,
    );
    expect(response.txid, isNotNull);
    expect(response.calendario, isNotNull);
    expect(response.valor.original, isA<double>());
  });
}
