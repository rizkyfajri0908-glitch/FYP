class AssistantKnowledge {
  const AssistantKnowledge({
    required this.id,
    required this.question,
    required this.answer,
    required this.keywords,
    required this.category,
  });

  factory AssistantKnowledge.fromJson(Map<String, dynamic> json) {
    return AssistantKnowledge(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      keywords: List<String>.from(json['keywords'] as List<dynamic>),
      category: json['category'] as String? ?? 'general',
    );
  }

  final String id;
  final String question;
  final String answer;
  final List<String> keywords;
  final String category;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'keywords': keywords,
      'category': category,
    };
  }
}
