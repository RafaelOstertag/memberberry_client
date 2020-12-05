import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:synchronized/synchronized.dart';

import 'memberberry_oauth2_client.dart';

class HttpClient {
  final Lock _lock;
  MemberBerryOAuth2Client _memberBerryOAuth2Client;
  OAuth2Helper _oAuth2Helper;

  HttpClient() : _lock = Lock() {
    _memberBerryOAuth2Client = MemberBerryOAuth2Client(
        redirectUri: 'ch.guengel.android.memberberry://oauth2redirect',
        customUriScheme: 'ch.guengel.android.memberberry');
    _oAuth2Helper = OAuth2Helper(_memberBerryOAuth2Client,
        grantType: OAuth2Helper.AUTHORIZATION_CODE,
        clientId: 'memberberry-client',
        scopes: ["email", "profile"],
        enableState: true);
  }

  Future<http.Response> getBerries() async {
    return await _lock.synchronized(() async {
      return await _oAuth2Helper
          .get('https://memberberry.guengel.ch/v1/berries');
    });
  }

  Future<http.Response> deleteBerry(String id) async {
    return await _lock.synchronized(() async {
      return _oAuth2Helper
          .delete('https://memberberry.guengel.ch/v1/berries/$id')
          .then((response) {
        debugPrint('Deleted berry $id');
        return response;
      });
    });
  }

  Future<http.Response> loadBerry(String uri) async {
    var httpsUri = uri.replaceFirst("http://", "https://");
    return await _lock.synchronized(() async {
      return _oAuth2Helper.get(httpsUri);
    });
  }

  Future<http.Response> putToken(String token) async {
    return await _lock.synchronized(() async {
      var httpClient = http.Client();

      var headers = Map<String, String>();

      http.Response resp;

      var tknResp = await _oAuth2Helper.getToken();
      var url = 'https://memberberry.guengel.ch/v1/me/fcm-token';
      var body = {"token": token};

      try {
        headers['Authorization'] = 'Bearer ' + tknResp.accessToken;
        headers['Content-Type'] = 'application/json';
        resp =
            await httpClient.put(url, body: jsonEncode(body), headers: headers);

        if (resp.statusCode == 401) {
          if (tknResp.hasRefreshToken()) {
            tknResp = await _oAuth2Helper.refreshToken(tknResp.refreshToken);
          } else {
            tknResp = await _oAuth2Helper.fetchToken();
          }

          if (tknResp != null) {
            headers['Authorization'] = 'Bearer ' + tknResp.accessToken;
            resp = await httpClient.put(url, body: body, headers: headers);
          }
        }
        return resp;
      } catch (e) {
        rethrow;
      }
    });
  }

  Future<http.Response> createBerry(String subject, String period) async {
    var headers = Map<String, String>();
    headers['Content-Type'] = 'application/json';

    var body = Map<String, String>();
    body['subject'] = subject;
    body['period'] = period;

    return await _lock.synchronized(() async {
      return await _oAuth2Helper.post(
          'https://memberberry.guengel.ch/v1/berries',
          headers: headers,
          body: jsonEncode(body));
    });
  }
}
