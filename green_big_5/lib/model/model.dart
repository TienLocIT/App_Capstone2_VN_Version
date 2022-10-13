class LoginRequestModel{
  String email,password;
  LoginRequestModel({required this.email,required this.password});
  Map<String,dynamic> toJson(){
    Map<String,dynamic> map={
      "email":email,
      "password":password
    };
    return map;
  }
}