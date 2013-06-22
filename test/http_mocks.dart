import 'dart:async';
import 'dart:io';
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:unittest/mock.dart';

import 'connect_test.dart' as connect_test;


class HttpResponseMock extends Mock implements HttpResponse {
  int statusCode;
  var _onClose;
  Future close() {
    if (_onClose != null) {
      _onClose();
    }
  }
}

class HttpRequestMock extends Mock implements HttpRequest {
  Uri uri;
  String method;
  HttpResponseMock response = new HttpResponseMock();
  HttpRequestMock(this.uri, {this.method});
}
