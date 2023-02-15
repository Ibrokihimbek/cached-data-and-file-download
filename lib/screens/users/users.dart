import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_vc_download/bloc/users_bloc.dart';
import 'package:cached_vc_download/bloc/users_event.dart';
import 'package:cached_vc_download/bloc/users_state.dart';
import 'package:cached_vc_download/data/api_service/api_service.dart';
import 'package:cached_vc_download/data/app_repository/company_repo.dart';
import 'package:cached_vc_download/screens/download/download.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UsersBloc(
        UsersRepository(apiService: ApiService()),
      )..add(GetUsers()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FileDownload(),
                  ),
                );
              },
              icon: const Icon(
                Icons.next_plan_outlined,
              ),
            )
          ],
        ),
        body: BlocConsumer<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoadInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UsersLoadInFailure) {
              return Center(
                child: Text(state.errorText),
              );
            } else if (state is UsersLoadInSuccess) {
              return ListView(
                children: List.generate(
                  state.users.length,
                  (index) {
                    var item = state.users[index];
                    return ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: CachedNetworkImage(
                          imageUrl: item.avatarUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                        ),
                      ),
                      title: Text(item.username),
                      subtitle: Text(item.name),
                    );
                  },
                ),
              );
            } else if (state is UsersFromCache) {
              return ListView(
                children: List.generate(state.users.length, (index) {
                  var item = state.users[index];
                  return ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: CachedNetworkImage(
                        imageUrl: item.avatarUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[400]!,
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    title: Text(item.username),
                    subtitle: Text(item.name),
                  );
                }),
              );
            }
            return const SizedBox();
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
