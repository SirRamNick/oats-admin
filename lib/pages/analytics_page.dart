import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:admin/components/admin_appbar.dart';
import 'package:admin/components/admin_drawer.dart';
import 'package:admin/components/charts/olopsc_line_chart.dart';
import 'package:admin/services/data.dart';
import 'package:provider/provider.dart';

class AnalyticsModel extends ChangeNotifier {
  String _geminiResponse = "What would you like to analyze?";
  bool _isLoading = false;
  String _error = '';

  String get geminiResponse => _geminiResponse;
  bool get isLoading => _isLoading;
  String get error => _error;

  final GenerativeModel _model;

  AnalyticsModel(this._model);

  Future<void> analyzeData() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final fetchedData = await _fetchData();

      final question1Data = await _fetchQuestion1Data();
      final top3Skills = _getTop3Skills(question1Data);

      final preparedData = _prepareDataForGemini(fetchedData);
      final content = [
        Content.text(preparedData.toString()),
        Content.text(_getQuestionDescriptions()),
        Content.text(_getAnalysisInstructions()),
        Content.text(top3Skills.toString()),
        Content.text('Generate an analysis report'),
      ];

      final response = await _model.generateContent(content);
      _geminiResponse = response.text ?? "No response generated.";
    } catch (e) {
      _error = "An error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _getTop3Skills(List<Map<String, dynamic>> data) {
    data.sort((a, b) => b['count'].compareTo(a['count']));
    return data.take(3).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchQuestion1Data() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('question_1').get();

    return querySnapshot.docs.map((doc) {
      return {
        'skill': doc['skill'] ?? '',
        'count': doc['count'] ?? 0,
      };
    }).toList();
  }

  Future<List> _fetchData() async {
    final firestore = FirebaseFirestore.instance;
    final questionCollections = [
      'question_2',
      'question_3',
      'question_5',
      'question_6',
    ];

    final List questionData = [];

    for (final questionCollection in questionCollections) {
      try {
        final querySnapshot =
            await firestore.collection(questionCollection).get();
        questionData.addAll(
          querySnapshot.docs.map(
            (doc) => QuestionData.fromMap(doc.data(), questionCollection),
          ),
        );
      } catch (e) {
        print('Error fetching data for $questionCollection: $e');
      }
    }
    return questionData;
  }

  List _prepareDataForGemini(List data) {
    return data.map((d) => d.toMap()).toList();
  }

  String _getQuestionDescriptions() {
    return '''
      Question 1 - The skills you've highlighted helped you in pursuing your career path.
      Question 2 - The skills you've mentioned helped you in pursuing your career path. (Relevance)
      Question 3 - Your first job aligns with your current job. (Continuity)
      Question 5 - The program you took in OLOPSC matches your current job. (Compatibility)
      Question 6 - You are satisfied with your current job. (Satisfaction)
    ''';
  }

  String _getAnalysisInstructions() {
    return '''
      Provide a comprehensive analysis report based on the given data. 
      Ensure your response is clear and easily understandable for administrators overseeing the data. 
      Present the information in plain text without special characters.
      Provide summary for question 1 and highlight the top 3.
      Make sure to provide just the summary of analysis for each questions.
      Make sure the title is in bold letters as well as the title for each questions.
    ''';
  }
}

class AnalyticsPage extends StatelessWidget {
  final GenerativeModel model;

  const AnalyticsPage({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnalyticsModel(model),
      child: Scaffold(
        appBar: adminAppBar(context),
        drawer: adminDrawer(context, model),
        backgroundColor: const Color(0xFFFFD22F),
        body: const AnalyticsBody(),
      ),
    );
  }
}

class AnalyticsBody extends StatelessWidget {
  const AnalyticsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Analytics Dashboard",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      "Surveyed Alumni Based on Year Graduated",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    OlopscLineChart(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: context.watch<AnalyticsModel>().isLoading
                  ? null
                  : () => context.read<AnalyticsModel>().analyzeData(),
              icon: context.watch<AnalyticsModel>().isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.analytics),
              label: Text(
                context.watch<AnalyticsModel>().isLoading
                    ? 'Analyzing...'
                    : 'Analyze Data',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            Consumer<AnalyticsModel>(
              builder: (context, model, child) {
                if (model.error.isNotEmpty) {
                  return Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        model.error,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                return Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analysis Results',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        MarkdownBody(data: model.geminiResponse),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
