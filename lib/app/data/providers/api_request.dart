import 'dart:convert';
import 'dart:io';
import 'package:core_flutter/apps.dart';
import 'package:http/http.dart' as http;

class ApiRequest {
  Map<String, String> _getHeaders() {
    return {
      "content-type": "application/json",
      "x-app": "1",
      "x-device": Platform.isAndroid ? "2" : "1",
      "x-device-name": instanceDeviceInfo.deviceName,
      "x-model-name": instanceDeviceInfo.modelName,
      "x-udid": instanceDeviceInfo.udid,
      "x-os-version": instanceDeviceInfo.osVersion,
      "x-app-version": instanceDeviceInfo.appVersion,
      "x-app-build-version": instanceDeviceInfo.appBuildVersion,
      if (accessToken != null) "Authorization": "Bearer $accessToken",
    };
  }

  Map<String, List<String>> _transformQueryParameters(
      Map<String, dynamic> originalQuery) {
    final transformedQuery = <String, List<String>>{};

    void handleIterable(String key, Iterable iterable) {
      transformedQuery[key] = iterable.map((e) => e.toString()).toList();
    }

    originalQuery.forEach((key, value) {
      if (value == null) return; // Skip null values

      if (value is Iterable) {
        handleIterable(key, value);
      } else if (value is Map) {
        transformedQuery[key] = [jsonEncode(value)];
      } else {
        transformedQuery[key] = [value.toString()];
      }
    });

    return transformedQuery;
  }

  Uri _buildUri(String url, Map<String, dynamic>? query) {
    final transformedQuery = _transformQueryParameters(query ?? {});
    return Uri.parse(url).replace(queryParameters: transformedQuery);
  }

  http.Request _createRequest(
    String method,
    String url, {
    Map<String, dynamic>? query,
    dynamic body,
  }) {
    final uri = _buildUri(url, query);
    final request = http.Request(method, uri)..headers.addAll(_getHeaders());
    _logRequest(request);
    // Set the body if it's provided
    if (body != null) {
      if (body is String) {
        request.body = body; // Assume it's already encoded
      } else if (body is Map || body is List) {
        request.body = jsonEncode(body); // Encode the body as JSON
      } else {
        throw ArgumentError('Body type not supported');
      }
    }
    return request;
  }

  http.Request methodGet(
    String url, {
    Map<String, dynamic>? query,
  }) =>
      _createRequest('GET', url, query: query);

  http.Request methodPost(
    String url,
    dynamic body, {
    Map<String, dynamic>? query,
  }) =>
      _createRequest('POST', url, query: query, body: body);

  http.Request methodPut(
    String url,
    dynamic body, {
    Map<String, dynamic>? query,
  }) =>
      _createRequest('PUT', url, query: query, body: body);

  http.Request methodDelete(
    String url, {
    Map<String, dynamic>? query,
    dynamic body,
  }) =>
      _createRequest('DELETE', url, query: query, body: body);

  http.MultipartRequest uploadMedia(
    String url,
    http.MultipartFile multipartFile, {
    Map<String, dynamic>? query,
  }) {
    final uri = _buildUri(url, query);
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_getHeaders());
    request.files.add(multipartFile);
    return request;
  }

  void _logRequest(http.Request request) {
    print('--- Request ---');
    print('Method: ${request.method}');
    print('URL: ${request.url}');
    print('Headers: ${request.headers}');
    if (request.body.isNotEmpty) {
      print('Body: ${request.body}');
    }
    print('---------------');
  }
}
