import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix_sicoob/src/error/pix_error.dart';
import 'package:pix_sicoob/src/features/token/model/token.dart';
import 'package:pix_sicoob/src/features/token/repository/token_repository.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';

class MockClientService extends Mock implements ClientService {}

void main() {
  late ClientService client;
  late TokenRepository tokenRepository;
  late Uri uri;
  late dynamic expectedResponse;
  const clientID = 'client-id';
  setUp(() {
    client = MockClientService();
    tokenRepository = TokenRepository(client);

    uri = Uri.parse('https://teste.example.com/auth');
    registerFallbackValue(uri);
  });
  test('A chamada da API deve retornar um Token', () async {
    // Configura as expectativas do teste
    expectedResponse = {
      'access_token': '234k-vkhk-l1h2-3l3l',
      'expires_in': 20,
      'refresh_expires_in': 300,
      'token_type': 'Bearer',
      'not-before-policy': 30,
      'scope': 'pix.read',
    };

    // Configura o mock da chamada http
    when(() => client.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        )).thenAnswer((_) async => Success(expectedResponse));

    // Executa o método que está sendo testado
    final response = await tokenRepository.getToken(
      uri: uri,
      clientID: clientID,
    );
    var result = response.fold((success) => success, (failure) => null);

    // Verifica se o resultado foi o esperado
    expect(result, isNotNull);
    expect(result, isA<Token>());
    expect(result?.accessToken, equals(expectedResponse['access_token']));
  });

  test('Em caso de erro a chamada da API deve retornar um PixError', () async {
    // Configura as expectativas do teste
    expectedResponse = "error";

    // Configura o mock da chamada http
    when(() => client.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        )).thenAnswer((_) async => Failure(PixError(expectedResponse)));

    //Executa o metodo que está sendo testado
    final response = await tokenRepository.getToken(
      uri: uri,
      clientID: clientID,
    );
    var result = response.fold((success) => null, (failure) => failure)!;

    // Verifica se o resultado foi o esperado
    expect(result, isA<Exception>());
    expect(result.message, isNotNull);
    expect(result.message, contains('error'));
  });
}
