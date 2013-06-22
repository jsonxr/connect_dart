//----------------------------------------------------------------------------
// connect_test.dart
// Copyright 2013, Jason Rowland
//----------------------------------------------------------------------------
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:unittest/mock.dart';

import 'package:connect/server.dart';

Future<bool> testfilter (HttpRequest req, HttpResponse res) {
  print("my request ${req.uri}");
  return new Future.value(true);
}

void main() {
  useVMConfiguration();

  group('Connect', () {
    test ("constructor", () {
      var connect = new Connect();
      expect(true, connect != null);
    });

    test ('use should accept FilterFunction Middleware', () {
      var connect = new Connect();
      connect.use(new Middleware.fromFunction(testfilter));
    });
  });
}
