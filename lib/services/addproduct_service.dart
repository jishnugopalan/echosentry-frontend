import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class AddProductService{
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url="http://10.0.2.2:3000/api/";
  getAllCategory() async{
    final response = await dio.post("${url}getallcategory");
    return response;
  }
  getSubCategory(String categoryid)async{
    final response = await dio.post("${url}getsubcategorybyid", data: {"categoryid":categoryid});
    return response;
  }
  addProduct(String products)async{
    final response = await dio.post("${url}product", data: products);
    return response;
  }
  getShopId(String userid)async{
    final response = await dio.post("${url}getshopbyuserid", data: {"userid":userid});
    return response;
  }
}