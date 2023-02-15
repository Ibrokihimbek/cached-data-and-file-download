import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_vc_download/bloc/users_event.dart';
import 'package:cached_vc_download/bloc/users_state.dart';
import 'package:cached_vc_download/data/app_repository/company_repo.dart';
import 'package:cached_vc_download/data/models/my_response/response_model.dart';
import 'package:cached_vc_download/data/models/users_model/user_model.dart';


class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc(this.usersRepository) : super(UsersInitial()) {
    on<GetUsers>(_fetchUsers);
  }

  final UsersRepository usersRepository;

  _fetchUsers(GetUsers event, Emitter<UsersState> emit) async {
    emit(UsersLoadInProgress());

    MyResponse myResponse = await usersRepository.getAllUsers();

    if (myResponse.error.isEmpty) {
      List<UserModel> users = myResponse.data as List<UserModel>;
      emit(UsersLoadInSuccess(users: users));
      await _updateCachedUsers(users);
    } else {
      List<UserModel> users = await usersRepository.getAllCachedUsers();
      if (users.isNotEmpty) {
        emit(UsersFromCache(users: users));
      } else {
        emit(UsersLoadInFailure(errorText: myResponse.error));
      }
    }
  }

  _updateCachedUsers(List<UserModel> users) async {
    for (var user in users) {
      await usersRepository.insertUserToDb(user);
    }
  }
}