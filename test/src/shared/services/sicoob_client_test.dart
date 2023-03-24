import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix_sicoob/src/error/pix_error.dart';
import 'package:pix_sicoob/src/services/sicoob_client.dart';

class MockIOClient extends Mock implements IOClient {}

void main() {
  late SecurityContext securityContext;
  late SicoobClient client;
  late MockIOClient mockIOClient;
  late Uri testUri;
  late Map<String, String> testHeaders;
  late Map<String, String> testQueryParameters;
  late Map<String, String> testbody;
  late String testResponseBody;

  setUp(() {
    securityContext = SecurityContext();
    client = SicoobClient(securityContext);
    mockIOClient = MockIOClient();
    client.ioClient = mockIOClient;
    testUri = Uri.parse('https://example.com');
    registerFallbackValue(testUri);
    testHeaders = {'Content-Type': 'application/json'};
    testQueryParameters = {'param1': 'value1', 'param2': 'value2'};
    testbody = {'Key1': 'Value1', 'Key2': 'Value2'};
    testResponseBody = '{"key": "value"}';
  });

  group('GET: ', () {
    test('Deve retornar um Map<String,dynamic>', () async {
      when(() => mockIOClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => Response(testResponseBody, 200));

      final expectedResponse = jsonDecode(testResponseBody);

      final result = await client.get(
        testUri,
        headers: testHeaders,
        queryParameters: testQueryParameters,
      );

      final response = result.getOrThrow();

      expect(response, equals(expectedResponse));
      expect(response, isA<Map<String, dynamic>>());
    });

    test(r'''Em caso de erro na chamada HTTP:
    Deverá retornar um PixError do tipo: networkError''', () async {
      when(() => mockIOClient.get(any(), headers: any(named: 'headers')))
          .thenThrow((_) async => Exception('Erro ao requisitar a API'));

      final response = await client.get(
        testUri,
        headers: testHeaders,
        queryParameters: testQueryParameters,
      );
      final result = response.exceptionOrNull();

      expect(result, isNotNull);
      expect(result!.type, equals(PixErrorType.networkError));
    });
  });

  group('POST: ', () {
    test('Deve retornar um Map<String,dynamic>', () async {
      when(() => mockIOClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => Response(testResponseBody, 200));

      final expectedResponse = jsonDecode(testResponseBody);

      final result = await client.post(
        testUri,
        headers: testHeaders,
        body: testbody,
      );
      final response = result.getOrThrow();

      expect(response, equals(expectedResponse));
      expect(response, isA<Map<String, dynamic>>());
    });

    test(r'''Em caso de erro na chamada HTTP:
    Deverá retornar um PixError do tipo: networkError''', () async {
      when(() => mockIOClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenThrow((_) async => Exception('Erro ao requisitar a API'));

      final response = await client.post(
        testUri,
        headers: testHeaders,
        body: testbody,
      );
      final result = response.exceptionOrNull();

      expect(result, isNotNull);
      expect(result!.type, equals(PixErrorType.networkError));
    });
  });
}
