import 'package:flutter_test/flutter_test.dart';
import 'package:mms/data/models/period.dart';
import 'package:mms/data/models/chart_data.dart';
import 'package:mms/data/repositories/chart_repos.dart';
import 'package:mms/data/services/mocks/mock_api.dart';



void main() {
  var api = MockAPI();

  test('Chart repositories get correct data', () async {
    var repo = ChartRepository(api: api);
    List<ChartData> issueList = await repo.getChartData(Period.OneWeek);

    expect(issueList.length, PERIOD_LENGTH);
  });
}