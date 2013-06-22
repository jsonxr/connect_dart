part of connect;

class Mime {
  Mime() {
    _types = <String,String>{};
    _extensions = <String,String>{};
  }

  Map<String, String> get types => _types;
  Map<String, String> get extensions => _extensions;

  Map<String, String> _types;
  Map<String, String> _extensions;

  define(Map map) {
    map.forEach((String type, List<String> exts) {
      exts.forEach((ext) {
        this._types[ext] = type;
      });
      this._extensions[type] = exts[0];
    });
  }

  Future load() {

  }
}