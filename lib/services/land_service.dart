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
  viewLandByLandOwner(String userid) async{
    final response = await dio.post("${url}view-landby-landowner",data: {"user":userid});
    return response;
  }
  viewAllLAnd()async{
    final response = await dio.post("${url}viewall-land");
    return response;
  }
  viewLand(String landid)async{
    final response = await dio.post("${url}view-land",data: {"landid":landid});
    return response;
  }
  connectWithLandOwner(String connect)async{
    final response = await dio.post("${url}connect-land",data:connect);
    return response;
  }
  viewConnectionByLandOwner(String landid)async{
    final response = await dio.post("${url}view-landconnectby-landowner",data:{"landid":landid});
    return response;
  }
  updateLandConnection(String connectionid,String status)async{
    final response = await dio.post("${url}update-landstatus",data:{"connectionid":connectionid,"status":status});
    return response;
  }
  viewConnectedLandByCustomer(String userid)async{
    final response = await dio.post("${url}view-landcoonectby-customer",data:{"userid":userid});
    return response;
  }





}