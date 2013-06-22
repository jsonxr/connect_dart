//----------------------------------------------------------------------------
// server_test.dart
// Copyright 2013, Jason Rowland
//----------------------------------------------------------------------------
library request_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:unittest/mock.dart';

import 'package:connect/server.dart';
import 'http_mocks.dart';

void main() {
  useVMConfiguration();

  group('HttpRequest', () {
    test ("attributes", (){
      var origReq = new HttpRequestMock(Uri.parse('/'));
      var req = new Request(origReq);
      req.attributes['username'] = 'jason';
      expect(req.attributes['username'], 'jason');
    });
    
    test("request[]", () {
      var origReq = new HttpRequestMock(Uri.parse('/'));
      var req = new Request(origReq);
      req.username = 'jason';
      expect(req.username, 'jason');
    });
  });  
}
