import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OlopscBarChart extends StatefulWidget {
  final String collectionName;

  final String questionName;
  final String toolTip;
  const OlopscBarChart({
    super.key,
    required this.toolTip,
    required this.collectionName,
    required this.questionName,
  });

  @override
  State<StatefulWidget> createState() => OlopscBarChartState();
}

class OlopscBarChartState extends State<OlopscBarChart> {
  late final List field_state;
  late String f_state;
  late final List<Color> barColors1;
  late final List<Color> barColors2;

  @override
  void initState() {
    super.initState();
    field_state = [
      'strongly_agree',
      'agree',
      'neutral',
      'disagree',
      'strongly_disagree'
    ];
    f_state = field_state.first;
    barColors1 = [
      Colors.green,
      Colors.blue,
      Colors.deepPurple,
      Colors.deepOrange,
      Colors.red,
    ];
    barColors2 = [
      Colors.green.shade200,
      Colors.blue.shade200,
      Colors.purple.shade200,
      Colors.orange.shade200,
      Colors.red.shade200,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
        height: MediaQuery.of(context).size.height / 1.5,
        width: MediaQuery.of(context).size.width / 1.5,
        child: Column(
          children: [
            Tooltip(
              message: widget.toolTip,
              child: Text(
                widget.questionName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Card(
              child: SizedBox(
                width: 1000,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          f_state = field_state[0];
                        });
                      },
                      child: Text(
                        'Strongly Agree',
                        style: TextStyle(color: barColors1[0]),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          f_state = field_state[1];
                        });
                      },
                      child: Text(
                        'Agree',
                        style: TextStyle(color: barColors1[1]),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          f_state = field_state[2];
                        });
                      },
                      child: Text(
                        'Neutral',
                        style: TextStyle(color: barColors1[2]),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          f_state = field_state[3];
                        });
                      },
                      child: Text(
                        'Disagree',
                        style: TextStyle(color: barColors1[3]),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          f_state = field_state[4];
                        });
                      },
                      child: Text(
                        'Strongly Disagree',
                        style: TextStyle(color: barColors1[4]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(widget.collectionName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}}');
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<QueryDocumentSnapshot> data = snapshot.data!.docs;
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final barsSpace = 4.0 * constraints.maxWidth / 400;
                        final barsWidth = 8.0 * constraints.maxWidth / 400;
                        return BarChart(
                          BarChartData(
                            maxY: 300,
                            backgroundColor: const Color(0xFF0B085F),
                            alignment: BarChartAlignment.spaceAround,
                            barTouchData: BarTouchData(
                              enabled: false,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (group) => Colors.transparent,
                                tooltipPadding: EdgeInsets.zero,
                                tooltipMargin: 8,
                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                    rod.toY.round().toString(),
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    final course =
                                        data[value.toInt()]['degree'];
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(course),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: const FlGridData(
                              show: false,
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            barGroups: data.map((doc) {
                              return BarChartGroupData(
                                showingTooltipIndicators: [0, 1, 2, 3, 4],
                                x: data.indexOf(doc),
                                barsSpace: barsSpace * 2,
                                barRods: [
                                  BarChartRodData(
                                    toY: doc.get(f_state),
                                    color: Colors.transparent,
                                    width: barsWidth * 2,
                                    borderRadius: BorderRadius.circular(6),
                                    gradient: LinearGradient(
                                      colors: [
                                        barColors1[
                                            field_state.indexOf(f_state)],
                                        barColors2[
                                            field_state.indexOf(f_state)],
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  }),
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
