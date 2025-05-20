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

  // Factory constructor to create a QuestionData object from a map
  factory QuestionData.fromMap(
      Map<String, dynamic> map, String collectionName) {
    return QuestionData(
      collectionName: collectionName,
      stronglyAgree: map['strongly_agree'] ?? 0,
      agree: map['agree'] ?? 0,
      neutral: map['neutral'] ?? 0,
      disagree: map['disagree'] ?? 0,
      stronglyDisagree: map['strongly_disagree'] ?? 0,
      degree: map['degree'] ?? '',
    );
  }

  // Method to convert QuestionData object to a map
  Map<String, dynamic> toMap() {
    return {
      'question_number': collectionName,
      'strongly_agree': stronglyAgree,
      'agree': agree,
      'neutral': neutral,
      'disagree': disagree,
      'strongly_disagree': stronglyDisagree,
      'degree': degree,
    };
  }
}
