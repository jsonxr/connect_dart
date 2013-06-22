part of connect;

Connect connect({String path: null}) {
  var c = new Connect();
  return c;
}

class Connect {
  static const int DEFAULT_PORT = 3000;
  static const List<String> LISTENING = const ["127.0.0.1:$DEFAULT_PORT"];

  static final String path = _getPathFromRunningScript();

  Connect() {
  }

  List<Middleware> get middleware => _middleware;

  void use(Middleware middleware) {
    _middleware.add(middleware);
  }

  void bind({hosts: LISTENING, int backlog: 0}) {
    hosts.forEach( (String h) {
      List<String> hostport = h.split(':');
      final port = (hostport.length == 2)
          ? int.parse(hostport[1])
          : DEFAULT_PORT;
      final hostname = hostport[0];
      HttpServer.bind(hostname, port, backlog: backlog).then((server) {
        this.listen(server);
      });
      final httpPort = (port == 80)
          ? ''
          : ':$port';
      print("listening on http://$hostname$httpPort");
      print(" at $path");
    });
  }

  void _checkConfiguration() {
    _middleware.forEach((middleware) {
      middleware.checkConfiguration(this);
    });
  }

  void listen(Stream<HttpRequest> incoming) {
    _checkConfiguration();

    incoming.listen((HttpRequest request) {
      var req = new Request(request);
      var res = req.response;
      print("");
      print(req.uri);
      bool cont = true;
      doWhile(_middleware, (Middleware middleware) {
        //print()
        var _mirror = reflect(middleware);
        print(_mirror.type.toString());
        return middleware.handle(req, res).then( (c) {
          cont = c;
          print("middleware continue=$cont");
          return new Future.value(c);
        });
      }).then((_) {
        //res.close();
//        if (cont) {
//          res.write("continue...");
//        } else {
//          res.write("don't continue.");
//        }
      });

    });
  }

  void handleRequest(Request req, Response res) {
    print("server.handleRequest");
  }

  //--------------------------------------------------------------------------
  // Private
  //--------------------------------------------------------------------------
  final List<Middleware> _middleware = <Middleware>[];
  var _incoming;
}


String _getPathFromRunningScript() {
  Options options = new Options();
  File script = new File(options.script);
  Directory dir = script.directory;
  String fullPath = script.fullPathSync();
  Path base = new Path(fullPath).directoryPath;
  return base.toNativePath();
}

Future doWhile(Iterable iterable, Future<bool> action(i)) {
  return _doWhile(iterable.iterator, action);
}

Future _doWhile(Iterator iterator, Future<bool> action(i)) {
  if (iterator.moveNext()) {
    return action(iterator.current).then((bool result) {
      if (result) {
        return _doWhile(iterator, action);
      } else {
        return new Future.value(false);
      }
    });
  } else {
    new Future.value(false);
  }
}