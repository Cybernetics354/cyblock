import 'package:cyblock/cyblock.dart';
import 'package:flutter/material.dart';

import 'view/with_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Example app",
      home: HomeMainView(),
    );
  }
}

class HomeMainView extends StatefulWidget {
  @override
  _HomeMainViewState createState() => _HomeMainViewState();
}

class _HomeMainViewState extends State<HomeMainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => WithBuilderMainView()
              ));
            },
          )
        ],
        title: Text("Cyblock example"),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<int>(
              stream: CounterCyblock.instance.stream,
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  CounterCyblock.instance.getState();
                  return Text("Not inserted yet");
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("The button is pressed :"),
                      Text(snapshot.data.toString(), style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                    ],
                  );
                }
              },
            ),
            FlatButton(
              child: Text("Another page"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => SecondPageMainView()
                ));
              },
            )
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "decrement",
            child: Icon(Icons.remove),
            onPressed: () {
              CounterCyblock.instance.insertEvent(DecrementEvent());
            },
          ),
          SizedBox(width: 10.0,),
          FloatingActionButton(
            heroTag: "increment",
            child: Icon(Icons.add),
            onPressed: () {
              CounterCyblock.instance.insertEvent(IncrementEvent());
            },
          )
        ],
      ),
    );
  }
}

class SecondPageMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second page"),
      ),
      body: Center(
        child: StreamBuilder<int>(
          stream: CounterCyblock.instance.stream,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              CounterCyblock.instance.getState();
              return CircularProgressIndicator();
            } else {
              return Text(snapshot.data.toString());
            }
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "decrement",
            child: Icon(Icons.remove),
            onPressed: () {
              CounterCyblock.instance.insertEvent(DecrementEvent());
            },
          ),
          SizedBox(width: 10.0,),
          FloatingActionButton(
            heroTag: "increment",
            child: Icon(Icons.add),
            onPressed: () {
              CounterCyblock.instance.insertEvent(IncrementEvent());
            },
          )
        ],
      ),
    );
  }
}

/// Create cybloc
class CounterCyblock extends Cyblock<int, CounterEvent> {
  static final CounterCyblock _singleton = CounterCyblock._();
  CounterCyblock._() : super(10);

  static CounterCyblock get instance => _singleton;

  @override
  void mapEventToState(CounterEvent event) {
    if(event is IncrementEvent) {
      emit(state+1);
    } else if(event is DecrementEvent) {
      emit(state-1);
    }
  }
}


/// Events
abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}
