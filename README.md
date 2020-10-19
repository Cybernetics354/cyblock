# cyblock

A simple state management using dart stream.

## What is Cyblock?

Cyblock is helper to use dart stream as state management, we can easily update data to listener with stream.
it inject an event to run callback for mapping event to state.

## Usage

We can create a class that extends Cybloc, there's 2 parameter. the first parameter is data type for stream, and the
second parameter is data type for event.

```dart
/// Create cybloc
/// The example is counter, there's int and CounterEvent
class CounterCyblock extends Cyblock<int, CounterEvent> {
  static final CounterCyblock _singleton = CounterCyblock._();
  CounterCyblock._() {
    initialState(0);
  }

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
```

and the CounterEvent is

```dart
/// Events
abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {}

class DecrementEvent extends CounterEvent {}
```

so basically, we just inject a `CounterEvent` to cyblock and run `mapEventToState` callback to handle the logic.
we can use `emit(value)` to update the state, and we can get the current state in `state`

## Implementing on UI

The usage if simply, we can use `StreamBuilder` widget to build stream to widget

```dart
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
```

use `stream` to get stream on cyblock controller.
and we can inject event with `insertEvent(event)`.

```dart
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
```

## Disclaimer

Im still new on dart and flutter, and this is just my experiment for flutter state management.
feel free to fork and contribute :)
