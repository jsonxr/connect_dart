//----------------------------------------------------------------------------
// logger_filter_test.dart
// Copyright 2013, Jason Rowland
//----------------------------------------------------------------------------
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:connect/server.dart';


void main() {
  useVMConfiguration();

  group('Mime', () {
    test("define", () {
      var mimeTypes = {
              'application/xml': ['xml','xsl'],
              'text/plain': ['txt', 'text', 'conf', 'def', 'list', 'log', 'in'],
              'text/html' :['html', 'htm']
                        };
      final mime = new Mime();
      mime.define(mimeTypes);

      expect('application/xml', mime.types['xml']);
      expect('application/xml', mime.types['xsl']);
      expect('text/plain', mime.types['txt']);
      expect('xml', mime.extensions['application/xml']);
    });

    test("load", () {
      final mime = new Mime();
      mime.load();
      expect('application/xml', mime.types['xml']);
      expect('application/xml', mime.types['xsl']);
      expect('text/plain', mime.types['txt']);
      expect('xml', mime.extensions['application/xml']);
    });
  });
}
