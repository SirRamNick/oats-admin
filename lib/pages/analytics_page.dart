import 'package:admin/components/admin_appbar.dart';
import 'package:admin/components/admin_drawer.dart';
import 'package:admin/components/charts/bar_chart.dart';
import 'package:admin/components/charts/line_chart.dart';
import 'package:admin/services/data.dart';
import 'package:admin/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  // final TextEditingController _textEditingController = TextEditingController();
  bool sentResponse = false;

  String geminiResponse = 'What do you want me to do?';

  Future<List<dynamic>> fetchData() async {
    final firestore = FirebaseFirestore.instance;
    final questionCollections = [
      'question_2',
      'question_3',
      'question_5',
      'question_6'
    ];

    final questionData = [];

    for (final questionCollection in questionCollections) {
      try {
        final querySnapshot =
            await firestore.collection(questionCollection).get();
        final qData = querySnapshot.docs.map(
          (doc) {
            final data = doc.data();
            return QuestionData(
              collectionName: questionCollection,
              stronglyAgree: data['strongly_agree'],
              agree: data['agree'],
              neutral: data['neutral'],
              disagree: data['disagree'],
              stronglyDisagree: data['strongly_disagree'],
              degree: data['degree'],
            );
          },
        ).toList();

        questionData.addAll(qData);
      } catch (e) {
        print(e.toString());
      }
    }
    return questionData;
  }

  List<Map<String, dynamic>> prepareDataForGemini(List<dynamic> data) {
    final geminiData = data.map((d) {
      return {
        'question_number': d.collectionName,
        'strongly_agree': d.stronglyAgree,
        'agree': d.agree,
        'neutral': d.neutral,
        'disagree': d.disagree,
        'strongly_disagree': d.stronglyDisagree,
        'degree': d.degree,
      };
    }).toList();

    return geminiData;
  }

  // void _dialogBox(
  //     BuildContext context, List<Map<String, dynamic>> data, String response) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       content: Text(response),
  //     ),
  //   );
  // }

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //     TextButton(
              //       onPressed: () async {
              //         final fetchedData = await fetchData();
              //         final preparedData = prepareDataForGemini(fetchedData);

              //         final Iterable<Content> content = [
              //           Content.text(preparedData.toString()),
              //           Content.text(
              //               '''You are about to provide the user straight answers based on the inquiries. Provided with the data in a form of list, make sure
              // to use this data as basis and make sure all answer you give is comprehendable by Administrator who are there to oversee the data.
              // Provide only texts with no special characters.'''),
              //           Content.text('General report about the data'),
              //         ];
              //         final GenerateContentResponse response =
              //             await widget.model.generateContent(content);
              //         setState(() {
              //           geminiResponse = response.text!;
              //         });
              //       },
              //       child: const Text(
              //         'Generate Report',
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Analytics",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Surveyed Alumni Based on Year Graduated",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                OlopscLineChart(),
                // OlopscBarChart(
                //   collectionName: 'question_2',
                //   questionName: 'Relevance',
                //   toolTip:
                //       "The skills you've mentioned helped you in pursuing your career path",
                // ),
                // OlopscBarChart(
                //   collectionName: 'question_3',
                //   questionName: 'Continuity',
                //   toolTip: "Your first job aligns with your current job",
                // ),
                // OlopscBarChart(
                //   collectionName: 'question_5',
                //   questionName: 'Compatibility',
                //   toolTip:
                //       "The program you took in OLOPSC matches your current job",
                // ),
                // OlopscBarChart(
                //   collectionName: 'question_6',
                //   questionName: 'Satisfaction',
                //   toolTip: "You are satisfied with your current job.",
                // ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              final fetchedData = await fetchData();
              final preparedData = prepareDataForGemini(fetchedData);

              final Iterable<Content> content = [
                Content.text(preparedData.toString()),
                Content.text(
                    '''Question 2 - The skills you've mentioned helped you in pursuing your career path. (Relevance
                                Question 3 - Your first job aligns with your current job.(Continuity)
                                Question 5 - The program you took in OLOPSC matches your current job.(Compatibility)
                                Question 6 - You are satisfied with your current job. (Satisfaction)'''),
                Content.text(
                    '''You are about to provide the user straight answers based on the inquiries. Provided with the data in a form of list, make sure
          to use this data as basis and make sure all answer you give is comprehendable by Administrator who are there to oversee the data.
          Provide only texts with no special characters.'''),
                Content.text('Give me analysis report'),
              ];
              final GenerateContentResponse response =
                  await widget.model.generateContent(content);

              setState(() {
                geminiResponse = response.text!;
              });
            },
            child: const Text(
              'Analyze Data',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(child: Text(geminiResponse)),
        ],
      ),
    );
  }
}
