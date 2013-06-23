//----------------------------------------------------------------------------
// logger_filter_test.dart
// Copyright 2013, Jason Rowland
//----------------------------------------------------------------------------
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import 'package:connect/server.dart';
import 'dart:io';
import 'dart:json';


void main() {
  useVMConfiguration();

  group('Mime', () {

    test("constructor", () {
      final mime = new Mime();

      expect('application/xml', mime.getType('xml'));
      expect('application/xml', mime.getType('xsl'));
      expect('text/plain', mime.getType('txt'));
      expect('xml', mime.getExtension('application/xml'));
    });

    test("define", () {
      var mimeTypes = [
              {'application/xml': ['xml','xsl']},
              {'text/plain': ['txt', 'text', 'conf', 'def', 'list', 'log', 'in']},
              {'text/html' :['html', 'htm']},
              ];
      final mime = new Mime();
      mime.define(mimeTypes);

      expect('application/xml', mime.getType('xml'));
      expect('application/xml', mime.getType('xsl'));
      expect('text/plain', mime.getType('txt'));
      expect('xml', mime.getExtension('application/xml'));
    });

    test("loadApacheMimeTypesFile", () {
      final String fileName = "test/mime.types";
      final Mime mime = new Mime();
      mime.loadApacheMimeTypesFile(fileName).then(expectAsync1((_) {
        print("i'm here!");
        expect('application/xml', mime.getType('xml'));
        expect('application/xml', mime.getType('xsl'));
        expect('text/plain', mime.getType('txt'));
        expect('xml', mime.getExtension('application/xml'));
      }));
    });

    test("saveToMimeTypesDotDart", () {
      final String fileName = "test/mime.types";
      final Mime mime = new Mime();
      mime.loadApacheMimeTypesFile(fileName).then(expectAsync1((_) {
        mime.saveToMimeTypesDotDart('mime_types.test.dart').then(expectAsync1((_) {
        }));
      }));
    });

  });
}
