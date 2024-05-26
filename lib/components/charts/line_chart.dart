import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OlopscLineChart extends StatefulWidget {
  const OlopscLineChart({super.key});

  @override
  State<OlopscLineChart> createState() => _OlopscLineChartState();
}

class _OlopscLineChartState extends State<OlopscLineChart> {
  Stream totalAlumni =
      FirebaseFirestore.instance.collection('alumni').snapshots();

  Future<double> get getTotal async {
    return await totalAlumni.length + 0.0;
  }

  List lineColors = [
    Colors.red[200],
    Colors.blue[200],
    Colors.purple[200],
    Colors.white70
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('employment_status')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final List<FlSpot> privatelyEmployedSpots = [];
          final List<FlSpot> governmentEmployedSpots = [];
          final List<FlSpot> selfEmployedSpots = [];
          final List<FlSpot> othersSpots = [];
          final List<int> year = [];
          for (var d in snapshot.data!.docs) {
            final index = d.get('index') as double;
            final privatelyEmployed = d.get('privately_employed') as double;
            final governmentEmployed = d.get('government_employed') as double;
            final selfEmployed = d.get('self_employed') as double;
            final others = d.get('others') as double;
            privatelyEmployedSpots.add(FlSpot(index, privatelyEmployed));
            governmentEmployedSpots.add(FlSpot(index, governmentEmployed));
            selfEmployedSpots.add(FlSpot(index, selfEmployed));
            othersSpots.add(FlSpot(index, others));
            year.add(d.get('year'));
          }
          return AspectRatio(
            aspectRatio: 4,
            child: LineChart(
              LineChartData(
                backgroundColor: const Color(0xFF0B085F),
                maxY: 100,
                minX: 0,
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpots) => Colors.blueGrey,
                  ),
                ),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() != 0) {
                          final yearTitle = year[value.toInt() - 1];
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text('${yearTitle}'),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        // if (value == meta.max) {
                        //   return Container();
                        // }
                        const style = TextStyle(
                          fontSize: 10,
                        );
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            meta.formattedValue,
                            style: style,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                    ),
                    left: BorderSide(color: Colors.transparent),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: lineColors[0],
                    barWidth: 8,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    spots: privatelyEmployedSpots,
                  ),
                  LineChartBarData(
                    isCurved: true,
                    color: lineColors[1],
                    barWidth: 8,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    spots: governmentEmployedSpots,
                  ),
                  LineChartBarData(
                    isCurved: true,
                    color: lineColors[2],
                    barWidth: 8,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    spots: selfEmployedSpots,
                  ),
                  LineChartBarData(
                    isCurved: true,
                    color: lineColors[3],
                    barWidth: 8,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    spots: othersSpots,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
