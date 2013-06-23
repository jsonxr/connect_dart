part of connect;

class Mime {
  Mime() {
    _types = <String,String>{};
    _extensions = <String,String>{};
    this.define(mimeTypes);
  }



  List<Map> get data => _data;

  List<Map> _data;
  Map<String, String> _types;
  Map<String, String> _extensions;

  String getExtension(String type) {
    return _extensions[type];
  }

  String getType(String extension) {
    return _types[extension];
  }

  /**
   * Mime type define
   */
  define(List<Map> list) {
    _data = list;
    _types = <String,String>{};
    _extensions = <String,String>{};

    _data.forEach((Map entry) {
      String type = entry.keys.first;
      List<String> extensions = entry[type];
      extensions.forEach((ext) {
        this._types[ext] = type;
      });
      this._extensions[type] = extensions[0];
    });
  }

  /**
   * Save Mime to a json file (used to create mime_types.dart)
   */
  Future saveToMimeTypesDotDart(String fileName) {
    Completer completer = new Completer();
    File file = new File(fileName);
    StringBuffer json = new StringBuffer("""part of connect;

var mimeTypes = [
""");
    _data.forEach((Map entry) {
      String type = entry.keys.first;
      List<String> extensions = entry[type];
      json.writeln('  {"${type}":${stringify(extensions)}},');
    });
    json.writeln('];');

    file.writeAsString(json.toString(), mode: FileMode.WRITE, encoding: Encoding.UTF_8).then((_){
      completer.complete();
    }).catchError((e) {
      completer.completeError(e);
    });
    return completer.future;
  }

  /**
   * Load mime.types file from apache
   */
  Future loadApacheMimeTypesFile(String fileName) {
    Completer completer = new Completer();
    File file = new File(fileName);
    file.exists().then((found){
      if (found) {
        file.readAsString(encoding: Encoding.ASCII).then((String text) {
          List<Map> list = new List<Map>();
          final RegExp exp = new RegExp(r'\s+');
          List<String> lines = text.split(new RegExp(r'\n+'));
          lines.where((String line) =>  (!line.startsWith('#') && line.trim() != '')).forEach((line) {
            Map map = new Map();
            List<String> exts = line.split(exp);
            String type = exts[0];
            exts.removeAt(0);
            map[type] = exts;
            list.add(map);
          });
          define(list);
          completer.complete();
        });
      } else {
        completer.completeError("File not found: $fileName");
      }
    });
    return completer.future;
  }
}
