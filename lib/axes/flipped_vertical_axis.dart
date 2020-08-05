import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FlippedVerticalAxis extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  FlippedVerticalAxis(this.seriesList, {this.animate});

  factory FlippedVerticalAxis.withSampleData() {
    return new FlippedVerticalAxis(
      _createSampleData(),
      animate: false,
    );
  }

  factory FlippedVerticalAxis.withRandomData() {
    return new FlippedVerticalAxis(_createRandomData());
  }

  static List<charts.Series<RunnerRank, String>> _createRandomData() {
    final random = new Random();

    const runners = ['Smith', 'Jones', 'Brown', 'Doe'];

    final raceData = [
      new RunnerRank(runners.removeAt(random.nextInt(runners.length)), 1),
      new RunnerRank(runners.removeAt(random.nextInt(runners.length)), 2),
      new RunnerRank(runners.removeAt(random.nextInt(runners.length)), 3),
      new RunnerRank(runners.removeAt(random.nextInt(runners.length)), 4),
    ];

    return [
      new charts.Series<RunnerRank, String>(
        id: 'Race Results',
        domainFn: (RunnerRank row, _) => row.name,
        measureFn: (RunnerRank row, _) => row.place,
        data: raceData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      flipVerticalAxis: true,
    );
  }

  static List<charts.Series<RunnerRank, String>> _createSampleData() {
    final raceData = [
      new RunnerRank('Smith', 1),
      new RunnerRank('Jones', 2),
      new RunnerRank('Brown', 3),
      new RunnerRank('Doe', 4),
    ];

    return [
      new charts.Series<RunnerRank, String>(
          id: 'Race Results',
          domainFn: (RunnerRank row, _) => row.name,
          measureFn: (RunnerRank row, _) => row.place,
          data: raceData),
    ];
  }
}

class RunnerRank {
  final String name;
  final int place;
  RunnerRank(this.name, this.place);
}
