import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/models/insta_bill/calendario.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/models/insta_bill/insta_bill.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/models/shared/devedor.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/models/shared/info_adicionais.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/models/shared/valor.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/repository/insta_bill_repository.dart';
import 'package:pix_sicoob/src/features/token/model/token.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';

class MockClientService extends Mock implements ClientService {}

void main() {
  late ClientService client;
  late InstaBillRepository instaBillRepository;
  late InstaBill instaBill;
  late Token token;
  late Uri cobUri;

  setUp(() {
    client = MockClientService();
    instaBillRepository = InstaBillRepository(client);

    cobUri = Uri.parse('https://teste.example.com/cob');
    registerFallbackValue(cobUri);

    instaBill = InstaBill(
      calendario: Calendario(),
      devedor: Devedor(nome: 'Teste'),
      valor: Valor(original: 9999),
      chave: '+5562999999999',
      solicitacaoPagador: 'Teste',
      infoAdicionais: [
        InfoAdicionais(nome: 'teste', valor: 9999),
      ],
    );

    token = Token.fromMap({
      "access_token": "eyJhbGciOiJSUzI1NiIsIn",
      "expires_in": 300,
      "refresh_expires_in": 0,
      "token_type": "Bearer",
      "not-before-policy": 0,
      "scope": "pix.read pix.write"
    });
  });

  test('Deve retornar uma instancia de Billing ao criar uma cobranca imediata',
      () async {
    when(() => client.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        )).thenAnswer(
      (_) async => const Success(expectedResponse),
    );

    final response = await instaBillRepository
        .createBilling(
          cobUri: cobUri,
          instaBill: instaBill,
          token: token,
        )
        .getOrThrow();
    expect(response.txid, isNotNull);
    expect(response.calendario, isNotNull);
    expect(response.infoAdicionais.length, 3);
    expect(response.valor.original, isA<double>());
  });
}

const expectedResponse = {
  "calendario": {
    "criacao": "2023-03-21T23:18:08.857Z",
    "expiracao": 3600,
  },
  "status": "ATIVA",
  "txid": "ABCEASDSA1234567891324",
  "revisao": 0,
  "location":
      "pix.sicoob.com.br/qr/payload/v2/123456789-123456789-qwer-b94a-132456879",
  "devedor": {
    "cpf": "000000000",
    "nome": "Cliente 01",
  },
  "valor": {
    "original": "50.00",
  },
  "chave": "+5562985583962",
  "solicitacaoPagador": "Informar cartao",
  "infoAdicionais": [
    {
      "nome": "Produto",
      "valor": "50.00",
    },
    {
      "nome": "Produto",
      "valor": "50.00",
    },
    {
      "nome": "Produto",
      "valor": "50.00",
    }
  ],
  "brcode": "QRCODE_TESTE"
};
