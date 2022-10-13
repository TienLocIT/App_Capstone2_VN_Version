// @dart=2.9
class userModel {
  String sId;
  String phoneNumber;
  String fullName;
  String displayName;
  String keySeceret;
  List<Questions> questions;
  // List<DefindQuestion> defindQuestion;

  userModel(
      {this.sId,
        this.phoneNumber,
        this.fullName,
        this.displayName,
        this.keySeceret,
        this.questions
        // this.defindQuestion
  });

  userModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    phoneNumber = json['phoneNumber'];
    fullName = json['fullName'];
    displayName = json['displayName'];
    keySeceret=json['keySeceret'];
    if (json['Questions'] != null) {
      questions = <Questions>[];
      json['Questions'].forEach((v) {
        questions.add(new Questions.fromJson(v));
      });
    }
    // if (json['defindQuestion'] != null) {
    //   defindQuestion = <DefindQuestion>[];
    //   json['defindQuestion'].forEach((v) {
    //     defindQuestion.add(new DefindQuestion.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['phoneNumber'] = this.phoneNumber;
    data['fullName'] = this.fullName;
    data['displayName'] = this.displayName;
    if (this.questions != null) {
      data['Questions'] = this.questions.map((v) => v.toJson()).toList();
    }
    // if (this.defindQuestion != null) {
    //   data['defindQuestion'] =
    //       this.defindQuestion.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Questions {
  String id;
  List<QuestionsDate> questionsDate;
  String dateTime;
  Questions(
      {this.id,
        this.dateTime,
        this.questionsDate,});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTime=json['dateTime'];
    if (json['questionsDate'] != null) {
      questionsDate = <QuestionsDate>[];
      json['questionsDate'].forEach((v) {
        questionsDate.add(new QuestionsDate.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.questionsDate != null) {
      data['questionsDate'] =
          this.questionsDate.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionsDate {
  String question;
  String answer;

  QuestionsDate({this.question,this.answer});

  QuestionsDate.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer=json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    return data;
  }
}

// class DefindQuestion {
//   String id;
//   String question;
//   String answer;
//
//   DefindQuestion(
//       {this.id,
//         this.question,
//         this.answer});
//
//   DefindQuestion.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     question = json['question'];
//     answer = json['answer'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['question'] = this.question;
//     data['answer'] = this.answer;
//     return data;
//   }
// }
