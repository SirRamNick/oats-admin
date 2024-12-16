import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OlopscLineChart extends StatefulWidget {
  const OlopscLineChart({Key? key}) : super(key: key);

  @override
  _OlopscLineChartState createState() => _OlopscLineChartState();
}

class _OlopscLineChartState extends State<OlopscLineChart> {
  final List<EmploymentData> _employmentData = [
    EmploymentData(2018, 45, 30, 15, 10),
    EmploymentData(2019, 50, 28, 12, 10),
    EmploymentData(2020, 40, 35, 17, 8),
    EmploymentData(2021, 55, 25, 14, 6),
    EmploymentData(2022, 48, 32, 16, 4),
  ];

  EmploymentType? _selectedType;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Subtitle
            Text(
              'Employment Trends',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
            ),
            Text(
              'Annual Employment Status Distribution',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),

            // Chart
            SfCartesianChart(
              primaryXAxis: NumericAxis(
                title: AxisTitle(text: 'Year'),
                labelStyle: const TextStyle(fontSize: 10),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Percentage (%)'),
                labelStyle: const TextStyle(fontSize: 10),
                maximum: 100,
                interval: 20,
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                format: 'point.x : point.y%',
              ),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                overflowMode: LegendItemOverflowMode.wrap,
              ),
              series: _buildChartSeries(),
            ),

            const SizedBox(height: 16),
            _buildDetailedViewToggle(),

            if (_selectedType != null) 
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: _buildDetailedView(),
              ),
          ],
        ),
      ),
    );
  }

  List<LineSeries<EmploymentData, num>> _buildChartSeries() {
    return [
      LineSeries<EmploymentData, num>(
        name: 'Privately Employed',
        dataSource: _employmentData,
        xValueMapper: (data, _) => data.year,
        yValueMapper: (data, _) => data.privatelyEmployed,
        color: Colors.blue,
        width: 3,
        markerSettings: MarkerSettings(
          isVisible: true,
          color: Colors.blue.shade700,
        ),
      ),
      LineSeries<EmploymentData, num>(
        name: 'Government Employed',
        dataSource: _employmentData,
        xValueMapper: (data, _) => data.year,
        yValueMapper: (data, _) => data.governmentEmployed,
        color: Colors.green,
        width: 3,
        markerSettings: MarkerSettings(
          isVisible: true,
          color: Colors.green.shade700,
        ),
      ),
      LineSeries<EmploymentData, num>(
        name: 'Self Employed',
        dataSource: _employmentData,
        xValueMapper: (data, _) => data.year,
        yValueMapper: (data, _) => data.selfEmployed,
        color: Colors.red,
        width: 3,
        markerSettings: MarkerSettings(
          isVisible: true,
          color: Colors.red.shade700,
        ),
      ),
      LineSeries<EmploymentData, num>(
        name: 'Others',
        dataSource: _employmentData,
        xValueMapper: (data, _) => data.year,
        yValueMapper: (data, _) => data.others,
        color: Colors.purple,
        width: 3,
        markerSettings: MarkerSettings(
          isVisible: true,
          color: Colors.purple.shade700,
        ),
      ),
    ];
  }

  Widget _buildDetailedViewToggle() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: EmploymentType.values.map((type) {
          final isSelected = _selectedType == type;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(type.label),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  // Toggle the selected type
                  _selectedType = isSelected ? null : type;
                });
              },
              selectedColor: Colors.deepPurple.shade100,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDetailedView() {
    if (_selectedType == null) return const SizedBox.shrink();

    double averagePercentage = 0;
    switch (_selectedType!) {
      case EmploymentType.privatelyEmployed:
        averagePercentage = _employmentData.map((e) => e.privatelyEmployed).reduce((a, b) => a + b) / _employmentData.length;
        break;
      case EmploymentType.governmentEmployed:
        averagePercentage = _employmentData.map((e) => e.governmentEmployed).reduce((a, b) => a + b) / _employmentData.length;
        break;
      case EmploymentType.selfEmployed:
        averagePercentage = _employmentData.map((e) => e.selfEmployed).reduce((a, b) => a + b) / _employmentData.length;
        break;
      case EmploymentType.others:
        averagePercentage = _employmentData.map((e) => e.others).reduce((a, b) => a + b) / _employmentData.length;
        break;
    }

    final trend = _analyzeTrend(_selectedType!);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_selectedType!.label} Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Average Percentage: ${averagePercentage.toStringAsFixed(2)}%',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Trend: $trend',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _analyzeTrend(EmploymentType type) {
    List<double> percentages;
    switch (type) {
      case EmploymentType.privatelyEmployed:
        percentages = _employmentData.map((e) => e.privatelyEmployed).toList();
        break;
      case EmploymentType.governmentEmployed:
        percentages = _employmentData.map((e) => e.governmentEmployed).toList();
        break;
      case EmploymentType.selfEmployed:
        percentages = _employmentData.map((e) => e.selfEmployed).toList();
        break;
      case EmploymentType.others:
        percentages = _employmentData.map((e) => e.others).toList();
        break;
    }

    if (percentages.first < percentages.last) {
      return 'Increasing 📈';
    } else if (percentages.first > percentages.last) {
      return 'Decreasing 📉';
    } else {
      return 'Stable ➡️';
    }
  }
}

class EmploymentData {
  final int year;
  final double privatelyEmployed;
  final double governmentEmployed;
  final double selfEmployed;
  final double others;

  EmploymentData(
    this.year,
    this.privatelyEmployed,
    this.governmentEmployed,
    this.selfEmployed,
    this.others,
  );
}

enum EmploymentType {
  privatelyEmployed,
  governmentEmployed,
  selfEmployed,
  others;

  String get label {
    switch (this) {
      case privatelyEmployed:
        return 'Privately Employed';
      case governmentEmployed:
        return 'Government Employed';
      case selfEmployed:
        return 'Self Employed';
      case others:
        return 'Others';
    }
  }
}
