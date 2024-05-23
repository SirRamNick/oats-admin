import 'package:admin/services/firebase.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OlopscPieChart extends StatefulWidget {
  final Stream stream;
  const OlopscPieChart({
    super.key,
    required this.stream,
  });

  @override
  State<OlopscPieChart> createState() => _OlopscPieChartState();
}

class _OlopscPieChartState extends State<OlopscPieChart> {
  int touchedIndex = -1;
  late final FirestoreService stats;

  @override
  void initState() {
    super.initState();
    stats = FirestoreService();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: StreamBuilder(
          stream: widget.stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.data!.docs;

            final List<PieChartSectionData> pieChartData =
                List.generate(data.length, (index) {
              final isTouched = index == touchedIndex;
              final fontSize = isTouched ? 25.0 : 16.0;
              final radius = isTouched ? 500.0 : 450.0;
              final color = isTouched ? Colors.black : Colors.white;
              const shadow = [Shadow(color: Colors.black, blurRadius: 2)];

              return PieChartSectionData(
                color: Colors.primaries[index % Colors.primaries.length],
                value: data[index]['value'],
                title: '${data[index]['year']} (${data[index]['value']})',
                // titlePositionPercentageOffset: 5,
                badgeWidget: Transform.rotate(angle: 100),
                radius: radius,
                titleStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: color,
                  shadows: shadow,
                ),
              );
            });
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
                }),
                borderData: FlBorderData(show: false),
                sectionsSpace: 0,
                centerSpaceRadius: 20,
                sections: pieChartData,
              ),
            );
          }),
    );
  }
}



// return PieChart(
//                     PieChartData(
//                       pieTouchData: PieTouchData(
//                         touchCallback:
//                             (FlTouchEvent event, pieTouchResponse) {
//                           setState(() {
//                             if (!event.isInterestedForInteractions ||
//                                 pieTouchResponse == null ||
//                                 pieTouchResponse.touchedSection == null) {
//                               touchedIndex = -1;
//                               return;
//                             }
//                             touchedIndex = pieTouchResponse
//                                 .touchedSection!.touchedSectionIndex;
//                           });
//                         },
//                       ),
//                       borderData: FlBorderData(
//                         show: false,
//                       ),
//                       sectionsSpace: 0,
//                       centerSpaceRadius: 50,
//                       sections: List.generate(
//                         4,
//                         (index) {
//                           final isTouched = index == touchedIndex;
//                           final fontSize = isTouched ? 25.0 : 16.0;
//                           final radius = isTouched ? 60.0 : 50.0;
//                           const shadow = [
//                             Shadow(color: Colors.black, blurRadius: 2)
//                           ];
                      
//                           switch (index) {
//                             case 0:
//                               return PieChartSectionData(
//                                 color: Colors.blue,
//                                 value: 40,
//                                 title: 'Ira',
//                                 radius: radius,
//                                 titleStyle: TextStyle(
//                                   fontSize: fontSize,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   shadows: shadow,
//                                 ),
//                               );
//                             case 1:
//                               return PieChartSectionData(
//                                 color: Colors.red,
//                                 value: 40,
//                                 title: 'Angie',
//                                 radius: radius,
//                                 titleStyle: TextStyle(
//                                   fontSize: fontSize,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   shadows: shadow,
//                                 ),
//                               );
//                             case 2:
//                               return PieChartSectionData(
//                                 color: Colors.yellow,
//                                 value: 40,
//                                 title: 'Rovic',
//                                 radius: radius,
//                                 titleStyle: TextStyle(
//                                   fontSize: fontSize,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   shadows: shadow,
//                                 ),
//                               );
//                             case 3:
//                               return PieChartSectionData(
//                                 color: Colors.green,
//                                 value: 40,
//                                 title: 'RamPogi',
//                                 radius: radius,
//                                 titleStyle: TextStyle(
//                                   fontSize: fontSize,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   shadows: shadow,
//                                 ),
//                               );
//                             default:
//                               throw Error();
//                           }
//                         },
//                       ),
//                     ),
//                   );