//----------------------------------------------------------------------------
// connect_test.dart
// Copyright 2013, Jason Rowland
//----------------------------------------------------------------------------
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:unittest/mock.dart';

import 'package:connect/server.dart';


import 'package:route/pattern.dart';
import 'package:route/url_pattern.dart';


Future<bool> testfilter (HttpRequest req, HttpResponse res) {
  print("my request ${req.uri}");
  return new Future.value(true);
}

void main() {
  useVMConfiguration();

  group('Connect', () {
    test ("constructor", () {
      var connect = new Connect();
      expect(connect != null, true);
    });

    test ('use should accept FilterFunction Middleware', () {
      var connect = new Connect();
      connect.use(new Middleware.fromFunction(testfilter));
    });

    test ('check filter match', () {
      expect(matchesFull(new UrlPattern('/foo/(.*)'), '/foo/asdf'), true);
      expect(matchesFull(r'/foo/(.*)', '/foo/asdf'), true);
    });
  });
}
