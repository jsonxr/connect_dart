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

  void use(Middleware middleware, {Pattern pattern: null}) {
    if (pattern != null) {
      print("pattern=$pattern");
      var mirror = reflect(pattern);
      print(mirror.type.simpleName);
    }
    middleware.pattern = pattern;
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
      bool cont = true;
      doWhile(_middleware, (Middleware middleware) {
        InstanceMirror _mirror = reflect(middleware);
        if (middleware.pattern == null || matchesFull(middleware.pattern, req.uri.path)) {
          print("match ${MirrorSystem.getName(_mirror.type.simpleName)}");
          return middleware.handle(req, res).then( (c) {
            cont = c;
            return c;
          });
        } else {
          print("no match pattern: ${middleware.pattern} for ${req.uri.path}! ${MirrorSystem.getName(_mirror.type.simpleName)}");
          return new Future.value(true);
        }
      }).then((_) {
        if (cont) {
          handle404(req, res);
        }
      }).catchError((e) {
        //TODO: Figure out how to have an application wide error handlier so we don't have to remember
        // .catchError((e)... everywhere
        _logger.severe(e);
        handle500(req, res, e);
      });
    });
  }

  void handle404(req, res) {
    res.statusCode = 404;
    res.close();
  }

  void handle500(Request req, Response res, e) {
    res.statusCode = 500;
    //res.writeln(e);
    res.close();
  }

  void handleRequest(Request req, Response res) {
    _logger.info("server.handleRequest");
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