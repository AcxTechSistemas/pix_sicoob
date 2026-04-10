import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
import 'package:result_dart/result_dart.dart';

import 'src/features/pix/fetch_transactions/repository/fetch_transactions_repository.dart';
import 'src/features/pix/models/pix/pix.dart';
import 'src/features/token/model/token.dart';
import 'src/features/token/repository/token_repository.dart';
import 'src/services/sicoob_client.dart';
import 'src/services/sicoob_security.dart';

export 'src/errors/pix_exception_interface.dart';
export 'src/errors/sicoob_api_exception.dart';
export 'src/errors/sicoob_certificate_exception.dart';
export 'src/errors/sicoob_http_exception.dart';
export 'src/errors/sicoob_unknown_exception.dart';
export 'src/features/pix/models/pix/pix.dart';
export 'src/features/token/model/token.dart';

/// The main class that provides the Pix Sicoob API functionalities.
class PixSicoob {
  final String _clientID;
  final TokenRepository _tokenRepository;
  final FetchTransactionsRepository _fetchTransactionsRepository;

  final _authUri = Uri.parse(
    'https://auth.sicoob.com.br/auth/realms/cooperado/protocol/openid-connect/token',
  );

  final _apiUri = Uri.parse(
    'https://api.sicoob.com.br/pix/api/v2/pix',
  );

  /// Constructor with Dependency Injection support.
  ///
  /// Usually called via the factory [PixSicoob] constructor for convenience.
  PixSicoob.withDependencies({
    required String clientID,
    required TokenRepository tokenRepository,
    required FetchTransactionsRepository fetchTransactionsRepository,
  })  : _clientID = clientID,
        _tokenRepository = tokenRepository,
        _fetchTransactionsRepository = fetchTransactionsRepository;

  /// Default constructor that initializes the necessary properties for the class.
  ///
  /// [clientID] is the client identifier for the API.
  ///
  /// [certificateBase64String] is the base64 encoded PKCS12 certificate for the client.
  ///
  /// [certificatePassword] is the password for the certificate.
  factory PixSicoob({
    required String clientID,
    required String certificateBase64String,
    required String certificatePassword,
  }) {
    final sicoobSecurity = SicoobSecurity();
    final securityContext = sicoobSecurity
        .getContext(
          certificateBase64String: certificateBase64String,
          certificatePassword: certificatePassword,
        )
        .getOrThrow();

    final client = SicoobClient(securityContext);

    return PixSicoob.withDependencies(
      clientID: clientID,
      tokenRepository: TokenRepository(client),
      fetchTransactionsRepository: FetchTransactionsRepository(client),
    );
  }

  /// Retrieves a valid token from the API.
  ///
  /// Returns a [AsyncResult] with a [Token] object.
  Future<ResultDart<Token, PixException>> getToken() async {
    return _tokenRepository.getToken(
      uri: _authUri,
      clientID: _clientID,
    );
  }

  /// Retrieves a list of transactions from the API.
  ///
  /// [token] is a valid [Token] object used for authentication.
  /// [dateTimeRange] is an optional range of dates to retrieve transactions from.
  ///
  /// Returns a [AsyncResult] with a [List] of [Pix] objects.
  Future<ResultDart<List<Pix>, PixException>> fetchTransactions({
    required Token token,
    DateTimeRange? dateTimeRange,
  }) async {
    return _fetchTransactionsRepository.fetchTransactions(
      token,
      clientID: _clientID,
      uri: _apiUri,
      dateTimeRange: dateTimeRange,
    );
  }

  /// Converts a PKCS12 certificate file to a base64 string.
  ///
  /// Returns a [Result] containing the base64 string on success.
  static ResultDart<String, PixException> certFileToBase64String({
    required File pkcs12CertificateFile,
  }) {
    final sicoobSecurity = SicoobSecurity();
    return sicoobSecurity.certFileToBase64String(
      pkcs12CertificateFile: pkcs12CertificateFile,
    );
  }
}
