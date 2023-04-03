import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix_sicoob/src/errors/sicoob_api_exception.dart';
import 'package:pix_sicoob/src/features/token/model/token.dart';
import 'package:pix_sicoob/src/features/token/repository/token_repository.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';

class MockClientService extends Mock implements ClientService {}

void main() {
  late ClientService client;
  late TokenRepository tokenRepository;
  late Uri uri;
  const clientID = 'client-id';
  setUp(() {
    client = MockClientService();
    tokenRepository = TokenRepository(client);

    uri = Uri.parse('https://teste.example.com/auth');
    registerFallbackValue(uri);
  });

  group('Token: ', () {
    test('A chamada da API deve retornar um Token', () async {
      final expectedResponse = {
        'access_token': '234k-vkhk-l1h2-3l3l',
        'expires_in': 20,
        'refresh_expires_in': 300,
        'token_type': 'Bearer',
        'not-before-policy': 30,
        'scope': 'pix.read',
      };

      when(() => client.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => Success(expectedResponse));

      final response = await tokenRepository.getToken(
        uri: uri,
        clientID: clientID,
      );

      var result = response.getOrThrow();

      expect(result, isNotNull);
      expect(result, isA<Token>());
      expect(result.accessToken, equals(expectedResponse['access_token']));
    });

    test(r'''Map da response não contem uma key "access_token":
              O Metodo deverá retornar uma failure de SicoobApiException.
          ''', () async {
      final expectedResponse = {'error': 'type'};

      when(() => client.post(
            any(),
            body: any(named: 'body'),
            headers: any(named: 'headers'),
          )).thenAnswer((_) async => Success(expectedResponse));

      final response = await tokenRepository.getToken(
        uri: uri,
        clientID: clientID,
      );
      var result = response.exceptionOrNull();

      expect(result, isA<SicoobApiException>());
      expect(result!.error, isNotNull);
      expect(result.error, contains('type'));
    });
  });
}
