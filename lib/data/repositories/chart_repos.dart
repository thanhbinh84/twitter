import 'package:mms/data/models/period.dart';
import 'package:mms/data/models/chart_data.dart';
import 'package:mms/data/services/api.dart';

abstract class BaseChartRepository {
  Future<List<ChartData>> getChartData(Period issueCriteria);
}

class ChartRepository extends BaseChartRepository {
  final BaseAPI api;
  ChartRepository({required this.api});

  Future<List<ChartData>> getChartData(Period period) {
    return api.getChartData(period);
  }
}
