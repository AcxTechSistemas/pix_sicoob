/// A library for interacting with the Sicoob Pix API.
library pix_sicoob;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pix_sicoob/src/features/pix/fetch_transactions/repository/fetch_transactions_repository.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/models/billing/billing.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/repository/insta_bill_repository.dart';
import 'package:pix_sicoob/src/features/token/model/token.dart';
import 'package:pix_sicoob/src/features/token/repository/token_repository.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:pix_sicoob/src/services/sicoob_client.dart';
import 'package:pix_sicoob/src/services/sicoob_security.dart';
import 'src/features/cob/insta_bill/models/insta_bill/insta_bill.dart';
import 'src/shared/models/pix/pix.dart';
export './pix_sicoob.dart';
export './src/shared/models/pix/pix.dart';
export 'src/features/cob/insta_bill/models/billing/billing.dart';
export 'src/features/cob/insta_bill/models/insta_bill/insta_bill.dart';

/// A class that provides an interface for communicating with the Sicoob PIX API.
///
/// The class handles:
/// - Authentication
/// - Token retrieval
/// - Transaction retrieval
/// - Bill creation.
/// ```dart
/// final PixSicoob pixSicoob = PixSicoob(
/// clientID: 'YOUR_CLIENT_ID',
/// certificateBase64String: 'YOUR_CERTIFICATE_BASE64_STRING',
/// certificatePassword: 'YOUR_CERTIFICATE_PASSWORD',
/// );
///
/// final Token token = await pixSicoob.getToken();
///
/// final List<Pix> transactions = await pixSicoob.fetchTransactions(
/// token: token,
/// dateTimeRange: DateTimeRange(
/// start: DateTime.now().subtract(Duration(days: 7)),
/// end: DateTime.now(),
/// ));
///
/// final InstaBill instaBill = InstaBill(
/// ... // populate fields
/// );
///
/// final Billing billing = await pixSicoob.createBilling(
/// token: token,
/// instaBill: instaBill,
/// );
/// ```
class PixSicoob {
  final String _clientID;
  final String _certificateBase64String;
  final String _certificatePassword;

  final _authUri = Uri.parse(
    'https://auth.sicoob.com.br/auth/realms/cooperado/protocol/openid-connect/token',
  );

  final _apiUri = Uri.parse(
    'https://api.sicoob.com.br/pix/api/v2/pix',
  );

  final _cobUri = Uri.parse(
    'https://api.sicoob.com.br/pix/api/v2/cob',
  );

  late SicoobSecurity _sicoobSecurity;
  late SecurityContext _securityContext;
  late ClientService _client;
  late TokenRepository _tokenRepository;
  late FetchTransactionsRepository _fetchRepository;
  late InstaBillRepository _instaBillRepository;

  PixSicoob._({
    required String clientID,
    required String certificateBase64String,
    required String certificatePassword,
  })  : _clientID = clientID,
        _certificateBase64String = certificateBase64String,
        _certificatePassword = certificatePassword {
    _sicoobSecurity = SicoobSecurity();
    _securityContext = _sicoobSecurity
        .getContext(
            certificateBase64String: _certificateBase64String,
            certificatePassword: _certificatePassword)
        .getOrThrow();
    _client = SicoobClient(_securityContext);
    _tokenRepository = TokenRepository(_client);
    _fetchRepository = FetchTransactionsRepository(_client);
    _instaBillRepository = InstaBillRepository(_client);
  }

  PixSicoob({
    required String clientID,
    required String certificateBase64String,
    required String certificatePassword,
  }) : this._(
          clientID: clientID,
          certificateBase64String: certificateBase64String,
          certificatePassword: certificatePassword,
        );

  /// Retrieves an authentication token.
  ///
  /// Example:
  ///
  /// ```dart
  /// final Token token = await pixSicoob.getToken();
  /// ```
  Future<Token> getToken() async {
    final response = await _tokenRepository.getToken(
      uri: _authUri,
      clientID: _clientID,
    );
    return response.getOrThrow();
  }

  /// Fetches the [Pix] transactions for a given token
  ///
  /// This method takes the following parameters:
  /// - A valid [Token] instance,
  /// -  dateTimeRange The optional [DateTimeRange] to filter transactions.
  /// If not provided by default returns the last 4 days transactions.
  ///
  /// Example:
  /// ```dart
  /// final List<Pix> transactions = await pixSicoob.fetchTransactions(
  /// token: token,
  /// dateTimeRange: DateTimeRange(
  /// start: DateTime.now().subtract(Duration(days: 7)),
  /// end: DateTime.now(),
  /// ));
  /// ```
  Future<List<Pix>> fetchTransactions({
    required Token token,
    DateTimeRange? dateTimeRange,
  }) async {
    final response = await _fetchRepository.fetchTransactions(
      token,
      uri: _apiUri,
      dateTimeRange: dateTimeRange,
    );
    return response.getOrThrow();
  }

  /// Creates a new billing on the server.
  ///
  /// This method takes the following parameters:
  /// - A valid [Token] instance,
  /// - A valid [InstaBill] instance,
  ///
  /// Example:
  ///
  /// ```dart
  /// final InstaBill instaBill = InstaBill(
  /// ... // populate fields
  /// );
  ///
  /// final Billing billing = await pixSicoob.createBilling(
  /// token: token,
  /// instaBill: instaBill,
  /// );
  /// ```
  Future<Billing> createBilling({
    required Token token,
    required InstaBill instaBill,
  }) async {
    final response = await _instaBillRepository.createBilling(
      token: token,
      instaBill: instaBill,
      cobUri: _cobUri,
    );
    return response.getOrThrow();
  }

  static String certFileToBase64String({required File pkcs12CertificateFile}) {
    return SicoobSecurity().certFileToBase64String(
      pkcs12CertificateFile: pkcs12CertificateFile,
    );
  }
}
