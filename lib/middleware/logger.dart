part of connect;

/**
 * immediate: Log the URI immediately as soon as the filter receives the
 * request.  The default is false because we don't yet know the status.
 */
Middleware logger({bool immediate: false}) {
  return new _LoggerMiddleware(immediate: immediate);
}

class _LoggerMiddleware extends Middleware {
  _LoggerMiddleware({bool immediate: false}) {
    _immediate = immediate;
  }

  Future<bool> handle(Request req, Response res) {
    // Intercept the default close so we can write afterwards
    if (_immediate) {
      printLogMessage(res, req);
    } else {
      var close = res.close;
      res.close = () {
        printLogMessage(res, req);
        return close();
      };
    }
    return new Future.value(true);
  }

  void printLogMessage(Response res, Request req) {
    String color = _getColorFromStatusCode(res.statusCode);
    var date = new DateTime.now().toUtc();
    if (_immediate) {
      String mystr = "$GRAY${req.method} ${req.uri} $GRAY${date}";
      print(mystr + "$WHITE");
    } else {
      String mystr = "$GRAY${req.method} ${req.uri} ${color}${res.statusCode} $GRAY${date}";
      print(mystr + "$WHITE");
    }
  }

  void checkConfiguration(Connect connect) {
    if (connect.middleware.last != this) {
      //print("Warning, if logger is not last, you can't use status.");
    }
  }

  String _getColorFromStatusCode(int statusCode) {
    if (statusCode >= 500) {
      return RED;
    } else if (statusCode >= 400) {
      return YELLOW;
    } else if (statusCode >= 300) {
      return CYAN;
    } else {
      return GREEN;
    }
  }

  bool _immediate;

//  final Map<String,String> formats = {
//    'default': ':remote-addr - - [:date] ":method :url HTTP/:http-version" :status :res[content-length] ":referrer" ":user-agent"',
//    'short': ':remote-addr - :method :url HTTP/:http-version :status :res[content-length] - :response-time ms',
//    'tiny': ':method :url :status :res[content-length] - :response-time ms'
//  };

  static const String WHITE = "\x1b[0m";
  static const String GRAY = "\x1b[90m";
  static const String GREEN = "\x1b[32m";
  static const String YELLOW = "\x1b[33m";
  static const String RED = "\x1b[31m";
  static const String CYAN = "\x1b[36m";

}
