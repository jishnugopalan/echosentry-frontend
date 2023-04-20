import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class LandService{
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url="http://10.0.2.2:3000/api/";
  addLand(String landdetails) async{
    final response = await dio.post("${url}addland",data: landdetails);
    return response;
  }
}