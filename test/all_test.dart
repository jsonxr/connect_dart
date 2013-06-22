//----------------------------------------------------------------------------
// server_test.dart
// Copyright 2013, Jason Rowland
//----------------------------------------------------------------------------
import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

import 'connect_test.dart' as connect_test;
import 'request_test.dart' as request_test;
import 'response_test.dart' as response_test;

void main() {
  useVMConfiguration();
  connect_test.main();
  request_test.main();
  response_test.main();
}
