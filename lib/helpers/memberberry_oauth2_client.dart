import 'package:meta/meta.dart';
import 'package:oauth2_client/oauth2_client.dart';

class MemberBerryOAuth2Client extends OAuth2Client {
  MemberBerryOAuth2Client(
      {@required String redirectUri, @required String customUriScheme})
      : super(
            authorizeUrl:
                'https://sso.guengel.ch/auth/realms/guengel.ch/protocol/openid-connect/auth',
            tokenUrl:
                'https://sso.guengel.ch/auth/realms/guengel.ch/protocol/openid-connect/token',
            redirectUri: redirectUri,
            customUriScheme: customUriScheme);
}
