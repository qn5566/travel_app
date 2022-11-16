import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class CounterState extends Equatable {
  final int counter;
  const CounterState({required this.counter});

  @override
  List<Object> get props => [counter];
}