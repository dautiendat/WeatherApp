import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyChart extends StatefulWidget {
  const MyChart({super.key});

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      _mainChartData()
    );
  }
  BarChartGroupData _makeGroupData(int x, double y){
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
            transform: GradientRotation(pi/40)
          ),
          width: 10,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 5,
            color: Colors.grey[300]
          )
        )
      ]
    );
  }
  int showingGroupsLength = 8;
  List<BarChartGroupData> _showingGroups() 
    => List.generate(showingGroupsLength, (i){
    switch (i){
      case 0:
        return _makeGroupData(0, 2);
      case 1:
        return _makeGroupData(1, 3);
      case 2:
        return _makeGroupData(2, 2);
      case 3:
        return _makeGroupData(3, 4.5);
      case 4:
        return _makeGroupData(4, 3.8);
      case 5:
        return _makeGroupData(5, 1.5);
      case 6:
        return _makeGroupData(6, 4);
      case 7:
        return _makeGroupData(7, 3.8);
      default:
        return throw Error();
    }
  });
  _mainChartData(){
    return BarChartData(
      titlesData: FlTitlesData(
        show:true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false)
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false)
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: _getLeftTitlesWiget,
            //interval: 1, => hiển thị nhãn cho các giá trị cách nhau 1 đơn vị
          )
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 38,
            getTitlesWidget: _getBottomTitlesWiget,
          )
        ),
      ),
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: false),
      barGroups: _showingGroups()
    );
  }
  Widget _getBottomTitlesWiget(double value, TitleMeta meta){
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14
    );
    //Widget text;
    const labels = ['01', '02', '03', '04', '05', '06', '07', '08'];

  // Lấy nhãn theo giá trị value
  
  final text = value.toInt() >= 0 && value.toInt() < labels.length
      ? Text(labels[value.toInt()], style: style)
      : Text('', style: style);
    
    return SideTitleWidget(
      //khoảng cách của nhãn với cột
      space: 5, 
      //vị trí hiển thị của nhãn
      axisSide: meta.axisSide,
      child: text,
    );
  }
  Widget _getLeftTitlesWiget(double value, TitleMeta meta){
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14
    );
    Widget text;
    if(value == 0){
      text = Text('\$ 1K',style: style,);
    } else if (value == 1){
      text = Text('\$ 2K',style: style,);
    }else if (value == 2){
      text = Text('\$ 3K',style: style,);
    }else if (value == 3){
      text = Text('\$ 4K',style: style,);
    }else if (value == 4){
      text = Text('\$ 5K',style: style,);
    }else {
      return Container();
    }
    return SideTitleWidget(
      space: 0,
      axisSide: meta.axisSide,
      child: text, 
    );
  }
}