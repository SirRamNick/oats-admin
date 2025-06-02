import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:admin/components/admin_appbar.dart';
import 'package:admin/components/admin_drawer.dart';
import 'package:admin/components/charts/line_chart.dart';
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
      final firestore = FirebaseFirestore.instance;
      // Fetch all question collections
      final question1Snapshot = await firestore.collection('question_1').get();
      final question2Snapshot = await firestore.collection('question_2').get();
      final question3Snapshot = await firestore.collection('question_3').get();
      final question5Snapshot = await firestore.collection('question_5').get();
      final question6Snapshot = await firestore.collection('question_6').get();

      // Aggregate Question 1 (skills checklist)
      final Map<String, int> skillTotals = {};
      for (final doc in question1Snapshot.docs) {
        final data = doc.data();
        data.forEach((skill, count) {
          if (count is int) {
            skillTotals[skill] = (skillTotals[skill] ?? 0) + count;
          }
        });
      }
      // Get top 3 skills
      final top3Skills = (skillTotals.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value)))
        .take(3)
        .map((e) => {'skill': e.key, 'count': e.value})
        .toList();

      // Aggregate Likert scale questions (2, 3, 5, 6)
      Map<String, Map<String, int>> aggregateLikert(QuerySnapshot snapshot) {
        final Map<String, Map<String, int>> result = {};
        for (final doc in snapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          result[doc.id] = {};
          data.forEach((likert, count) {
            if (count is int) {
              result[doc.id]![likert] = count;
            }
          });
        }
        return result;
      }
      final q2 = aggregateLikert(question2Snapshot);
      final q3 = aggregateLikert(question3Snapshot);
      final q5 = aggregateLikert(question5Snapshot);
      final q6 = aggregateLikert(question6Snapshot);

      // Prepare summary for AI
      String summary = _prepareSummaryForAI(skillTotals, top3Skills, q2, q3, q5, q6);
      final content = [
        Content.text(summary),
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

  String _prepareSummaryForAI(
    Map<String, int> skillTotals,
    List<Map<String, dynamic>> top3Skills,
    Map<String, Map<String, int>> q2,
    Map<String, Map<String, int>> q3,
    Map<String, Map<String, int>> q5,
    Map<String, Map<String, int>> q6,
  ) {
    StringBuffer sb = StringBuffer();
    sb.writeln('Question 1 (Skills):');
    sb.writeln('Total per skill:');
    skillTotals.forEach((skill, count) {
      sb.writeln('  $skill: $count');
    });
    sb.writeln('Top 3 skills:');
    for (var skill in top3Skills) {
      sb.writeln('  ${skill['skill']}: ${skill['count']}');
    }
    sb.writeln('\n');
    void writeLikert(String title, Map<String, Map<String, int>> data) {
      sb.writeln('$title:');
      data.forEach((program, likertMap) {
        sb.writeln('  $program:');
        likertMap.forEach((likert, count) {
          sb.writeln('    $likert: $count');
        });
      });
      sb.writeln('');
    }
    writeLikert('Question 2', q2);
    writeLikert('Question 3', q3);
    writeLikert('Question 5', q5);
    writeLikert('Question 6', q6);
    return sb.toString();
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
      Provide a comprehensive and detailed analysis report based on the given data. For each question:
      
      1. For Question 1 (Skills):
         - Show the distribution of each skill per program/degree and overall.
         - Highlight and discuss the top 3 skills overall and per program if possible.
         - Identify any notable trends or differences between programs.
         - Suggest possible reasons for these trends.
      
      2. For Questions 2, 3, 5, and 6 (Likert scale):
         - For each program/degree, break down the responses for each Likert option (strongly agree, agree, neutral, disagree, strongly disagree).
         - Provide an overall summary for each question across all programs.
         - Identify which programs have the highest and lowest agreement/satisfaction/etc.
         - Discuss any patterns, outliers, or significant differences between programs.
         - Suggest possible reasons or implications for these patterns.
      
      3. For all questions:
         - Provide actionable recommendations or insights for administrators based on the findings.
         - Use clear, structured sections with bolded titles for each question and subsection.
         - Avoid special characters, but use Markdown for bolding and sectioning.
         - Make the report easy to understand and ready for presentation to school administrators.
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
          ],
        ),
      ),
    );
  }
}
