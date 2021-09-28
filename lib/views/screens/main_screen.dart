import 'package:mms/blocs/chart/chart_cubit.dart';
import 'package:mms/blocs/chart/chart_states.dart';
import 'package:mms/views/screens/spline_types.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mms/common/utils.dart';
import 'package:mms/data/models/period.dart';
import 'package:mms/views/widgets/dropdown_widget.dart';
import 'package:mms/views/widgets/theme_button.dart';

class MainScreen extends StatefulWidget {
  MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late ChartCubit _chartCubit;

  @override
  void initState() {
    _chartCubit = BlocProvider.of<ChartCubit>(context);
    _getChart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChartCubit, ChartState>(
        listener: (context, state) {
          if (state is ChartFailure) Utils.errorToast(state.error);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Bitcoin to USD Chart'),
            actions: [ThemeButton()],
          ),
          body: _mainView(),
        ));
  }

  _mainView() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_filterView(), Divider(), Expanded(child: _chartView())]);

  _filterView() => BlocBuilder<ChartCubit, ChartState>(
      buildWhen: (previous, current) {
        return current is ChartLoadSuccess;
      },
      builder: (context, state) => state is ChartLoadSuccess
          ? DropdownWidget(
              onItemSelected: (value) => _getChart(status: value as Period),
              currentItem: state.period,
              itemList: Period.list)
          : Container());

  _chartView() {
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        return state is ChartLoadInProgress
            ? SpinKitWave(color: Theme.of(context).accentColor, size: 25.0)
            : state is ChartLoadSuccess
                ? SplineTypes(state.chartData, state.period)
                : Container();
      },
    );
  }

  _getChart({Period status = Period.OneWeek}) {
    _chartCubit.getChartData(status: status);
  }
}
