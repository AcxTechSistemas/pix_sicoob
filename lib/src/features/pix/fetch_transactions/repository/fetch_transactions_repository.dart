import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pix_sicoob/src/error/pix_error.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';
import '../../../../shared/models/pix/parametros.dart';
import '../../../../shared/models/pix/pix.dart';
import '../../../token/model/token.dart';

/// A repository class that handles fetching transactions for Pix payments.
///
/// The [FetchRepository] class has a constructor that requires the following parameters:
/// - [client]: an instance of [ClientService] that will be used to make requests.
class FetchTransactionsRepository {
  /// An instance of [ClientService] that will be used to make requests
  final ClientService _client;

  /// The [Parametros] object used to store pagination parameters for the API call.
  late Parametros _parametros;

  /// Constructor for [FetchTransactionsRepository] that takes in a [ClientService] instance.
  FetchTransactionsRepository(ClientService client) : _client = client;

  /// Fetches the [Pix] transactions
  ///
  /// This method takes the following parameters:
  ///
  /// - [token] a [Token] representing the Token object
  /// - [uri] a [Uri] representing the uri to the Pix Api
  /// - [dateTimeRange] a [DateTimeRange] object used to specify the date range of the
  ///   transactions to be fetched.
  ///
  /// This method returns a [Future] of [Result<List<Pix>, PixError>>],

  Future<Result<List<Pix>, PixError>> fetchTransactions(
    Token token, {
    required Uri uri,
    DateTimeRange? dateTimeRange,
  }) async {
    List<Pix> pixTransactions = [];
    try {
      final response = await _callApi(
        token,
        uri: uri,
        dateTimeRange: dateTimeRange,
      );
      _parametros = Parametros.fromMap(response['parametros']);
      if (_parametros.paginacao.quantidadeDePaginas <= 1) {
        var transactions = response['pix'] as List;
        pixTransactions
            .addAll(transactions.map((e) => Pix.fromMap(e)).toList());
        final reversedList = pixTransactions.reversed.toList();
        return Success(reversedList);
      } else {
        for (var i = 0; i < _parametros.paginacao.quantidadeDePaginas; i++) {
          final paginaAtual = i.toString();
          final multiplePagesResponse = await _callApi(
            token,
            uri: uri,
            dateTimeRange: dateTimeRange,
            paginaAtual: paginaAtual,
          );

          var transactions = multiplePagesResponse['pix'] as List;
          pixTransactions
              .addAll(transactions.map((e) => Pix.fromMap(e)).toList());
        }
        final reversedList = pixTransactions.reversed.toList();
        return Success(reversedList);
      }
    } on PixError catch (e) {
      return Failure(e);
    }
  }

  /// Retrieves the [Pix] transactions within a specific date range.
  ///
  /// This method takes the following parameters:
  /// - [token] a [Token] representing the Token object
  /// - [uri] a [Uri] representing the uri to the Pix Api
  /// - [dateTimeRange] a [DateTimeRange] object used to specify the date range of the
  ///   transactions to be fetched.
  ///
  /// This method returns a [Future] of [Map<String, dynamic>],
  Future<Map<String, dynamic>> _callApi(
    Token token, {
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
      headers: {'Authorization': '${token.tokenType} ${token.accessToken}'},
    );
    return response.fold((success) {
      if (success.containsKey('pix')) {
        return success;
      } else {
        throw PixError(success);
      }
    }, (failure) {
      throw PixError(failure);
    });
  }
}

/// Formats the given date to the ISO 8601 format with a fixed timezone offset of -03:00.
///
/// This method takes the following parameters:
///
/// - [DateTime] a [date] representing the date to format
///
/// This method returns a [String],
String formatToIso8601TimeZone({required DateTime date}) {
  String toIso8601TimeZone =
      DateFormat('yyyy-MM-ddThh:mm:ss.00-03:00').format(date);
  return toIso8601TimeZone;
}
