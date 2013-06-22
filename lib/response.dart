part of connect;


typedef Future CloseFunction();
typedef void WriteFunction(Object obj);
typedef Future AddStreamFunction(Stream<List<int>> stream);
typedef void OnDataFunction(List<int> event);

// Transformer that prints the data stream
class _ExampleTransformer extends StreamEventTransformer<List<int>, List<int>> {
  void handleData(List<int> data, EventSink<List<int>> sink) {
    print("data: $data");
    sink.add(data);
  }
}

class Response extends Wrapper<HttpResponse> implements HttpResponse {
  Response(HttpResponse _httpResponse): super(_httpResponse) {

    this.close = () {
      return this.wrapped.close();
    };
    this.write = (Object obj) {
      this.wrapped.write(obj);
    };
    this.addStream = (Stream<List<int>> stream) {
      //print("adding stream...");
      //stream = stream.transform(new _ExampleTransformer());
      return this.wrapped.addStream(stream);
    };
  }

  CloseFunction close;
  WriteFunction write;
  AddStreamFunction addStream;
}

//
// This is just a copy of the HttpRequest object.  I've extended it with the
// ability to add attributes to the request to support filter.
//
//class Response2 implements HttpResponse {
//  Response2(HttpResponse this._httpResponse) {
//    _mirror = reflect(this._httpResponse);
//
//    // Enable filters to intercept these methods
//    this.close = () {
//      return this._httpResponse.close();
//    };
//    this.write = (Object obj) {
//      this._httpResponse.write(obj);
//    };
//    this.addStream = (Stream<List<int>> stream) {
//      print("adding stream...");
//      //stream = stream.transform(new _ExampleTransformer());
//      return this._httpResponse.addStream(stream);
//    };
//  }
//
//  //--------------------------------------------------------------------------
//  // Allow intercepting these methods
//  //--------------------------------------------------------------------------
//
//  CloseFunction close;
//  WriteFunction write;
//  AddStreamFunction addStream;
//
//  //--------------------------------------------------------------------------
//  // delegate
//  //--------------------------------------------------------------------------
//
//  dynamic noSuchMethod(Invocation invocation) {
//    print("delegating response.${invocation.memberName.toString()}");
//    return _mirror.delegate(invocation);
//  }
//
//  //--------------------------------------------------------------------------
//  // private
//  //--------------------------------------------------------------------------
//
//  HttpResponse _httpResponse;
//  InstanceMirror _mirror;
//}
