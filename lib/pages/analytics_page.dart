import 'package:admin/components/admin_appbar.dart';
import 'package:admin/components/admin_drawer.dart';
import 'package:admin/components/charts/bar_chart.dart';
import 'package:admin/components/charts/line_chart.dart';
import 'package:admin/services/firebase.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AnalyticsPage extends StatefulWidget {
  final GenerativeModel model;
  const AnalyticsPage({
    super.key,
    required this.model,
  });

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late final FirestoreService stats = FirestoreService();

  void _dialogBox(BuildContext context, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          content,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: adminAppBar(context),
      drawer: adminDrawer(context, widget.model),
      backgroundColor: const Color(0xFFFFD22F),
      body: ListView(
        children: [
          TextButton(
            onPressed: () async {
              final Iterable<Content> content = [
                Content.text('''Who is Jose Rizal''')
              ];
              final GenerateContentResponse response =
                  await widget.model.generateContent(content);
              _dialogBox(context, response.text!);
            },
            child: Text(
              'Analyze Data',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Analytics",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Surveyed Alumni Based on Year Graduated",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OlopscLineChart(),
                const OlopscBarChart(
                  collectionName: 'question_2',
                  questionName: 'Relevance',
                  toolTip:
                      "The skills you've mentioned helped you in pursuing your career path",
                ),
                const OlopscBarChart(
                  collectionName: 'question_3',
                  questionName: 'Continuity',
                  toolTip: "Your first job aligns with your current job",
                ),
                const OlopscBarChart(
                  collectionName: 'question_5',
                  questionName: 'Compatibility',
                  toolTip:
                      "The program you took in OLOPSC matches your current job",
                ),
                const OlopscBarChart(
                  collectionName: 'question_6',
                  questionName: 'Satisfaction',
                  toolTip: "You are satisfied with your current job.",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
