import 'package:cyblock/cyblock.dart';
import 'package:flutter/material.dart';


class WithBuilderMainView extends StatefulWidget {
  @override
  _WithBuilderMainViewState createState() => _WithBuilderMainViewState();
}

class _WithBuilderMainViewState extends State<WithBuilderMainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              CounterCyblockWithBuilder.instance.addWithError();
            },
          )
        ],
        title: Text("With Builder"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.add),
            heroTag: "increment",
            onPressed: () {
              CounterCyblockWithBuilder.instance.add(1);
            },
          ),
          FloatingActionButton(
            child: Icon(Icons.remove),
            heroTag: "decrement",
            onPressed: () {
              CounterCyblockWithBuilder.instance.remove(1);
            },
          )
        ],
      ),
      body: CyblockBuilder<int>(
        initial: CounterCyblockWithBuilder.instance.getState,
        cyblock: CounterCyblockWithBuilder.instance,
        onSuccess: (context, data) {
          return Center(
            child: Text(data.data.toString()),
          );
        },
        onLoading: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        onFailure: (context, error, callback) {
          return Center(
            child: FlatButton(
              child: Text("Reload"),
              onPressed: callback
            ),
          );
        },
      ),
    );
  }
}

class CounterCyblockWithBuilder extends Cyblock<int, String> {
  static final CounterCyblockWithBuilder _singleton = CounterCyblockWithBuilder._();

  static CounterCyblockWithBuilder get instance => _singleton;

  CounterCyblockWithBuilder._() : super(0);

  add(int count) {
    emit(state+count);
  }

  remove(int count) {
    emit(state-count);
  }

  addWithError() async {
    try {
      await Future.delayed(Duration(seconds: 1));
      throw "Error";
    } catch (e) {
      throwError(e);
    }
  }

  @override
  void mapEventToState(String event) {
    // TODO: implement mapEventToState
  }
}