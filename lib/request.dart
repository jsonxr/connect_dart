part of connect;


typedef HttpSession GetSessionFunction();

class Request extends Wrapper<HttpRequest> implements HttpRequest {

  Request(HttpRequest _httpRequest): super(_httpRequest) {
    _attributes = new Map<String, dynamic>();
    _response = new Response(_httpRequest.response);

    this.getSession = () {
      return _httpRequest.session;
    };
  }

  HttpSession get session => this.getSession();
  GetSessionFunction getSession;
  HttpResponse get response => _response;
  Map<String, dynamic> get attributes => _attributes;

  dynamic noSuchMethod(Invocation invocation) {
    // If the property is not in the underlying class, return it from the attributes
    var mirror = classMirror.members[invocation.memberName];
    if (mirror == null) {
      var name = MirrorSystem.getName(invocation.memberName);
      // Check to see if we have an attribute
      if (invocation.isGetter && this._attributes.containsKey(name)) {
        return this._attributes[name];
      } else if (invocation.isSetter) {
        name = name.substring(0, name.length - 1); // remove the =
        this._attributes[name] = invocation.positionalArguments[0];
        return;
      }
    }

    return super.noSuchMethod(invocation);
  }

  //--------------------------------------------------------------------------
  // private
  //--------------------------------------------------------------------------
  Response _response;
  Map<String, dynamic> _attributes;
}
