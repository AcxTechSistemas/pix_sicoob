import 'package:flutter/material.dart';
import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
import 'package:pix_sicoob/src/errors/sicoob_api_exception.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:pix_sicoob/src/utils/date_utils.dart';
import 'package:result_dart/result_dart.dart';
import '../../../token/model/token.dart';
import '../../models/pix/parametros.dart';
import '../../models/pix/pix.dart';

/// A repository for fetching Pix transactions from the Sicoob API.
class FetchTransactionsRepository {
  /// Instance of the [ClientService] used to make API calls
  final ClientService _client;

  /// Constructor for [FetchTransactionsRepository] that receives a [ClientService]
  FetchTransactionsRepository(ClientService client) : _client = client;

  /// Method that fetches transactions from the Pix API and returns a [Result] object
  ///
  /// The [token] parameter is a [Token] object containing the access token and token type
  /// The [uri] parameter is the [Uri] endpoint for fetching transactions
  /// The [dateTimeRange] parameter is an optional [DateTimeRange] used to filter the transactions by date
  ///
  /// Returns a [Success] object containing a list of [Pix] objects if successful
  /// Returns a [Failure] object containing a [PixException] if unsuccessful
  Future<ResultDart<List<Pix>, PixException>> fetchTransactions(
    Token token, {
    required String clientID,
    required Uri uri,
    DateTimeRange? dateTimeRange,
  }) async {
    if (dateTimeRange != null &&
        dateTimeRange.start.month != dateTimeRange.end.month) {
      return Failure(
        SicoobApiException(
          error: 'date-range-must-be-in-the-same-month',
          errorDescription:
              'O intervalo de datas deve estar dentro do mesmo mês',
        ),
      );
    }
    if (clientID.isEmpty) {
      return Failure(SicoobApiException.apiError(
        {
          'error': 'client-id-cannot-be-empty',
          'error_description': 'O ID do cliente não pode estar vazio',
        },
      ));
    }
    List<Pix> pixTransactions = [];
    try {
      final response = await _callApi(
        token,
        clientID: clientID,
        uri: uri,
        dateTimeRange: dateTimeRange,
      );
      
      final parametros = Parametros.fromMap(response['parametros']);
      var transactions = response['pix'] as List;
      pixTransactions.addAll(transactions.map((e) => Pix.fromMap(e)));

      if (parametros.paginacao.quantidadeDePaginas > 1) {
        for (var i = 1; i < parametros.paginacao.quantidadeDePaginas; i++) {
          final paginaAtual = i.toString();
          final multiplePagesResponse = await _callApi(
            token,
            clientID: clientID,
            uri: uri,
            dateTimeRange: dateTimeRange,
            paginaAtual: paginaAtual,
          );

          var moreTransactions = multiplePagesResponse['pix'] as List;
          pixTransactions
              .addAll(moreTransactions.map((e) => Pix.fromMap(e)));
        }
      }
      return Success(pixTransactions.reversed.toList());
    } on PixException catch (e) {
      return Failure(e);
    }
  }

  /// Private method that makes the API call and returns a map of the response
  ///
  /// The [token] parameter is a [Token] object containing the access token and token type
  /// The [uri] parameter is the [Uri] endpoint for fetching transactions
  /// The [dateTimeRange] parameter is an optional [DateTimeRange] used to filter the transactions by date
  /// The [paginaAtual] parameter is an optional [String] used to specify the page number of the transaction results
  ///
  /// Returns a [Map] containing the response from the API call
  ///
  /// Throws a [SicoobApiException] or [SicoobUnknownException] if there's an error making the API call
  Future<Map<String, dynamic>> _callApi(
    Token token, {
    required String clientID,
    required Uri uri,
    required DateTimeRange? dateTimeRange,
    String paginaAtual = '0',
  }) async {
    final fourdaysAgo = DateTime.now().subtract(const Duration(days: 4));
    final currentDate = DateTime.now();

    final initialDate =
        formatToIso8601TimeZone(date: dateTimeRange?.start ?? fourdaysAgo);
    final finalDate =
        formatToIso8601TimeZone(date: dateTimeRange?.end ?? currentDate);

    final response = await _client.get(
      uri,
      queryParameters: {
        'inicio': initialDate,
        'fim': finalDate,
        'paginacao.paginaAtual': paginaAtual,
      },
      headers: {
        'Authorization': '${token.tokenType} ${token.accessToken}',
        'x-sicoob-clientid': clientID,
      },
    );
    
    final mapResponse = response.getOrThrow();
    if (mapResponse.containsKey('pix')) {
      return mapResponse;
    } else {
      throw SicoobApiException.apiError(mapResponse);
    }
  }
}

