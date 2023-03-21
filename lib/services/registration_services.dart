import 'package:dio/dio.dart';
class RegistrationService{
  final dio = Dio();
  final String url="http://10.0.2.2:3000/api/";
  registerUser(String user) async {

    final response = await dio.post(url+"register", data: user);
    return response;
  }
  loginUser(String user) async{
    final response = await dio.post("http://10.0.2.2:3000/api/login", data: user);
    return response;
  }
}