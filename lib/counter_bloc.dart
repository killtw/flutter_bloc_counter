import 'dart:async';

import 'package:bloc_counter/counter_event.dart';

class CounterBloc {
  int _counter = 0;

  StreamController<int> _counterController = StreamController<int>();
  StreamSink<int> get _counterSink => _counterController.sink;
  Stream<int> get counter => _counterController.stream;

  StreamController<CounterEvent> _eventController =
      StreamController<CounterEvent>();
  Sink<CounterEvent> get counterEventSink => _eventController.sink;
  StreamSubscription _eventSubscription;

  CounterBloc() {
    _eventSubscription = _eventController.stream.listen((event) {
      if (event is IncrementEvent) {
        _counter++;
      } else if (event is DecrementEvent) {
        _counter--;
      }

      _counterSink.add(_counter);
    });
  }

  void onIncrement() {
    counterEventSink.add(IncrementEvent());
  }

  void onDecrement() {
    counterEventSink.add(DecrementEvent());
  }

  void dispose() {
    _eventSubscription.cancel();
    _counterController.close();
    _eventController.close();
  }
}
