part of connect;

Middleware mongoSession({String uri: "mongodb://127.0.0.1/sessions", String collectionName: "sessions"}) {
  return new _MongoSessionMiddleware(uri:uri, collectionName:collectionName);
}

class _MongoSessionManager extends SessionManager {

  //--------------------------------------------------------------------------
  // Public Constructor and Properties
  //--------------------------------------------------------------------------

  _MongoSessionManager({ String uri: "mongodb://127.0.0.1/sessions",
                         String collectionName: "sessions",
                         WriteConcern writeConcern: WriteConcern.ACKNOWLEDGED })
  {
    _db = new Db(uri);
    _collectionName = collectionName;
  }

  //--------------------------------------------------------------------------
  // SessionManager implementation
  //--------------------------------------------------------------------------
  /**
   * Returns session from the id stored in the cookie.  If no session is
   * associated with the id, or there is no id, then a new session is created.
   */
  @override
  Future<HttpSession> getSession(String sessionId) {
    Completer completer = new Completer<HttpSession>();
    _getCollection().then( (sessions) {
      sessions.findOne({"_id": sessionId}).then((Map d) {
        var _session = new Session(this);
        if (d != null) {
          _session.isNew = false;
          _session.addAll(d);
        } else {
          _session.isNew = true;
          _session.id = createSessionId();
        }
        //TODO: _session._markSeen();
        completer.complete(_session);
      });
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  /**
   * Saves the session to the store
   */
  @override
  Future<bool> saveSession(HttpSession session) {
    Completer<bool> completer = new Completer();
    _getCollection().then( (sessions) {
      sessions.update({'_id':session.id}, session, upsert: true).then((d) {
        _logger.fine("mongo response:=$d");
        bool updated = d['updatedExisting'];
        completer.complete(updated);
      });
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  /**
   * Removes the session from the store
   */
  @override
  Future<bool> destroySession(HttpSession session) {
    Completer<bool> completer = new Completer();
    _getCollection().then( (sessions) {
      sessions.remove({'_id':session.id}).then((d) {
        completer.complete(true);
      });
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

//  void immediate() {
//    var selector = {"_id": _session.id, 'name.middle': 'Warner_old'};
//    //var selector = {"_id": _session.id};
//    var document = {"\$set": { 'name.middle': 'Warner_new' } };
//    //var document = _session
//
//
//    sessions.update(selector, document, upsert: true).then((d)...
//  }

  //--------------------------------------------------------------------------
  // Private
  //--------------------------------------------------------------------------

  /**
   * Opens the MongoDb and returns the sessions collection
   */
  Future<DbCollection> _getCollection() {
    if (_db.connection.connected) {
      DbCollection sessions = _db.collection(_collectionName);
      return new Future.value(sessions);
    } else {
      Completer<DbCollection> completer = new Completer();
      _db.open().then((_){
        DbCollection sessions = _db.collection(_collectionName);
        completer.complete(sessions);
      }).catchError((e) {
        completer.completeError(e);
      });
      return completer.future;
    }
  }

  Db _db;
  DbCollection _sessions;
  String _collectionName;
}

/**
 * Provides a mongo backed session for a request
 */
class _MongoSessionMiddleware extends SessionMiddleware {
  //TODO: Modify session so it returns a future and only queries mongo on requests that actually access session
  _MongoSessionMiddleware({String uri, String collectionName}) {
    this.sessionManager = new _MongoSessionManager(uri: uri, collectionName: collectionName);
  }

}




