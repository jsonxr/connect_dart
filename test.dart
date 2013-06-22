import 'dart:async';
import 'dart:io';


Future<bool> firstLevel() {
  final File file = new File('/Users/jason/git/dart-connect/example/public/jason.txt');
  return file.exists().then( (found) {
    if (found) {
      return file.fullPath().then( (String fullPath) {
        if (fullPath.startsWith('/Users/jason/git/dart-connect/example/public')) {
          return new Future.value(false);
        } else {
          return new Future.value(true);
        }
      });
    } else {
      return new Future.value(true);
    }
  });
}

void main() {
  
  var f1 = firstLevel();
  f1.then( (b) {
    print("continue = $b");
  });
}