//----------------------------------------------------------------------------
// server_test.dart
// Copyright 2013, Jason Rowland
//----------------------------------------------------------------------------
library response_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:unittest/mock.dart';

import 'package:connect/server.dart';
import 'http_mocks.dart';

void main() {
  useVMConfiguration();

  group('HttpResponse', () {
    test("delegate", () {
      var origRes = new HttpResponseMock();
      var res = new Response(origRes);
    });
  });  
}
