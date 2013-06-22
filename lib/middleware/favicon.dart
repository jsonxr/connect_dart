part of connect;

_FavIconMiddleware favicon({String path: null}) {
  var s = new _FavIconMiddleware(path:path);
  return s;
}

class _FavIconMiddleware extends Middleware {
  static const int ONE_DAY = 86400;
  String path;
  int maxAgeSeconds = ONE_DAY;

  _FavIconMiddleware({String path: null, int maxAgeSeconds: ONE_DAY}) {
    if (path != null) {
      this.path = path;
    } else {
      this.path = Connect.path + '/public/favicon.ico';
    }
    this.maxAgeSeconds = maxAgeSeconds;
  }

  Future<bool> handle(Request req, Response res) {
    print("_FavIconMiddleware.handle");
    if (req.uri.path == '/favicon.ico') {
      Completer<bool> completer = new Completer();
      final File file = new File('${path}');

      file.exists().then((found) {
        if (! found) {
          return completer.complete(true);
        }

        file.length().then((length) {
          print("FavIcon - length: $length");
          res.headers.add('Content-Type', 'image/x-icon');
          res.headers.add('Content-Length', "$length");
          //res.headers.add('ETag', '"' + utils.md5(buf) + '"');
          res.headers.add('Cache-Control', 'public, max-age=$maxAgeSeconds');

          return file.openRead()
            .pipe(res)
            .then( (_) {
              print("FavIcon - then open read");
              completer.complete(false);
            });

        });
      }).catchError((e){
        print("FavIcon - error");
        completer.completeError(e);
      });




//      file.exists()
//        .then((found) {
//            if (found) {
//              print("FavIcon - found");
//              return file.length();
//            } else {
//              print("FavIcon - not found");
//              completer.complete(true);
//            }
//        }).then((length) {
//          print("FavIcon - length: $length");
//          res.headers.add('Content-Type', 'image/x-icon');
//          res.headers.add('Content-Length', "$length");
//          //res.headers.add('ETag', '"' + utils.md5(buf) + '"');
//          res.headers.add('Cache-Control', 'public, max-age=$maxAgeSeconds');
//          return file.openRead()
//            .pipe(res);
//        }).then( (_) {
//          print("FavIcon - then open read");
//          completer.complete(false);
//        }).catchError((e){
//          print("FavIcon - error");
//          completer.completeError(e);
//        });

      print("FavIcon - completer.future");
      return completer.future;
    } else {
      // Doesn't match, continue
      print("FavIcon - doesn't match");
      return new Future.value(true);
    }
  }
}
