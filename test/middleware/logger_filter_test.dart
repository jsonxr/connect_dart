//----------------------------------------------------------------------------
// logger_filter_test.dart
// Copyright 2013, Jason Rowland
//----------------------------------------------------------------------------
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:connect/server.dart';
import '../http_mocks.dart';

void main() {
  useVMConfiguration();

  group('LoggerFilter', () {
    test("handle", () {
      var filter = new LoggerMiddleware();
      var origReq = new HttpRequestMock(Uri.parse('/'));
      var req = new Request(origReq);
      var res = req.response;
      filter.handle(req, res);
    });
  });
}
