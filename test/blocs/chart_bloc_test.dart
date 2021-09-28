// @dart=2.9
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mms/blocs/chart/message_cubit.dart';
import 'package:mms/blocs/chart/message_states.dart';
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
      chartCubit = ChartCubit(messageRepository: issueRepository);
    });

    blocTest(
      'success case',
      build: () => chartCubit,
      act: (ChartCubit bloc) {
        when(issueRepository.getMessages(any)).thenAnswer((_) => Future.value());
        bloc.getMessages();
      },
      expect: () => [isA<ChartLoadInProgress>(),  isA<ChartLoadSuccess>()],
    );

    blocTest(
      'failure case',
      build: () => chartCubit,
      act: (ChartCubit bloc) {
        when(issueRepository.getMessages(any)).thenThrow(Exception());
        bloc.getMessages();
      },
      expect: () => [isA<ChartLoadInProgress>(),  isA<ChartFailure>()],
    );
  });
}
