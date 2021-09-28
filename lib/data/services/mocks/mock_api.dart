import 'dart:async';

import 'package:mms/data/models/period.dart';
import 'package:mms/data/models/chart_data.dart';
import 'dart:math';

import 'package:mms/data/services/api.dart';

const double MIN_ASSET_VALUE = 40;
const double MAX_ASSET_VALUE = 50;
const PERIOD_LENGTH = 7;

class MockAPI extends BaseAPI {
  @override
  Future<List<ChartData>> getChartData(Period period) async {
    await Future.delayed(Duration(milliseconds: 500));

    var random = new Random();
    int index = 1;
    double interval = period.days/PERIOD_LENGTH;
    return List.generate(PERIOD_LENGTH, (_) {
      double randomPrice = random.nextDouble() * (MAX_ASSET_VALUE - MIN_ASSET_VALUE) + MIN_ASSET_VALUE;
      Duration duration = Duration(days: (interval*index++).toInt());
      return ChartData(DateTime.now().subtract(duration), randomPrice);
    });
  }
}

