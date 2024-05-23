import 'package:admin/components/admin_appbar.dart';
import 'package:admin/components/admin_drawer.dart';
import 'package:admin/components/charts/bar_chart.dart';
import 'package:admin/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  late final FirestoreService stats = FirestoreService();

  @override
  Widget build(BuildContext context) {
    // final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: adminAppBar(context),
      drawer: adminDrawer(context),
      backgroundColor: const Color(0xFFFFD22F),
      body: ListView(
        children: [
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
                Center(
                  child: FutureBuilder(
                    future:
                        FirebaseFirestore.instance.collection('alumni').get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return Text(snapshot.data!.docs.length.toString());
                    },
                  ),
                ),
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
