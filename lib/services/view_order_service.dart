import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class ViewOrderService{
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url="http://10.0.2.2:3000/api/";
  viewOrderByVendorId() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    final response = await dio.post("${url}vieworderbyvendorid", data: {"userid":userid});
    return response;
  }
  viewCustomerDetails(String customerid)async{
    final response = await dio.post("${url}getcustomerdetails", data: {"customerid":customerid});
    return response;
  }
}