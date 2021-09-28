import 'package:equatable/equatable.dart';
import 'package:mms/data/models/period.dart';
import 'package:mms/data/models/chart_data.dart';

abstract class ChartState extends Equatable {
  final List<Object?>? objProps;
  const ChartState([this.objProps]);

  List<Object?> get props => objProps ?? [];
}

class ChartInitial extends ChartState {
  @override
  String toString() => 'ChartInitial';
}

class ChartLoadInProgress extends ChartState {
  @override
  String toString() => 'ChartLoadInProgress';
}

class ChartLoadSuccess extends ChartState {
  final List<ChartData> chartData;
  final Period period;

  ChartLoadSuccess({required this.chartData,  required this.period}) : super([chartData, period]);

  @override
  String toString() => 'ChartLoaded';
}

class ChartFailure extends ChartState {
  final String error;
  ChartFailure(this.error) : super([error]);

  @override
  String toString() => 'ChartFailure $error';
}

