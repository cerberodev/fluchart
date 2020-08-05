import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class SliderLine extends StatefulWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SliderLine(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SliderLine.withSampleData() {
    return new SliderLine(
      _createSampleData(),
      animate: false,
    );
  }

  factory SliderLine.withRandomData() {
    return new SliderLine(_createRandomData());
  }

  static List<charts.Series<LinearSales, num>> _createRandomData() {
    final random = new Random();

    final data = [
      new LinearSales(0, random.nextInt(100)),
      new LinearSales(1, random.nextInt(100)),
      new LinearSales(2, random.nextInt(100)),
      new LinearSales(3, random.nextInt(100)),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  State<StatefulWidget> createState() => new _SliderCallbackState();

  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

class _SliderCallbackState extends State<SliderLine> {
  num _sliderDomainValue;
  String _sliderDragState;
  Point<int> _sliderPosition;

  _onSliderChange(Point<int> point, dynamic domain, String roleId,
      charts.SliderListenerDragState dragState) {
    void rebuild(_) {
      setState(() {
        _sliderDomainValue = (domain * 10).round() / 10;
        _sliderDragState = dragState.toString();
        _sliderPosition = point;
      });
    }

    SchedulerBinding.instance.addPostFrameCallback(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      new SizedBox(
          height: 150.0,
          child: new charts.LineChart(
            widget.seriesList,
            animate: widget.animate,
            behaviors: [
              new charts.Slider(
                  initialDomainValue: 1.0, onChangeCallback: _onSliderChange),
            ],
          )),
    ];

    if (_sliderDomainValue != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text('Slider domain value: $_sliderDomainValue')));
    }
    if (_sliderPosition != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text(
              'Slider position: ${_sliderPosition.x}, ${_sliderPosition.y}')));
    }
    if (_sliderDragState != null) {
      children.add(new Padding(
          padding: new EdgeInsets.only(top: 5.0),
          child: new Text('Slider drag state: $_sliderDragState')));
    }

    return new Column(children: children);
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
