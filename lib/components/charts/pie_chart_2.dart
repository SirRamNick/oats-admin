import 'package:admin/services/firebase.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OlopscPieChart2 extends StatefulWidget {
  const OlopscPieChart2({super.key});

  @override
  State<OlopscPieChart2> createState() => _OlopscPieChart2State();
}

class _OlopscPieChart2State extends State<OlopscPieChart2> {
  final FirestoreService empStats = FirestoreService();
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: StreamBuilder(
          stream: empStats.empStats.snapshots(),
          builder: (context, snapshot) {
            List docs = snapshot.data!.docs;
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 0,
                centerSpaceRadius: 50,
                sections: List.generate(
                  docs.length,
                  (index) {
                    final document = docs[index];
                    final isTouched = index == touchedIndex;
                    final fontSize = isTouched ? 25.0 : 16.0;
                    final radius = isTouched ? 300.0 : 250.0;
                    const shadow = [Shadow(color: Colors.black, blurRadius: 2)];

                    final privatelyEmployed =
                        document['privately_employed'] ?? 0.0;
                    final governmentEmployed =
                        document['government_employee'] ?? 0.0;
                    // final entrepreneur = document['entrepreneur'] ?? 0.0;
                    // final others = document['others'] ?? 0.0;

                    switch (index) {
                      case 0:
                        return PieChartSectionData(
                          color: Colors.blue,
                          value: docs[index]['privately_employed'],
                          title: docs[index]['privately_employed'].toString(),
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: shadow,
                          ),
                        );
                      case 1:
                        return PieChartSectionData(
                          color: Colors.red,
                          value: docs[index]['government_employee'],
                          title: docs[index]['government_employee'].toString(),
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: shadow,
                          ),
                        );
                      case 2:
                        return PieChartSectionData(
                          color: Colors.yellow,
                          value: 5,
                          title: 'Entrepreneur',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: shadow,
                          ),
                        );
                      case 3:
                        return PieChartSectionData(
                          color: Colors.green,
                          value: 5,
                          title: 'Others',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: shadow,
                          ),
                        );
                      default:
                        throw Error();
                    }
                  },
                ),
              ),
            );
          }),
    );
  }
}
