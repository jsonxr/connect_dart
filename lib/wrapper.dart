part of connect;

/**
 This is just a copy of the HttpRequest object.  I've extended it with the
 ability to add attributes to the request to support filter.
*/
abstract class Wrapper<T> {
  Wrapper(this._wrapped) {
    _mirror = reflect(this._wrapped);
    _classMirror = _mirror.type;
    _className = MirrorSystem.getName(_classMirror.simpleName);
  }

  T get wrapped => _wrapped;
  InstanceMirror get instanceMirror => _mirror;
  ClassMirror get classMirror => _classMirror;

  dynamic noSuchMethod(Invocation invocation) {
    print("delegating ${_className}.${MirrorSystem.getName(invocation.memberName)}");
    return _mirror.delegate(invocation);
  }

  dynamic _wrapped;
  InstanceMirror _mirror;
  ClassMirror _classMirror;
  String _className;
}
