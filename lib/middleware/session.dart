part of connect;

abstract class SessionManager {
  /**
   * Creates a 128 bit random sessionId
   */
  String createSessionId() {
    var uuid = new Uuid();
    var bytes = new List<int>(16);
    uuid.v4(buffer:bytes);
    return CryptoUtils.bytesToHex(bytes);
  }

  Future<HttpSession> getSession(String sessionId);
  Future<bool> saveSession(HttpSession session);
  Future<bool> destroySession(HttpSession session);
}




// Create a better implementation of HttpSession that enables remote session stores
class Session extends HashMap implements HttpSession {
  Session(SessionManager this._sessionManager);

  bool get isNew => this._isNew;
  set isNew(bool value) => this._isNew = value;

  String get id => this['_id'];
  set id(String value) {
    this['_id'] = value;
  }

  void destroy() {
    this._sessionManager.destroySession(this);
  }
  void set onTimeout(void callback()) {
    // This is a stupid callback in a load balanced environment
  }

  SessionManager _sessionManager;
  bool _isNew;
  String _id;
}

/**
 * Provides a session object for the request
 */
class SessionMiddleware extends Middleware {
  //TODO: Support Expires

  static const String _DART_SESSION_ID = "DARTSESSID";
  SessionManager sessionManager;

  Future<bool> handle(Request req, Response res) {
    Completer<bool> completer = new Completer<bool>();
    Session _session;
    String sessionId = _getSessionId(req);
    this.sessionManager.getSession(sessionId).then((HttpSession session) {
      // 1) Save the session for later use
      _session = session;

      // 2) Save to cookie
      if (session.isNew) {
        this._saveSessionToCookie(req, session);
      }
      // 3) Override existing session and close method
      req.getSession = () {
        return _session;
      };

      var close = res.close;
      res.close = () {
        this.sessionManager.saveSession(_session).then((_) {
          close();
        });
      };
      // 4) We are ready to continue
      completer.complete(true);
    });

    return completer.future;
  }

  void _saveSessionToCookie(HttpRequest req, HttpSession session) {
    if (session.isNew) {
      // Save sessionId to cookie
      HttpResponse res = req.response;
      var cookie = new Cookie(_DART_SESSION_ID, session.id);
      cookie.httpOnly = true;
      cookie.path = "/";
      res.cookies.add(cookie);
    } else {
      //TODO: update cookie expires?
    }
  }

  /**
   * Retrieves the session id from the cookie if it exists.
   */
  String _getSessionId(HttpRequest req) {
    Iterable<String> sessionIds = req.cookies
        .where((cookie) => cookie.name.toUpperCase() == _DART_SESSION_ID)
        .map((cookie) => cookie.value);

    //print("sessionIds: ${sessionIds}");
    if (sessionIds.isEmpty) {
      return null;
    } else {
      if (sessionIds.length > 1) {
        throw "More than one sessionId found";
      } else {
        return sessionIds.first;
      }
    }
  }

}

