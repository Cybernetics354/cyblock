part of cyblock;

abstract class Cyblock<T, S> {
  /// Saved state during emit
  T state;

  /// Setup initial state function
  void initialState(T initState) {
    emit(initState);
  }

  /// Controller for main state stream
  final _streamController = new BehaviorSubject<T>();

  /// for inputing state
  /// but you can use emit instead of using [_inStream] manually
  StreamSink<T> get _inStream => _streamController.sink;

  /// If you want to stream on the cybloc you can use [stream]
  ///
  /// [SomeCyblocClass.stream]
  Stream<T> get stream => _streamController.stream;
  final _eventController = new BehaviorSubject<S>();
  StreamSink<S> get _eventListen => _eventController.sink;

  /// Use [emit] to update state
  void emit(T data) {
    state = data;
    _inStream.add(data);
    if(data == null) {
      _inBuilderStream.add(null);
    } else {
      _inBuilderStream.add(CyblockSuccessState<T>(
        data: data,
        dateTime: DateTime.now()
      ));
    }
  }

  void throwError(Exception e) {
    _inBuilderStream.add(CyblockFailureState<T>(
      error: e,
      data: state??null
    ));
  }

  /// Disposing Stream Controller
  void dispose() {
    _streamController?.close();
    _eventController?.close();
    _builderController?.close();
  }

  /// Use [insertEvent] to insert event
  void insertEvent(S event) {
    _eventListen.add(event);
  }

  /// mapping event to state
  void mapEventToState(S event);

  /// Function to get current state
  getState() {
    emit(state);
  }

  /// Controller for [CyblockBuilder]
  final _builderController = new BehaviorSubject<CyblockStates>();
  
  /// Stream pipe for builder
  Stream<CyblockStates> get builderStream => _builderController.stream;
  
  /// Input state for builder
  StreamSink<CyblockStates> get _inBuilderStream => _builderController.sink;

  /// to construct the initial value, use `Cyblock() : super(initialValue);`
  Cyblock(T initState) {
    state = initState; 
    _eventController.stream.listen(mapEventToState);
  }
}

abstract class Cybit<T> {
  /// Saved state during emit
  T state;

  /// Setup initial state function
  void initialState(T initState) {
    emit(initState);
  }

  /// Controller for main state stream
  final _streamController = new BehaviorSubject<T>();

  /// for inputing state
  /// but you can use emit instead of using [_inStream] manually
  StreamSink<T> get _inStream => _streamController.sink;

  /// Use [emit] to update state
  void emit(T data) {
    state = data;
    _inStream.add(data);
  
    _inBuilderStream.add(CyblockSuccessState<T>(
      data: data,
      dateTime: DateTime.now()
    ));
  }

  void throwError(dynamic e) {
    _inBuilderStream.add(CyblockFailureState<T>(
      error: e,
      data: state
    ));
  }

  /// Disposing Stream Controller
  void dispose() {
    _streamController?.close();
    _builderController?.close();
  }

  /// Function to get current state
  getState() {
    _inStream.add(state);
  
    _inBuilderStream.add(CyblockSuccessState<T>(
      data: state,
      dateTime: DateTime.now()
    ));
  }

  /// Controller for [CyblockBuilder]
  final _builderController = new BehaviorSubject<CyblockStates>();
  
  /// Stream pipe for builder
  Stream<CyblockStates> get builderStream => _builderController.stream;
  
  /// Input state for builder
  StreamSink<CyblockStates> get _inBuilderStream => _builderController.sink;

  /// to construct the initial value, use `Cyblock() : super(initialValue);`
  Cybit(T initState) {
    initialState(initState);
  }
}
