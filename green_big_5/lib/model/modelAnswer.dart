
class ModelAnswer {
  String questions, answer;

  ModelAnswer({required this.questions, required this.answer});

  ModelAnswer.fromJson(Map<String, dynamic> json)
      : questions = json['questions'],
        answer = json['answer'];

  Map<String, dynamic> toJson() {
    return {
      'questions': questions,
      'answer': answer,
    };
  }
}