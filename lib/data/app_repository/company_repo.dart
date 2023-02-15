import 'package:cached_vc_download/data/api_service/api_service.dart';
import 'package:cached_vc_download/data/local/local_db.dart';
import 'package:cached_vc_download/data/models/my_response/response_model.dart';
import 'package:cached_vc_download/data/models/users_model/user_model.dart';

class UsersRepository {

  UsersRepository({required this.apiService});

  final ApiService apiService;

  Future<MyResponse> getAllUsers() => apiService.getAllUsers();

  Future<UserModel> insertUserToDb(UserModel userModel) =>
      LocalDatabase.insertUser(userModel: userModel);

  Future<List<UserModel>> getAllCachedUsers() => LocalDatabase.getCachedUsers();

  Future<int> deleteCachedUsers() => LocalDatabase.deleteAll();
}