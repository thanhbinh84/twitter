import 'package:syncfusion_flutter_charts/charts.dart';

class Period {
  final days, name, intervalType;

  const Period._internal(this.days, this.name, this.intervalType);

  toString() => name;

  static const OneWeek = const Period._internal(7, '1 Week', DateTimeIntervalType.days);
  static const OneMonth = const Period._internal(30, '1 Month', DateTimeIntervalType.days);
  static const SixMonth = const Period._internal(180, '6 Months', DateTimeIntervalType.months);

  static get list => [OneWeek, OneMonth, SixMonth];
}
