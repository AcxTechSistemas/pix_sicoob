import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
import 'package:pix_sicoob/src/errors/sicoob_api_exception.dart';
import 'package:pix_sicoob/src/errors/sicoob_unknown_exception.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/models/billing/billing.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/models/insta_bill/insta_bill.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';

import '../../../token/model/token.dart';

/// A repository class for interacting with the Pix InstaBill API.
class InstaBillRepository {
  final ClientService client;

  /// Constructs an instance of [InstaBillRepository] with the specified [client].
  InstaBillRepository(
    this.client,
  );

  /// Creates a new Pix InstaBill billing using the specified [token], [instaBill], and [cobUri].
  ///
  /// Returns a [Result] containing a [Billing] object if successful, otherwise a [PixException].
  Future<Result<Billing, PixException>> createBilling({
    required Token token,
    required InstaBill instaBill,
    required Uri cobUri,
  }) async {
    final response = client.post(
      cobUri,
      headers: {
        'Authorization': '${token.tokenType} ${token.accessToken}',
        'Content-Type': 'application/json',
      },
      body: instaBill.toJson(),
    );
    return response.fold(
      (success) {
        if (success.containsKey('calendario')) {
          return Success(Billing.fromMap(success));
        } else {
          return Failure(SicoobApiException.apiError(success));
        }
      },
      (error) => Failure(SicoobUnknownException.unknownException(error)),
    );
  }
}
