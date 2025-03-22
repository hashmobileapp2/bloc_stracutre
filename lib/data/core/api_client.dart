import 'dart:convert';

import 'package:http/http.dart';

import '../../utils/utility.dart';
import 'api_constants.dart';

import 'unathorised_exception.dart';

class ApiClient {
  final Client _client;

  ApiClient(this._client);

  dynamic get(String path, {Map<dynamic, dynamic>? params}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final header = {
      'Content-Type': 'application/json',
    };

    /// print request data
    Logger.log(
        tag: 'GET METHOD \n\n REQUEST_URL :',
        message:
            '\n ${getPath(path, params)} \n\n REQUEST_HEADER : ${header.toString()}  \n\n REQUEST_DATA : ${params.toString()}',
        logIcon: Logger.info);

    final response = await _client.get(
      getPath(path, params),
      headers: header,
    );
    apiResponseResult(response: response, url: path);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic post(String path, {Map<dynamic, dynamic>? params}) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    /// print request data
    Logger.log(
        tag: 'POST METHOD \n\n REQUEST_URL :',
        message:
            '\n ${getPath(path, null)} \n\n REQUEST_HEADER : ${headers.toString()}  \n\n REQUEST_DATA : ${params.toString()}',
        logIcon: Logger.info);
    final response = await _client.post(
      getPath(path, null),
      body: jsonEncode(params),
      headers: headers,
    );
    apiResponseResult(response: response, url: path);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic deleteWithBody(String path, {Map<dynamic, dynamic>? params}) async {
    Request request = Request('DELETE', getPath(path, null));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode(params);

    /// print request data
    Logger.log(
        tag: 'DELETE METHOD \n\n REQUEST_URL :',
        message:
            '\n ${request.url.path} \n\n REQUEST_HEADER : ${request.headers.toString()}  \n\n REQUEST_DATA : ${params.toString()}',
        logIcon: Logger.info);

    final response = await _client.send(request).then(
          (value) => Response.fromStream(value),
        );
    apiResponseResult(response: response, url: path);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Uri getPath(String path, Map<dynamic, dynamic>? params) {
    var paramsString = '';
    if (params?.isNotEmpty ?? false) {
      params?.forEach((key, value) {
        paramsString += '&$key=$value';
      });
    }

    return Uri.parse(
        '${ApiConstants.BASE_URL}$path?api_key=${ApiConstants.API_KEY}$paramsString');
  }

  void apiResponseResult({required Response response, required String url}) {
    if (response.statusCode >= 100 && response.statusCode <= 199) {
      /// Informational responses (100–199)
      Logger.log(
          tag: '$url __🌱__CODE 100 TO 199 : ',
          message: response.body.toString(),
          logIcon: Logger.warning);
    } else if (response.statusCode >= 200 && response.statusCode <= 299) {
      /// Successful responses (200–299)
      Logger.log(
          tag: '$url __🌱__CODE 200 TO 299 : ',
          message: response.body.toString(),
          logIcon: Logger.cloud);
    } else if (response.statusCode >= 300 && response.statusCode <= 399) {
      /// Redirects (300–399)
      Logger.log(
          tag: '$url __🌱__CODE 300 TO 399 : ',
          message: response.body.toString(),
          logIcon: Logger.error);
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {
      /// Client errors (400–499)
      Logger.log(
          tag: '$url __🌱__CODE 400 TO 499 : ',
          message: response.body.toString(),
          logIcon: Logger.error);
    } else if (response.statusCode >= 500 && response.statusCode <= 599) {
      /// Server errors (500–599)
      Logger.log(
          tag: '$url __🌱__CODE 500 TO 599 : ',
          message: response.body.toString(),
          logIcon: Logger.error);
    } else {
      /// Other error's
      Logger.log(
          tag: '$url __🌱__OTHER : ',
          message: response.body.toString(),
          logIcon: Logger.error);
    }
  }
}
