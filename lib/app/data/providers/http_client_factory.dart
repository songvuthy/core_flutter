import 'dart:io';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

Client httpClient() {
  return IOClient(HttpClient()
    ..userAgent = 'Core Project/${Platform.version} (Other; HttpClient)');
}
