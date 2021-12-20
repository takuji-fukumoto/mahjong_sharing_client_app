import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';
import 'package:mahjong_sharing_app/view/helper/methods/loading_screen.dart';
import 'package:mahjong_sharing_app/view/helper/widgets/loading_icon.dart';
import 'package:mahjong_sharing_app/view_model/edit_user_view_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../constants.dart';

class EditUserPage extends ConsumerWidget {
  final Map<dynamic, dynamic> arguments;
  const EditUserPage({Key? key, required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = arguments['user'] as UserModel;
    final provider = ref.read(editUserProvider);
    provider.setForm(user);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor.mainTheme,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            provider.form.reset();
          },
        ),
        centerTitle: true,
        title: const Text('ユーザー情報編集'),
        actions: [
          _DeleteButton(
            user: user,
          ),
        ],
        elevation: 0,
      ),
      body: _pageBody(user),
    );
  }

  Widget _pageBody(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          _AvatarBuilder(user: user),
          const SizedBox(height: 50),
          const _InputForm(),
        ],
      ),
    );
  }
}

class _AvatarBuilder extends StatelessWidget {
  final UserModel user;
  final defaultIconPath = 'assets/icons/default_icon.png';

  const _AvatarBuilder({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user.avatarPath.isEmpty) {
      return CircleAvatar(
        radius: 40,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(defaultIconPath),
      );
    } else {
      return FutureBuilder(
        future: user.downloadAvatarPath(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
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
      );
    }
  }

  Widget _imageBuilder(ImageProvider image) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white,
      backgroundImage: image,
    );
  }
}

class _InputForm extends ConsumerWidget {
  const _InputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(editUserProvider);
    return ReactiveForm(
      formGroup: provider.form,
      child: Column(
        children: <Widget>[
          ReactiveTextField(
            formControlName: 'name',
            textAlign: TextAlign.center,
            readOnly: true,
            decoration: const InputDecoration(
              icon: SizedBox(
                width: 90,
                child: Center(
                  child: Text('名前'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeleteButton extends ConsumerWidget {
  final UserModel user;

  const _DeleteButton({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.read(editUserProvider);
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
      ),
      child: const Icon(
        Icons.delete_forever,
        size: 30,
      ),
      onPressed: () async {
        await deleteUser(context, provider);
      },
    );
  }

  Future deleteUser(BuildContext context, EditUserViewModel provider) async {
    // ポップアップ出す
    var confirm = await confirmPopup(context);

    if (confirm == null || !confirm) {
      return;
    }

    unawaited(loadingScreen(context));
    var ret = await provider.deleteUser(user);
    final snackBar = SnackBar(
      content: Text(ret ? 'ユーザーを削除しました' : 'ユーザーの削除に失敗しました。もう一度お試しください'),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context).popUntil(ModalRoute.withName(RouteName.manageUsers));
    provider.form.reset();
  }

  Future<bool?> confirmPopup(BuildContext context) async {
    return await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('ユーザー削除'),
          content: const Text("本当に削除しますか？"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }
}
