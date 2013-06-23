part of connect;

_StaticMiddleware static({String path: null}) {
  var s = new _StaticMiddleware(path:path);
  return s;
}

class _StaticMiddleware extends Middleware {
  String path;
  Mime mime;

  _StaticMiddleware({String path: null}) {
    if (path != null) {
      this.path = path;
    }
    mime = new Mime();
  }

  Future<bool> handle(Request req, Response res) {
    print("StaticMiddleware.handle");
    final String filePath = req.uri.path == '/' ? '/index.html' : req.uri.path;
    final String filename = "${path}${filePath}";
    final File file = new File(filename);

    Completer<bool> completer = new Completer();
    print("file=$file");
    file.exists().then((bool found) {
      if (! found) {
        print("file does not exist $filename");
        return completer.complete(true);
      }
      print("file exists $filename");
      file.fullPath().then((fullPath) {
        if (!fullPath.startsWith(path)) {
          completer.complete(true);
        }
        Path filePath = new Path(filename);
        String contentType = mime.getType(filePath.extension);
        res.headers.add('content-type', contentType);
        file.openRead().pipe(res).then( (_) {
          completer.complete(false);
        });
      });
    });

    return completer.future;
  }
}
