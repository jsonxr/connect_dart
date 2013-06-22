part of connect;

LoggerMiddleware logger() {
  return new LoggerMiddleware();
}

class LoggerMiddleware extends Middleware {
  Future<bool> handle(Request req, Response res) {
    var close = res.close;
    res.close = () {
      print("logger.close...");
      //print("LoggerMiddleware");
      //res.write('Hello, world from inside LoggerMiddleware...');
      String color = _getColorFromStatusCode(res.statusCode);
      var date = new DateTime.now().toUtc();
      String mystr = "$GRAY${req.method} ${req.uri} ${color}${res.statusCode} $GRAY${date}";
      print(mystr + "$WHITE");

      return close();
    };

    var write = res.write;
    res.write = (Object obj) {
      print("logger: $obj");
      write(obj);
    };

    return new Future.value(true);
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
