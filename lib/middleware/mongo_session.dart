part of connect;

_MongoSessionMiddleware mongoSession() {
  return new _MongoSessionMiddleware();
}

class _MongoSessionMiddleware extends Middleware {
  Future<bool> handle(Request req, Response res) {
    req.getSession = () {
      print("get session from mongo!");
      return req.wrapped.session;
    };
    return new Future.value(true);
  }
}
