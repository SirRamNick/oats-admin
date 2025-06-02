import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OlopscLineChart extends StatefulWidget {
  const OlopscLineChart({Key? key}) : super(key: key);

  @override
  _OlopscLineChartState createState() => _OlopscLineChartState();
}

class _OlopscLineChartState extends State<OlopscLineChart> {
  List<AlumniYearData> _alumniData = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAlumniData();
  }

  Future<void> _fetchAlumniData() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('alumni_by_year').get();
      final data = snapshot.docs.map((doc) {
        final map = doc.data();
        return AlumniYearData(
          year: map['year'] is int ? map['year'] : int.tryParse(map['year'].toString()) ?? 0,
          value: map['value'] is int ? map['value'] : int.tryParse(map['value'].toString()) ?? 0,
        );
      }).toList();
      data.sort((a, b) => a.year.compareTo(b.year));
      setState(() {
        _alumniData = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load alumni data: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text(_error!, style: const TextStyle(color: Colors.red)));
    }
    // Determine year range
    final int startYear = 2002;
    final int endYear = DateTime.now().year - 1;
    // Fill missing years with value 0
    final Map<int, int> yearToValue = { for (var d in _alumniData) d.year : d.value };
    final List<AlumniYearData> displayData = [
      for (int y = startYear; y <= endYear; y++)
        AlumniYearData(year: y, value: yearToValue[y] ?? 0)
    ];
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alumni Per Year',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
            ),
            Text(
              'Number of Alumni Surveyed Each Year',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            SfCartesianChart(
              primaryXAxis: NumericAxis(
                title: AxisTitle(text: 'Year'),
                labelStyle: const TextStyle(fontSize: 12),
                interval: 2,
                majorGridLines: const MajorGridLines(width: 0.5),
                edgeLabelPlacement: EdgeLabelPlacement.shift,
                minimum: startYear.toDouble(),
                maximum: endYear.toDouble(),
                axisLabelFormatter: (AxisLabelRenderDetails details) {
                  // Show every 2nd year for readability
                  int year = details.value.toInt();
                  return ChartAxisLabel(year % 2 == 0 ? year.toString() : '', details.textStyle);
                },
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Number of Alumni'),
                labelStyle: const TextStyle(fontSize: 12),
                interval: 5,
                majorGridLines: const MajorGridLines(width: 0.5),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                format: 'point.x : point.y',
              ),
              series: [
                LineSeries<AlumniYearData, int>(
                  name: 'Alumni',
                  dataSource: displayData,
                  xValueMapper: (data, _) => data.year,
                  yValueMapper: (data, _) => data.value,
                  color: Colors.blue,
                  width: 3,
                  markerSettings: MarkerSettings(
                    isVisible: true,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AlumniYearData {
  final int year;
  final int value;
  AlumniYearData({required this.year, required this.value});
}
