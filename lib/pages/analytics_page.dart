import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:admin/components/admin_appbar.dart';
import 'package:admin/components/admin_drawer.dart';
import 'package:admin/components/charts/line_chart.dart';
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
      final preparedData = _prepareDataForGemini(fetchedData);

      final content = [
        Content.text(preparedData.toString()),
        Content.text(_getQuestionDescriptions()),
        Content.text(_getAnalysisInstructions()),
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

  Future<List<QuestionData>> _fetchData() async {
    final firestore = FirebaseFirestore.instance;
    final questionCollections = [
      'question_2',
      'question_3',
      'question_5',
      'question_6'
    ];
    final List<QuestionData> questionData = [];

    for (final questionCollection in questionCollections) {
      try {
        final querySnapshot =
            await firestore.collection(questionCollection).get();
        questionData.addAll(querySnapshot.docs.map(
            (doc) => QuestionData.fromMap(doc.data(), questionCollection)));
      } catch (e) {
        print('Error fetching data for $questionCollection: $e');
      }
    }
    return questionData;
  }

  List<Map<String, dynamic>> _prepareDataForGemini(List<QuestionData> data) {
    return data.map((d) => d.toMap()).toList();
  }

  String _getQuestionDescriptions() {
    return '''
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
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Analytics",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              "Surveyed Alumni Based on Year Graduated",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            OlopscLineChart(),
            SizedBox(height: 20),
            AnalyzeButton(),
            SizedBox(height: 20),
            AnalysisResult(),
          ],
        ),
      ),
    );
  }
}

class AnalyzeButton extends StatelessWidget {
  const AnalyzeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AnalyticsModel>();
    return ElevatedButton(
      onPressed: model.isLoading ? null : model.analyzeData,
      child: model.isLoading
          ? const CircularProgressIndicator()
          : const Text('Analyze Data'),
    );
  }
}

class AnalysisResult extends StatelessWidget {
  const AnalysisResult({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<AnalyticsModel>();
    if (model.error.isNotEmpty) {
      return Text(model.error, style: const TextStyle(color: Colors.red));
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MarkdownBody(data: model.geminiResponse),
      ),
    );
  }
}
