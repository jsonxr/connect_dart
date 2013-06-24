part of connect;

Middleware router() {
  return new RouterMiddleware();
}

class RouterMiddleware extends Middleware {
  Future<bool> handle(Request req, Response res) {
    _logger.fine("RouterMiddleware");

    //res.statusCode = HttpStatus.NOT_FOUND;
    //res.statusCode = HttpStatus.INTERNAL_SERVER_ERROR;

    HttpSession session = req.session;
    int count = 1;
    if (session.containsKey('count')) {
      count = session['count'];
      count++;
    } else {
      session.remove('count');
    }
    session['count'] = count;

    res.statusCode = HttpStatus.OK;
    res.write('Hello, world from inside RouterMiddleware...');
    res.write("${req.session.id}");
    res.write("count=$count");
    res.close();
    return new Future.value(true);
  }
}
