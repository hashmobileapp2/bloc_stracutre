import 'dart:convert';

import 'package:dio/dio.dart' as d;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../utils/utility.dart';
import 'api_constants.dart';
import 'unathorised_exception.dart';

class ApiClient {
  final Client _client;

  ApiClient(this._client);

  dynamic get(String path, {Map<String, String>? params}) async {
    // await Future.delayed(const Duration(milliseconds: 500));

    final header = params;

    /// print request data
    Logger.log(
        tag: 'GET METHOD \n\n REQUEST_URL :',
        message:
            '\n ${getPath(path, null)} \n\n REQUEST_HEADER : ${header?.toString().replaceAll(': ', ':')}  \n\n REQUEST_DATA : ${params.toString().replaceAll(': ', ':')}',
        logIcon: Logger.info);

    final response = await _client
        .get(
      getPath(path, params),
      headers: header!,
    )
        .timeout(
      Duration(seconds: 30),
      onTimeout: () {
        ///FOR REQ TIMEOUT
        Logger.log(
            message: "Exception---->Request timed out!", logIcon: Logger.error);
        return http.Response('Request timed out!', 408);
      },
    );
    apiResponseResult(response: response, url: path);
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return response.body;
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw UnauthorisedException();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  dynamic post(String path,
      {Map<dynamic, dynamic>? params, Map<String, String>? header}) async {
    final headers = header ??
        {
          'Content-Type': 'application/json',
          "x-api-key": "ApiConstants.XAPITOKEN",
        };

    /// print request data
    Logger.log(
        tag: 'POST METHOD \n\n REQUEST_URL :',
        message:
            '\n ${getPath(path, null)} \n\n REQUEST_HEADER : ${header?.toString().replaceAll(': ', ':')}  \n\n REQUEST_DATA : ${params.toString().replaceAll(': ', ':')}',
        logIcon: Logger.info);
    final response = await _client
        .post(
      getPath(path, null),
      body: jsonEncode(params),
      headers: headers,
    )
        .timeout(
      Duration(seconds: 30),
      onTimeout: () {
        ///FOR REQ TIMEOUT
        Logger.log(
            message: "Exception---->Request timed out!", logIcon: Logger.error);
        return http.Response('Request timed out!', 408);
      },
    );

    apiResponseResult(response: response, url: path);
    return response.body;
    // if (response.statusCode >= 200 && response.statusCode <= 299) {
    //   return response.body;
    // } else if (response.statusCode >= 400 && response.statusCode <= 499) {
    //   throw UnauthorisedException();
    // } else {
    //   throw Exception(response.reasonPhrase);
    // }
  }

  dynamic deleteWithBody(String path, {Map<dynamic, dynamic>? params}) async {
    Request request = Request('DELETE', getPath(path, null));
    request.headers['Content-Type'] = 'application/json';
    request.body = jsonEncode(params);

    /// print request data
    Logger.log(
        tag: 'DELETE METHOD \n\n REQUEST_URL :',
        message:
            '\n ${getPath(path, null)} \n\n REQUEST_HEADER : ${request.headers.toString().replaceAll(': ', ':')}  \n\n REQUEST_DATA : ${params.toString().replaceAll(': ', ':')}',
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

  /// put file upload api call common handler
  dynamic putFileFormDataUploadApiRequest(
    String path, {
    Map<dynamic, dynamic>? params,
    Map<String, String>? header,
  }) async {
    ///Params for send req
    ///
    // Map<String, dynamic> params = {
    //   "fields": [],
    //   "files": [
    //     {"profile": filePath.first.path}
    //   ],
    // };
    ///header for send req
    ///
    //   header: {
    //     'Content-Type': 'multipart/form-data',
    //   "Authorization": token,
    // },
    final headers = header ??
        {
          'Content-Type': 'application/json',
          "x-api-key": "ApiConstants.XAPITOKEN",
        };
    Logger.log(tag: 'PATH', message: path, logIcon: Logger.info);

    /// print request data
    Logger.log(
        tag: 'POST METHOD \n\n REQUEST_URL :',
        message:
            '\n ${getPath(path, null)} \n\n REQUEST_HEADER : ${headers.toString().replaceAll(': ', ':')}  \n\n REQUEST_DATA : ${params.toString().replaceAll(': ', ':')}',
        logIcon: Logger.info);
    var request = http.MultipartRequest(
      'POST',
      getPath(path, null),
    );

    ///FOR HEADER
    request.headers.addAll(headers);

    ///FOR FIELDS
    for (int i = 0; i < params?['fields'].length; i++) {
      // params?['files'][i].values.toString().substring(1, (params['files'][i].values.toString().length)-1);
      final key = params?['fields'][i]
          .keys
          .toString()
          .substring(1, params['fields'][i].keys.toString().length - 1);
      final value = params?['fields'][i]
          .values
          .toString()
          .substring(1, params['fields'][i].values.toString().length - 1);
      // Logger.log(message: "FOR fields----------KEY-----${key}--------values-----${value}--------");
      request.fields.addAll({key ?? "": value ?? ""});
    }

    ///FOR FILES
    for (int i = 0; i < params?['files'].length; i++) {
      final key = params?['files'][i]
          .keys
          .toString()
          .substring(1, params['files'][i].keys.toString().length - 1);
      final value = params?['files'][i]
          .values
          .toString()
          .substring(1, params['files'][i].values.toString().length - 1);
      // Logger.log(message: "FOR files----------KEY-----${key}--------values-----${value}--------");
      request.files.add(
          await http.MultipartFile.fromPath('${key ?? ""}', '${value ?? ""}'));
    }

    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    /// Response
    Logger.log(
        tag: '$path __🌱__CODE ${response.statusCode.toString()} : ',
        message: responseString,
        logIcon: Logger.warning);
    return responseString;
  }

  Uri getPath(String path, Map<dynamic, dynamic>? params) {
    var paramsString = '';
    if (params?.isNotEmpty ?? false) {
      params?.forEach((key, value) {
        paramsString += '&$key=$value';
      });
    }

    return Uri.parse('${ApiConstants.BASE_URL}$path');
  }

  /// DIO REQUESTS
  ///
  /// DIO GET METHOD
  dynamic dioGet(String path, {Map<String, String>? params}) async {
    // await Future.delayed(const Duration(milliseconds: 500));

    final headers = {
      'Content-Type': 'application/json',
      "x-api-key": "ApiConstants.XAPITOKEN",
    };

    /// print request data
    Logger.log(
        tag: 'GET METHOD \n\n REQUEST_URL :',
        message:
            '\n ${getPath(path, null)} \n\n REQUEST_HEADER : ${headers.toString().replaceAll(': ', ':')}  \n\n REQUEST_DATA : ${params.toString().replaceAll(': ', ':')}',
        logIcon: Logger.info);
    d.BaseOptions options = d.BaseOptions(
        baseUrl: ApiConstants.BASE_URL,
        followRedirects: false,
        validateStatus: (status) => true,
        responseType: d.ResponseType.plain,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30));
    d.Dio dio = d.Dio(options);

    d.Response response = await dio.post(path,
        data: params, options: d.Options(headers: headers));
    apiResponseResult(response: response, url: path, isDio: true);
    return response.data;
  }

  /// DIO POST METHOD
  dynamic dioPost(String path,
      {required Map<String, dynamic> params,
      Map<String, String>? header}) async {
    /// print request data
    Logger.log(
        tag: 'POST METHOD \n\n REQUEST_URL :',
        message:
            '\n ${getPath(path, null)} \n\n REQUEST_HEADER : ${header?.toString().replaceAll(': ', ':')}  \n\n REQUEST_DATA : ${params.toString().replaceAll(': ', ':')}',
        logIcon: Logger.info);
    d.BaseOptions options = d.BaseOptions(
        baseUrl: ApiConstants.BASE_URL,
        followRedirects: false,
        validateStatus: (status) => true,
        responseType: d.ResponseType.plain,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30));
    d.Dio dio = new d.Dio(options);
    final headers = header ??
        {
          'Content-Type': 'application/json',
          "x-api-key": "ApiConstants.XAPITOKEN",
        };

    ///USED WHEN FORM DATA IS USED
    d.FormData formData = new d.FormData.fromMap(params);
    d.Response response = await dio.post(path,
        data: params, options: d.Options(headers: headers));

    apiResponseResult(response: response, url: path, isDio: true);
    return response.data;
  }

  /// DIO PUT METHOD
  dynamic dioPut(String path,
      {required Map<String, dynamic> params,
      Map<String, String>? header}) async {
    /// print request data
    Logger.log(
        tag: 'POST METHOD \n\n REQUEST_URL :',
        message:
            '\n ${getPath(path, null)} \n\n REQUEST_HEADER : ${header?.toString().replaceAll(': ', ':')}  \n\n REQUEST_DATA : ${params.toString().replaceAll(': ', ':')}',
        logIcon: Logger.info);
    d.BaseOptions options = d.BaseOptions(
        baseUrl: ApiConstants.BASE_URL,
        followRedirects: false,
        validateStatus: (status) => true,
        responseType: d.ResponseType.plain,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30));
    d.Dio dio = d.Dio(options);
    final headers = header ??
        {
          'Content-Type': 'application/json',
          "x-api-key": "ApiConstants.XAPITOKEN",
        };

    ///USED WHEN FORM DATA IS USED
    d.FormData formData = d.FormData.fromMap(params);
    d.Response response = await dio.put(path,
        data: formData, options: d.Options(headers: headers));

    apiResponseResult(response: response, url: path, isDio: true);
    return response.data;
  }

  /// DIO DELETE METHOD
  dynamic dioDelete(String path,
      {required Map<String, dynamic> params,
      Map<String, String>? header}) async {
    /// print request data
    Logger.log(
        tag: 'POST METHOD \n\n REQUEST_URL :',
        message:
            '\n ${getPath(path, null)} \n\n REQUEST_HEADER : ${header?.toString().replaceAll(': ', ':')}  \n\n REQUEST_DATA : ${params.toString().replaceAll(': ', ':')}',
        logIcon: Logger.info);
    d.BaseOptions options = d.BaseOptions(
        baseUrl: ApiConstants.BASE_URL,
        followRedirects: false,
        validateStatus: (status) => true,
        responseType: d.ResponseType.plain,
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30));
    d.Dio dio = new d.Dio(options);
    final headers = header ??
        {
          'Content-Type': 'application/json',
          "x-api-key": "ApiConstants.XAPITOKEN",
        };

    ///USED WHEN FORM DATA IS USED
    // d.FormData formData = new d.FormData.fromMap(params);
    d.Response response = await dio.delete(path,
        data: params, options: d.Options(headers: headers));

    apiResponseResult(response: response, url: path, isDio: true);
    return response.data;
  }

  ///FOR PRINT LOG OF API RESPONSE

  void apiResponseResult(
      {required dynamic response, required String url, bool isDio = false}) {
    if (response.statusCode >= 100 && response.statusCode <= 199) {
      /// INFORMATIONAL RESPONSES (100–199)
      Logger.log(
          tag: '$url __🌱__CODE 100 TO 199 : ',
          message: isDio ? response.data : response.body.toString(),
          logIcon: Logger.warning);
    } else if (response.statusCode >= 200 && response.statusCode <= 299) {
      /// SUCCESSFUL RESPONSES (200–299)
      Logger.log(
          tag: '$url __🌱__CODE 200 TO 299 : ',
          message: isDio ? response.data : response.body.toString(),
          logIcon: Logger.cloud);
    } else if (response.statusCode >= 300 && response.statusCode <= 399) {
      /// REDIRECTS (300–399)
      Logger.log(
          tag: '$url __🌱__CODE 300 TO 399 : ',
          message: isDio ? response.data : response.body.toString(),
          logIcon: Logger.error);
    } else if (response.statusCode >= 400 && response.statusCode <= 499) {
      /// CLIENT ERRORS (400–499)
      Logger.log(
          tag: '$url __🌱__CODE 400 TO 499 : ',
          message: isDio ? response.data : response.body.toString(),
          logIcon: Logger.error);
    } else if (response.statusCode >= 500 && response.statusCode <= 599) {
      /// SERVER ERRORS (500–599)
      Logger.log(
          tag: '$url __🌱__CODE 500 TO 599 : ',
          message: isDio ? response.data : response.body.toString(),
          logIcon: Logger.error);
    } else {
      /// OTHER ERROR'S
      Logger.log(
          tag: '$url __🌱__OTHER : ',
          message: isDio ? response.data : response.body.toString(),
          logIcon: Logger.error);
    }
  }
}
