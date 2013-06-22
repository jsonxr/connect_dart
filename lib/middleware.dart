part of connect;

typedef Future<bool> MiddlewareFunction(Request req, Response res);
typedef Future OnCloseFunction();

class Middleware {
  Middleware();
  Middleware.fromFunction(MiddlewareFunction this._func);

  Future<bool> handle(Request req, Response res) {
    if (_func != null) {
      return _func(req, res);
    }
  }

  void checkConfiguration(Connect connect) {
  }

  MiddlewareFunction _func;
}
