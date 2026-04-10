import 'package:pix_sicoob/src/errors/pix_exception_interface.dart';
import 'package:pix_sicoob/src/errors/sicoob_api_exception.dart';
import 'package:pix_sicoob/src/features/token/model/token.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';

/// The repository responsible for retrieving and managing tokens.
///
/// This class interacts with the [ClientService] to make API requests and return
/// results wrapped in [Result] objects containing either a [Token] or a [PixException].
class TokenRepository {
  final ClientService _client;

  TokenRepository(ClientService client) : _client = client;

  /// Retrieve a token from the specified [uri] using the provided [clientID].
  ///
  /// The API request is made through the [_client] service and the response is
  /// parsed into a [Token] object or an appropriate [PixException].
  ///
  /// Returns a [Future] containing a [Result] object with either a [Token] or
  /// a [PixException].
  Future<ResultDart<Token, PixException>> getToken({
    required Uri uri,
    required String clientID,
  }) async {
    if (clientID.isEmpty) {
      return Failure(SicoobApiException.apiError(
        {
          'error': 'client-id-cannot-be-empty',
          'error_description': 'Identificador do cliente não pode ser vazio',
        },
      ));
    }
    final response = await _client.post(
      uri,
      body: {
        'grant_type': 'client_credentials',
        'client_id': clientID,
        'scope':
            'cob.read cob.write cobv.write cobv.read lotecobv.write lotecobv.read pix.write pix.read webhook.read webhook.write payloadlocation.write payloadlocation.read',
      },
    );

    return response.flatMap((success) {
      if (success.containsKey('access_token')) {
        return Success(Token.fromMap(success));
      } else {
        return Failure(SicoobApiException.apiError(success));
      }
    });
  }
}
