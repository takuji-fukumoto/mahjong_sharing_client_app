import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mahjong_sharing_app/view/helper/methods/loading_screen.dart';
import 'package:mahjong_sharing_app/view_model/create_user_view_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../constants.dart';

class CreateUserPage extends ConsumerWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: 名前が他のメンバーと被っていないかチェックすること（最初にメンバー名のリストを引数でもらう）
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor.mainTheme,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(createUserProvider).resetForm();
          },
        ),
        centerTitle: true,
        title: const Text('ユーザー追加'),
      ),
      body: _pageBody(),
    );
  }

  Widget _pageBody() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          const _IconSettings(),
          const _InputForm(),
          Expanded(child: Container()),
          const _SubmitButton(),
        ],
      ),
    );
  }
}

class _IconSettings extends ConsumerWidget {
  const _IconSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(createUserProvider);
    const defaultIconPath = 'assets/icons/default_icon.png';
    final image = ref.watch(createUserProvider).image;
    final picker = ImagePicker();

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        if (image == null)
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(defaultIconPath),
          )
        else
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            backgroundImage: FileImage(image),
          ),
        TextButton(
          onPressed: () async {
            await getImageFromGallery(picker, provider);
          },
          child: const Center(child: Text('アイコン変更')),
        ),
      ],
    );
  }

  Future getImageFromGallery(
      ImagePicker picker, CreateUserViewModel provider) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.changeIconImage(pickedFile.path);
    }
  }
}

class _InputForm extends ConsumerWidget {
  const _InputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(createUserProvider);
    return ReactiveForm(
      formGroup: provider.form,
      child: Column(
        children: <Widget>[
          ReactiveTextField(
            formControlName: 'name',
            textAlign: TextAlign.center,
            validationMessages: (control) => {
              ValidationMessage.required: '名前を入力してください。',
              ValidationMessage.maxLength: '10文字以内で入力してください。',
            },
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

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(createUserProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: const BorderSide(),
        ),
        child: const Text('作成'),
        onPressed: () async {
          if (provider.form.valid) {
            await _onSubmit(context, provider);
          } else {
            null;
          }
        },
      ),
    );
  }

  Future _onSubmit(BuildContext context, CreateUserViewModel provider) async {
    unawaited(loadingScreen(context));

    var ret = await provider.createUserToRemote();
    final snackBar = SnackBar(
      content: Text(ret ? 'ユーザーを追加しました' : 'ユーザーの追加に失敗しました。もう一度お試しください'),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context).popUntil(ModalRoute.withName(RouteName.manageUsers));
    provider.resetForm();
  }
}
