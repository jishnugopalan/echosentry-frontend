import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
class AdminService{
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url="http://10.0.2.2:3000/api/";
  addAdviser(String adviser) async{
    final response = await dio.post("${url}addadvisors",data: adviser);
    return response;
  }
  viewAllAdvisers() async {
    final response = await dio.post("${url}view-all-adviser");
    return response;
  }
  viewAdviserById(String userid) async {
    final response = await dio.post("${url}view-adviserby-userid",data: {"userid":userid});
    return response;
  }
  addQuestion(String ques)async{
    final response = await dio.post("${url}addquestion",data:ques);
    return response;
  }
  viewQuestionsByCustomer(String userid) async {
    final response = await dio.post("${url}view-question-customer",data:{"userid":userid});
    return response;
  }
  viewQuestionsByAdviser(String userid)async{
    final response = await dio.post("${url}view-question-adviser",data:{"userid":userid});
    return response;
  }
  addAnswer(String answer)async{
    final response = await dio.post("${url}sendreply",data:answer);
    return response;
  }
  getQuestionById(String questionid)async{
    final response = await dio.post("${url}getquestionbyid",data:{"questionid":questionid});
    return response;
  }
}