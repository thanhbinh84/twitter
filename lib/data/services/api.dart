
import 'package:mms/data/models/chart_data.dart';
import 'package:mms/data/models/period.dart';

abstract class BaseAPI {
  Future<List<ChartData>> getChartData(Period issueCriteria);
}
