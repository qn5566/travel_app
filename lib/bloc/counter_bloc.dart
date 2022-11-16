import 'package:bloc/bloc.dart';

import 'counter_event.dart';
import 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(counter: 0));

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    print(event.toString());
    if (event is IncrementEvent) {
      print("inc");
      yield CounterState(counter: state.counter + 1);
    } else if (state is DecrementEvent) {
      yield CounterState(counter: state.counter - 1);
    }
  }
}
