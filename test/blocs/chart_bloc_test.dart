// @dart=2.9
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mms/blocs/chart/chart_cubit.dart';
import 'package:mms/blocs/chart/chart_states.dart';
import 'package:mms/data/repositories/chart_repos.dart';
import 'package:mockito/mockito.dart';

class MockIssueRepository extends Mock implements ChartRepository {}

void main() {
  group('ChartCubit', () {
    ChartCubit chartCubit;
    MockIssueRepository issueRepository;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      issueRepository = MockIssueRepository();
      chartCubit = ChartCubit(issueRepository: issueRepository);
    });

    blocTest(
      'success case',
      build: () => chartCubit,
      act: (ChartCubit bloc) {
        when(issueRepository.getChartData(any)).thenAnswer((_) => Future.value());
        bloc.getChartData();
      },
      expect: () => [isA<ChartLoadInProgress>(),  isA<ChartLoadSuccess>()],
    );

    blocTest(
      'failure case',
      build: () => chartCubit,
      act: (ChartCubit bloc) {
        when(issueRepository.getChartData(any)).thenThrow(Exception());
        bloc.getChartData();
      },
      expect: () => [isA<ChartLoadInProgress>(),  isA<ChartFailure>()],
    );
  });
}
