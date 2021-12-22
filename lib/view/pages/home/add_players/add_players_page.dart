import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:getwidget/components/checkbox_list_tile/gf_checkbox_list_tile.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';
import 'package:mahjong_sharing_app/view/helper/widgets/loading_icon.dart';
import 'package:mahjong_sharing_app/view_model/collection_results_view_model.dart';
import 'package:mahjong_sharing_app/view_model/user_view_model.dart';

import '../../../../constants.dart';

class AddPlayersPage extends StatelessWidget {
  const AddPlayersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor.mainTheme,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: const Text('参加者設定'),
        elevation: 0,
      ),
      body: _pageBody(),
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
    final provider = ref.read(userProvider);

    return FirestoreListView<UserModel>(
      query: provider.registeredUsersQuery(),
      itemBuilder: (context, snapshot) {
        var user = snapshot.data();

        return _RegisteredUserListItem(user: user);
      },
    );
  }
}

class _RegisteredUserListItem extends ConsumerWidget {
  final UserModel user;
  const _RegisteredUserListItem({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(collectionResultsProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GFCheckboxListTile(
        titleText: user.name,
        avatar: _AvatarBuilder(user: user),
        size: 25,
        activeBgColor: Colors.green,
        type: GFCheckboxType.circle,
        activeIcon: const Icon(
          Icons.check,
          size: 15,
          color: Colors.white,
        ),
        onChanged: (value) {
          provider.changePlayerStatus(user, value);
        },
        value: provider.players
            .where((element) => element.docId == user.docId)
            .isNotEmpty,
        inactiveIcon: null,
      ),
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
