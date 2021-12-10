import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_sharing_app/view_model/create_user_view_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CreateUserPage extends StatelessWidget {
  const CreateUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 名前が他のメンバーと被っていないかチェックすること（最初にメンバー名のリストを引数でもらう）
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
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
          const _IconImage(),
          const _InputForm(),
          Expanded(child: Container()),
          const _SubmitButton(),
        ],
      ),
    );
  }
}

class _IconImage extends ConsumerWidget {
  const _IconImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String icon =
        ref.watch(createUserProvider).form.control('icon').value;
    if (icon.isEmpty) {
      return Center(
        child: Container(
          padding: EdgeInsets.all(30),
          child: TextButton(
            style: TextButton.styleFrom(
              primary: Colors.black,
            ),
            onPressed: () async {
              print('on pressed');
              // 画像取得
              // iconに反映
              // formに値をセット
            },
            child: const Icon(
              Icons.account_circle_outlined,
              size: 100,
            ),
          ),
        ),
      );
    } else {
      return Center(child: Text(icon));
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
          // ReactiveTextField(
          //   formControlName: 'icon',
          //   decoration: const InputDecoration(
          //     icon: SizedBox(
          //       width: 90,
          //       child: Center(
          //         child: Text('アイコン'),
          //       ),
          //     ),
          //   ),
          // ),
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
        onPressed: () {
          if (provider.form.valid) {
            _onSubmit(context, provider);
          } else {
            null;
          }
        },
      ),
    );
  }

  void _onSubmit(BuildContext context, CreateUserViewModel provider) {
    // TODO: ユーザーをfirestoreに追加する
    Navigator.of(context).pop();
    provider.resetForm();
  }
}
