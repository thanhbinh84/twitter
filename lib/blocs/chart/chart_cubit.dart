import 'package:bloc/bloc.dart';
import 'package:mms/blocs/chart/chart_states.dart';
import 'package:mms/data/models/chart_data.dart';
import 'package:mms/data/models/period.dart';
import 'package:mms/data/repositories/chart_repos.dart';

class ChartCubit extends Cubit<ChartState> {
  final BaseChartRepository issueRepository;
  ChartCubit({required this.issueRepository}) : super(ChartInitial());

  getChartData({Period status = Period.OneWeek}) async {
    try {
      emit(ChartLoadInProgress());
      List<ChartData> newIssueList = await issueRepository.getChartData(status);
      emit(ChartLoadSuccess(chartData: newIssueList,period: status));
    } catch (e) {
      emit(ChartFailure(e.toString()));
    }
  }
}
