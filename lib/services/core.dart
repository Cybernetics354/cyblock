part of cyblock;

abstract class Cyblock<T, S> {
  /// Saved state during emit
  T state;

  void initialState(T initState) {
    state = initState;
    _inStream.add(initState);
  }

  final _streamController = new StreamController<T>.broadcast();
  StreamSink<T> get _inStream => _streamController.sink;

  /// If you want to stream on the cybloc you can use [stream]
  ///
  /// [SomeCyblocClass.stream]
  Stream<T> get stream => _streamController.stream;

  final _eventController = new StreamController<S>.broadcast();
  StreamSink<S> get _eventListen => _eventController.sink;

  /// Use [emit] to update state
  void emit(T data) {
    state = data;
    _inStream.add(data);
  }

  /// Disposing Stream Controller
  void dispose() {
    _streamController?.close();
    _eventController?.close();
  }

  /// Use [insertEvent] to insert event
  void insertEvent(S event) {
    _eventListen.add(event);
  }

  /// mapping event to state
  void mapEventToState(S event);

  getState() {
    _inStream.add(state);
  }

  Cyblock() {
    _eventController.stream.listen(mapEventToState);
  }
}
