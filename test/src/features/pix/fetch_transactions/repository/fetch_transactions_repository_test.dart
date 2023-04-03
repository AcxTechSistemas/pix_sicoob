import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix_sicoob/src/errors/sicoob_api_exception.dart';
import 'package:pix_sicoob/src/features/pix/fetch_transactions/repository/fetch_transactions_repository.dart';
import 'package:pix_sicoob/src/features/token/model/token.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';

class _MockClientService extends Mock implements ClientService {}

void main() {
  late ClientService client;
  late FetchTransactionsRepository fetchRepository;
  late Uri uri;
  late Token token;
  const clientID = 'client-id';
  setUp(() {
    client = _MockClientService();
    fetchRepository = FetchTransactionsRepository(client);

    uri = Uri.parse('https://teste.example.com/auth');
    registerFallbackValue(uri);

    token = Token.fromMap({
      "access_token": "eyJhbGciOiJSUzI1NiIsIn",
      "expires_in": 300,
      "refresh_expires_in": 0,
      "token_type": "Bearer",
      "not-before-policy": 0,
      "scope": "pix.read pix.write"
    });
  });

  group('Consulta de Transações PIX', () {
    test(r'''Caso o clientID esteja vazio ou não definido:
              O Metodo deve retornar uma failure de SicoobApiException
          ''', () async {
      when(() => client.get(any(),
              headers: any(named: 'headers'),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => const Success({}));

      final response = await fetchRepository.fetchTransactions(
        token,
        clientID: '',
        uri: uri,
      );

      var result = response.exceptionOrNull();
      expect(result, isA<SicoobApiException>());
    });

    test(r'''Response com 1 Pagina:
              O Metodo deve retornar uma lista de Transações PIX
              com todos os itens dessa pagina.
          ''', () async {
      when(() => client.get(any(),
              headers: any(named: 'headers'),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Success(onePageExpectedResponse));

      final response = await fetchRepository.fetchTransactions(
        token,
        clientID: clientID,
        uri: uri,
      );

      var result = response.getOrNull();
      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result[0].nomePagador, equals('VICTOR'));
    });

    test(r'''Response com multiplas Paginas:
              O Metodo deve percorrer em todas as paginas e
              retornar uma lista de Transações PIX contendo todos os itens.
          ''', () async {
      when(() => client.get(any(),
              headers: any(named: 'headers'),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Success(multiplePageExpectedResponse));

      final response = await fetchRepository.fetchTransactions(
        token,
        clientID: clientID,
        uri: uri,
      );

      var result = response.getOrNull();
      expect(result, isNotNull);
      expect(result!.length, 20);
      expect(result[0].nomePagador, equals('VICTOR'));
    });

    test(r'''Map da response não contem uma key "Pix":
              O Metodo deverá retornar uma failure de SicoobApiException.
          ''', () async {
      final expectedResponse = {
        "httpCode": "401",
        "httpMessage": "Unauthorized",
        "moreInformation":
            "Cannot pass the security checks that are required by the target API or operation, Enable debug headers for more details."
      };
      when(() => client.get(any(),
              headers: any(named: 'headers'),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Success(expectedResponse));

      final response = await fetchRepository.fetchTransactions(
        token,
        clientID: clientID,
        uri: uri,
      );

      var result = response.exceptionOrNull();

      expect(result, isNotNull);
      expect(result, isA<SicoobApiException>());
    });
  });
}

var onePageExpectedResponse = {
  "parametros": {
    "inicio": "2023-01-01T00:00:00.00-03:00",
    "fim": "2023-01-03T00:00:00.00-03:00",
    "paginacao": {
      "paginaAtual": 0,
      "itensPorPagina": 100,
      "quantidadeDePaginas": 1,
      "quantidadeTotalDeItens": 4
    }
  },
  "pix": [
    {
      "endToEndId": "E00360305",
      "txid": "W4ZD075",
      "valor": "150.00",
      "horario": "2023-01-02T12:54:20.665Z",
      "nomePagador": "VICTOR",
      "pagador": {"nome": "VICTOR", "cpf": "02477816144"},
      "devolucoes": []
    }
  ]
};

var multiplePageExpectedResponse = {
  "parametros": {
    "inicio": "2023-01-01T00:00:00.00-03:00",
    "fim": "2023-01-03T00:00:00.00-03:00",
    "paginacao": {
      "paginaAtual": 0,
      "itensPorPagina": 100,
      "quantidadeDePaginas": 20,
      "quantidadeTotalDeItens": 4
    }
  },
  "pix": [
    {
      "endToEndId": "E00360305",
      "txid": "W4ZD075",
      "valor": "150.00",
      "horario": "2023-01-02T12:54:20.665Z",
      "nomePagador": "VICTOR",
      "pagador": {"nome": "VICTOR", "cpf": "02477816144"},
      "devolucoes": []
    }
  ]
};
