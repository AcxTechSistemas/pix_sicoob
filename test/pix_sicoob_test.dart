import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pix_sicoob/pix_sicoob.dart';
import 'package:pix_sicoob/src/features/pix/fetch_transactions/repository/fetch_transactions_repository.dart';
import 'package:pix_sicoob/src/features/token/repository/token_repository.dart';
import 'package:result_dart/result_dart.dart';

class MockTokenRepository extends Mock implements TokenRepository {}

class MockFetchTransactionsRepository extends Mock
    implements FetchTransactionsRepository {}

void main() {
  late PixSicoob pixSicoob;
  late MockTokenRepository mockTokenRepository;
  late MockFetchTransactionsRepository mockFetchTransactionsRepository;
  const clientID = 'test-client-id';

  setUp(() {
    mockTokenRepository = MockTokenRepository();
    mockFetchTransactionsRepository = MockFetchTransactionsRepository();

    pixSicoob = PixSicoob.withDependencies(
      clientID: clientID,
      tokenRepository: mockTokenRepository,
      fetchTransactionsRepository: mockFetchTransactionsRepository,
    );
  });

  group('PixSicoob Unit Tests', () {
    test(
        'getToken deve retornar Sucesso quando o repositório retornar um Token',
        () async {
      // Arrange
      final expectedToken = Token(
        accessToken: 'access-token',
        tokenType: 'Bearer',
        expiresIn: 3600,
        refreshExpiresIn: 0,
        notBeforePolicy: 0,
        scope: 'pix.read',
      );

      when(() => mockTokenRepository.getToken(
            uri: any(named: 'uri'),
            clientID: any(named: 'clientID'),
          )).thenAnswer((_) async => Success(expectedToken));

      // Act
      final result = await pixSicoob.getToken();

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), isA<Token>());
      expect(result.getOrNull()?.accessToken, 'access-token');
    });

    test(
        'fetchTransactions deve retornar Sucesso quando o repositório retornar uma lista',
        () async {
      // Arrange
      final token = Token(
        accessToken: 'token',
        tokenType: 'Bearer',
        expiresIn: 3600,
        refreshExpiresIn: 0,
        notBeforePolicy: 0,
        scope: 'pix.read',
      );

      final expectedPixList = <Pix>[];

      when(() => mockFetchTransactionsRepository.fetchTransactions(
            any(),
            clientID: any(named: 'clientID'),
            uri: any(named: 'uri'),
            dateTimeRange: any(named: 'dateTimeRange'),
          )).thenAnswer((_) async => Success(expectedPixList));

      // Act
      final result = await pixSicoob.fetchTransactions(
        token: token,
        dateTimeRange: DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 1)),
          end: DateTime.now(),
        ),
      );

      // Assert
      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), isA<List<Pix>>());
    });
  });
}
