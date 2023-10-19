import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

Future<List<dynamic>> getAddressFromCanadapost(String searchTerm) async {
  final url = Uri.parse(
      'http://ws1.postescanada-canadapost.ca/AddressComplete/Interactive/Find/v2.10/json3.ws');
  final Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  final body = {
    'Key': 'BZ31-UZ44-RE73-DH89',
    'SearchTerm': searchTerm,
  };

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['Items'].length == 1 &&
        jsonResponse['Items'][0]['Error'] != null) {
      debugPrint(jsonResponse['Items'][0]['Description']);
      return [];
    } else {
      if (jsonResponse['Items'].length == 0) {
        debugPrint('Sorry, there were no results');
        return [];
      } else {
        // debugPrint(jsonResponse['Items']);
        //setAddressSearched(jsonResponse['Items']); // Depends on how you handle this in Dart.
        return jsonResponse['Items'];
      }
    }
  } else {
    debugPrint('Request failed with status: ${response.statusCode}.');
    return [];
  }
}