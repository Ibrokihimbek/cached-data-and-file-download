import 'package:cached_vc_download/data/api_service/api_client.dart';
import 'package:cached_vc_download/data/models/my_response/response_model.dart';
import 'package:cached_vc_download/data/models/users_model/user_model.dart';
import 'package:dio/dio.dart';

class ApiService extends ApiClient {
  Future<MyResponse> getAllUsers() async {
    MyResponse myResponse = MyResponse(error: "");
    try {
      Response response = await dio.get(dio.options.baseUrl);
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        myResponse.data =
            (response.data as List).map((e) => UserModel.fromJson(e)).toList();
      }
    } catch (error) {
      myResponse.error = error.toString();
    }
    return myResponse;
  }
}
