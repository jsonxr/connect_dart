import 'dart:io';

import 'package:connect/server.dart';
import 'package:args/args.dart';

void main() {
  final args = new Options().arguments.toList();
  final parser = _parser();
  final results = parser.parse(args);
  final hosts = results['host'].toString().split(',');

  var connect = new Connect();
  connect.use(favicon());
  connect.use(logger());
  connect.use(static(path:'${Connect.path}/public'));
  connect.use(mongoSession(uri:'mongodb://127.0.0.1/sessions', collectionName:'sessions'));
  connect.use(new RouterMiddleware());
  connect.bind(hosts: hosts);
}
//complete -o bashdefault -o default -F _brew brew

ArgParser _parser() =>
    new ArgParser()
      ..addFlag('help', negatable: false )
      ..addFlag('verbose', abbr: 'v', help: 'Show additional diagnostic info', negatable: false)
      //..addFlag(name, abbr: , help: , defaultsTo: , negatable: , callback: )
      ..addOption('host', abbr:'h' , help:'host ip address. Specify multiple options to bind on more than one address' , defaultsTo: '127.0.0.1:3000', allowMultiple: false);
      //..addFlag(name, abbr: , help: , defaultsTo: , negatable: , callback: )
