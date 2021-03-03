part of cyblock;

abstract class CyblockStates<T> {}

class CyblockSuccessState<T> extends CyblockStates {
  T? data;
  DateTime? dateTime;
  CyblockSuccessState({
    this.data,
    this.dateTime
  });
}

class CyblockLoadingState extends CyblockStates {}

class CyblockFailureState<T> extends CyblockStates {
  dynamic error;
  T? data;

  CyblockFailureState({
    this.error,
    this.data
  });
}