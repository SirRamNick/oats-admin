class QuestionData {
  final String collectionName;
  final int stronglyAgree;
  final int agree;
  final int neutral;
  final int disagree;
  final int stronglyDisagree;
  final String degree;

  QuestionData({
    required this.collectionName,
    required this.stronglyAgree,
    required this.agree,
    required this.neutral,
    required this.disagree,
    required this.stronglyDisagree,
    required this.degree,
  });
}
