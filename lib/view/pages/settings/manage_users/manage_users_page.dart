import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';
import 'package:mahjong_sharing_app/view/helper/widgets/loading_icon.dart';
import 'package:mahjong_sharing_app/view_model/manage_user_view_model.dart';

import '../../../../constants.dart';

class ManageUsersPage extends StatelessWidget {
  const ManageUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text('ユーザー管理'),
      ),
      body: _pageBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => jumpToCreateUserPage(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _pageBody() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: const <Widget>[
          Expanded(child: _RegisteredUserList()),
        ],
      ),
    );
  }
}

class _RegisteredUserList extends ConsumerWidget {
  const _RegisteredUserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(manageUserProvider);

    return FirestoreListView<UserModel>(
      query: provider.registeredUsersQuery(),
      itemBuilder: (context, snapshot) {
        var user = snapshot.data();

        return Container(
          margin: EdgeInsets.only(bottom: 5.0),
          child: ListTile(
            leading: _AvatarBuilder(user: user),
            title: Text(user.name),
            tileColor: Color.fromRGBO(240, 240, 240, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}

class _AvatarBuilder extends StatelessWidget {
  final UserModel user;
  const _AvatarBuilder({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: FutureBuilder(
        future: user.downloadAvatarPath(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && snapshot.data!.isEmpty) {
            return _imageBuilder(
                const AssetImage('assets/icons/default_icon.png'));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return CachedNetworkImage(
              imageUrl: snapshot.data!,
              imageBuilder: (context, imageProvider) =>
                  _imageBuilder(imageProvider),
              placeholder: (context, url) => _imageBuilder(
                  const AssetImage('assets/icons/default_icon.png')),
              errorWidget: (context, url, error) => Stack(
                alignment: Alignment.center,
                children: [
                  _imageBuilder(
                      const AssetImage('assets/icons/default_icon.png')),
                  const Icon(Icons.error, color: Colors.red),
                ],
              ),
            );
          }
          return const LoadingIcon();
        },
      ),
    );
  }

  Widget _imageBuilder(ImageProvider image) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white,
      backgroundImage: image,
    );
  }
}

void jumpToCreateUserPage(BuildContext context) {
  Navigator.of(context).pushNamed(RouteName.createUser);
}
