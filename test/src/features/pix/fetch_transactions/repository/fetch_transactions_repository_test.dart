import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix_sicoob/pix_sicoob.dart';
import 'package:pix_sicoob/src/features/pix/fetch_transactions/repository/fetch_transactions_repository.dart';
import 'package:pix_sicoob/src/features/token/model/token.dart';
import 'package:result_dart/result_dart.dart';

class MockFetchTransactionsRepository extends Mock
    implements FetchTransactionsRepository {}

class MockToken extends Mock implements Token {}

class MockPix extends Mock implements Pix {}

void main() {
  late FetchTransactionsRepository fetchRepository;
  late Uri uri;
  late Token token;
  late Pix pix;
  setUp(() {
    fetchRepository = MockFetchTransactionsRepository();
    uri = Uri.parse('https://teste.example.com/auth');
    registerFallbackValue(uri);
    token = MockToken();
    registerFallbackValue(token);
    pix = MockPix();
    registerFallbackValue(pix);
  });

  group('Consulta de Transações PIX', () {
    test('Metodo deve retornar uma Lista de Transações Pix', () async {
      when(() => pix.nomePagador).thenReturn('Alefe');
      when(() => fetchRepository.fetchTransactions(
            any(),
            uri: any(named: 'uri'),
            dateTimeRange: any(named: 'dateTimeRange'),
          )).thenAnswer((_) async => Success([pix, pix, pix, pix, pix, pix]));

      final response = await fetchRepository.fetchTransactions(
        token,
        uri: uri,
      );
      var result = response.getOrThrow();
      expect(result, isNotNull);
      expect(result.length, 6);
      expect(result[0].nomePagador, equals('Alefe'));
    });
  });
}
