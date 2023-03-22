import 'package:pix_sicoob/src/error/pix_error.dart';
import 'package:pix_sicoob/src/features/token/model/token.dart';
import 'package:pix_sicoob/src/services/client_service.dart';
import 'package:result_dart/result_dart.dart';

///A repository class that handles the retrieval of tokens from the server.
///
///The [TokenRepository] class requires a [ClientService] instance to communicate with the server.
class TokenRepository {
  ///The [ClientService] instance used to communicate with the server.
  final ClientService _client;

  TokenRepository(ClientService client) : _client = client;

  /// Retrieves a token from the server by sending a POST request to the specified [uri] with the [clientID]  .
  ///
  /// If the request is successful and contains an access token, the token is returned in a [Success] of [Token].
  ///
  /// If the request fails or does not contain an access token, a [Failure] Result with a [PixError] is returned.
  ///
  /// - [uri] The [Uri] of the server to send the POST request to.
  /// - [clientID] The ID of the client that is requesting the token.
  Future<Result<Token, PixError>> getToken({
    required Uri uri,
    required String clientID,
  }) async {
    final response = await _client.post(
      uri,
      body: {
        'grant_type': 'client_credentials',
        'client_id': clientID,
        'scope':
            'cob.read cob.write cobv.write cobv.read lotecobv.write lotecobv.read pix.write pix.read webhook.read webhook.write payloadlocation.write payloadlocation.read',
      },
    );

    return response.fold((success) {
      if (success.containsKey('access_token')) {
        var token = Token.fromMap(success);
        return Success(token);
      } else {
        return Failure(PixError(success));
      }
    }, (failure) {
      return Failure(PixError(failure.toString()));
    });
  }
}
