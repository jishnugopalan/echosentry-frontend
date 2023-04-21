import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class ViewProduct{
  final dio = Dio();
  final storage = const FlutterSecureStorage();
  final String url="http://10.0.2.2:3000/api/";
  getProductBySubcategory(String subcategoryid) async {
    final response = await dio.post("${url}getproductbysubcategory", data: {"subcategoryid":subcategoryid});
    return response;
  }
  getProductByProductid(String productid)async{

    final response = await dio.post("${url}getproductbyid", data: {"productid":productid});
    return response;
  }
  getShopDetails(String shopid)async{
    final response = await dio.post("${url}getshopbyshopid", data: {"shopid":shopid});
    return response;

  }
  createOrder(String order)async{
    final response=await dio.post("${url}createorder", data:order);
    return response;
  }
  viewOrderByCustomerid(String userid)async{
    final response=await dio.post("${url}vieworderbycustomerid", data:{"userid":userid});
    return response;
  }
  viewOrderByOrderid(String orderid)async{
    final response=await dio.post("${url}vieworderbyid", data:{"orderid":orderid});
    return response;
  }
  startPayment(String paymentdetails)async{
    final response=await dio.post("${url}startpayment", data:paymentdetails);
    return response;
  }
  cancelOrder(String orderid)async{
    final response=await dio.post("${url}cancelorder", data:{"orderid":orderid});
    return response;
  }

}