part of connect;

Middleware favicon({String path: null}) {
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
    if (req.uri.path == '/favicon.ico') {
      Completer<bool> completer = new Completer();
      final File file = new File('${path}');

      file.exists().then((found) {
        //TODO Comment this out and test error handling
        if (! found) {
          return completer.complete(true);
        }

        file.length().then((length) {
          res.headers.add('Content-Type', 'image/x-icon');
          res.headers.add('Content-Length', "$length");
          //TODO: ETag
          //res.headers.add('ETag', '"' + utils.md5(buf) + '"');
          res.headers.add('Cache-Control', 'public, max-age=$maxAgeSeconds');

          return file.openRead()
            .pipe(res)
            .then( (_) {
              completer.complete(false);
            }).catchError((e) {
              completer.completeError(e);
            });

        }).catchError((e) {
          completer.completeError(e);
        });
      }).catchError((e){
        completer.completeError(e);
      });

      return completer.future;
    } else {
      return new Future.value(true);
    }
  }
}
