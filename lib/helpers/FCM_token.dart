import 'package:flutter/foundation.dart';

import 'http_client.dart';

class FCMToken {
  final HttpClient _httpClient;

  FCMToken(this._httpClient);

  void registerToken(String token) {
    _httpClient.putToken(token).then((response) =>
        debugPrint("FCM Token registered: Status ${response.statusCode}"));
  }
}
