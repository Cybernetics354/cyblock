part of cyblock;

/// T is for state type [int, String or custom data model]
class CyblockBuilder<T> extends StatelessWidget {
  /// Use the cyblock for this parameter
  final Cyblock cyblock;

  /// On Function Sucess, have 2 parameters [BuildContext] and [CyblockSuccessState], return [Widget]
  final OnSuccess<T> onSuccess;

  /// On Function Failure, have 2 parameteres [BuildContext] and [CyblockFailureState], return [Widget]
  final OnFailure<T>? onFailure;

  /// On Loading, return [Widget]
  final OnLoading onLoading;

  /// initial function if there's no state
  final VoidCallback initial;

  CyblockBuilder({
    required this.cyblock,
    required this.onSuccess,
    required this.onLoading,
    required this.initial,
    this.onFailure,
  });

  /// Initial function
  onInitial() {
    cyblock.emit(null);
    initial();
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CyblockStates?>(
      stream: cyblock.builderStream,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          cyblock.getState();
          return onLoading(context);
        }

        if(snapshot.data == null && initial != null) {
          onInitial();
        }

        if(snapshot.data is CyblockSuccessState<T>) {
          return onSuccess(context, snapshot.data as CyblockSuccessState<T>?);
        } else if(snapshot.data is CyblockFailureState<T>) {
          return onFailure!(context, snapshot.data as CyblockFailureState<T>?, onInitial);
        }

        return onLoading(context);
      },
    );
  }
}

/// Typedef for Success
typedef Widget OnSuccess<T>(BuildContext context, CyblockSuccessState<T>? successState);

/// Typedef for Failure
typedef Widget OnFailure<T>(BuildContext context, CyblockFailureState<T>? failureState, VoidCallback reload);

/// Typedef for Loading
typedef Widget OnLoading(BuildContext context);