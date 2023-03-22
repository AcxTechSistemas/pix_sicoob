import 'package:pix_sicoob/src/error/pix_error.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/models/billing/billing.dart';
import 'package:pix_sicoob/src/features/cob/insta_bill/models/insta_bill/insta_bill.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';

import '../../../token/model/token.dart';

/// A repository class responsible for handling the creation of insta billings.
///
/// The [InstaBillRepository] requires a [ClientService] instance to communicate with the server.
class InstaBillRepository {
  /// An instance of [ClientService] to communicate with the server.
  final ClientService client;

  /// Constructs a new [InstaBillRepository] instance with the given [client].
  InstaBillRepository(
    this.client,
  );

  /// Creates a new billing on the server.
  ///
  /// Requires a valid [Token] instance, an [InstaBill] instance, and the [cobUri] endpoint to post the request.
  /// Returns a [Result] with a [Billing] instance if successful, or a [PixError] instance if failed.
  Future<Result<Billing, PixError>> createBilling({
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
          return Failure(PixError(success));
        }
      },
      (error) => Failure(PixError(error)),
    );
  }
}
