import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:memberberry_client/helpers/http_client.dart';

class BerryModel extends ChangeNotifier {
  List<Berry> _berryList;
  final HttpClient _httpClient;

  BerryModel(HttpClient httpClient) : _httpClient = httpClient {
    _berryList = [];
  }

  void reload() async {
    await _httpClient.getBerries().then((response) {
      List<dynamic> berryJson = jsonDecode(response.body);

      for (Map<String, dynamic> item in berryJson) {
        var newBerry = Berry.fromJson(item);
        _berryList.add(newBerry);
      }

      notifyListeners();
    });
  }

  UnmodifiableListView<Berry> get list => UnmodifiableListView(_berryList);

  Berry get(int index) => _berryList[index];

  void delete(int index) async {
    var berry = _berryList[index];
    await _httpClient
        .deleteBerry(berry.id)
        .then((_) => _berryList.removeAt(index))
        .then((_) => notifyListeners());
  }

  void create(String subject, String period) async {
    await _httpClient.createBerry(subject, period).then((response) {
      var newBerryUri = response.headers['location'];
      return _httpClient.loadBerry(newBerryUri);
    }).then((http.Response response) {
      var newBerry = Berry.fromJson(jsonDecode(response.body));
      _berryList.add(newBerry);
      notifyListeners();
    });
  }
}

@immutable
class Berry {
  final String id;
  final String subject;
  final DateTime nextExecution;
  final DateTime lastExecution;
  final String period;

  Berry(this.id, this.subject, this.nextExecution, this.lastExecution,
      this.period);

  Berry.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        subject = json['subject'],
        nextExecution = DateTime.parse(json['nextExecution']),
        lastExecution = DateTime.parse(json['lastExecution']),
        period = json['period'];

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) => other is Berry && other.id == id;
}
