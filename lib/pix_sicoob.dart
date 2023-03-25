library pix_sicoob;

import 'dart:io';
import 'package:flutter/material.dart';
import 'src/features/pix/fetch_transactions/repository/fetch_transactions_repository.dart';
import 'src/features/cob/insta_bill/models/billing/billing.dart';
import 'src/features/cob/insta_bill/repository/insta_bill_repository.dart';
import 'src/features/pix/models/pix/pix.dart';
import 'src/features/token/model/token.dart';
import 'src/features/token/repository/token_repository.dart';
import 'src/services/client_service.dart';
import 'src/services/sicoob_client.dart';
import 'src/services/sicoob_security.dart';
import 'src/features/cob/insta_bill/models/insta_bill/insta_bill.dart';
export 'src/features/cob/insta_bill/models/billing/billing.dart';
export 'src/features/cob/insta_bill/models/insta_bill/insta_bill.dart';
export 'src/features/cob/insta_bill/models/insta_bill/calendario.dart';
export 'src/features/cob/insta_bill/models/shared/devedor.dart';
export 'src/features/cob/insta_bill/models/shared/valor.dart';
export 'src/features/cob/insta_bill/models/shared/info_adicionais.dart';
export 'src/features/pix/models/pix/pix.dart';
export 'src/errors/pix_exception_interface.dart';
export 'src/errors/sicoob_api_exception.dart';
export 'src/errors/sicoob_certificate_exception.dart';
export 'src/errors/sicoob_http_exception.dart';
export 'src/errors/sicoob_unknown_exception.dart';
export './pix_sicoob.dart';

/// The main class that provides the Pix Sicoob API functionalities.
///
/// This class encapsulates the operations related to authentication, token management,
/// transaction retrieval and billing creation.
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

  /// Constructor that initializes the necessary properties for the class.
  ///
  /// [clientID] is the client identifier for the API.
  ///
  /// [certificateBase64String] is the base64 encoded PKCS12 certificate for the client.
  ///
  /// [certificatePassword] is the password for the certificate.
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
  }

  /// Constructor that delegates to the private constructor and initializes the necessary properties for the class.
  ///
  /// [clientID] is the client identifier for the API.
  ///
  /// [certificateBase64String] is the base64 encoded PKCS12 certificate for the client.
  ///
  /// [certificatePassword] is the password for the certificate.
  PixSicoob({
    required String clientID,
    required String certificateBase64String,
    required String certificatePassword,
  }) : this._(
          clientID: clientID,
          certificateBase64String: certificateBase64String,
          certificatePassword: certificatePassword,
        );

  /// Retrieves a valid token from the API.
  ///
  /// Returns a [Future] with a [Token] object representing the token.
  ///
  /// Throws a [PixException] if there's an error while fetching the token.
  Future<Token> getToken() async {
    final repository = TokenRepository(_client);
    final response = await repository.getToken(
      uri: _authUri,
      clientID: _clientID,
    );
    return response.getOrThrow();
  }

  /// Retrieves a list of transactions from the API.
  ///
  /// [token] is a valid [Token] object used for authentication.
  ///
  /// [dateTimeRange] is an optional [DateTimeRange] object representing the range of dates to retrieve transactions from.
  ///
  /// Returns a [Future] with a [List] of [Pix] objects representing the transactions.
  ///
  /// Throws a [PixException] if there's an error while fetching the transactions.
  Future<List<Pix>> fetchTransactions({
    required Token token,
    DateTimeRange? dateTimeRange,
  }) async {
    final repository = FetchTransactionsRepository(_client);
    final response = await repository.fetchTransactions(
      token,
      uri: _apiUri,
      dateTimeRange: dateTimeRange,
    );
    return response.getOrThrow();
  }

  /// Creates a new billing with the given [token] and [instaBill] parameters.
  ///
  /// Returns a [Billing] object on success or throws a [PixException] on failure.
  Future<Billing> createBilling({
    required Token token,
    required InstaBill instaBill,
  }) async {
    final repository = InstaBillRepository(_client);
    final response = await repository.createBilling(
      token: token,
      instaBill: instaBill,
      cobUri: _cobUri,
    );
    return response.getOrThrow();
  }

  /// Converts a PKCS12 certificate file to a base64 string.
  ///
  /// Returns the base64 string on success or throws a [PixException] on failure.
  static String certFileToBase64String({required File pkcs12CertificateFile}) {
    final sicoobSecurity = SicoobSecurity();
    final response = sicoobSecurity.certFileToBase64String(
      pkcs12CertificateFile: pkcs12CertificateFile,
    );

    return response.getOrThrow();
  }
}
