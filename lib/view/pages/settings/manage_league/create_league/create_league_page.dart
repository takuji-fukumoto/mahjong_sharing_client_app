import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_sharing_app/view/helper/methods/loading_screen.dart';
import 'package:mahjong_sharing_app/view_model/create_league_view_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../constants.dart';

class CreateLeaguePage extends ConsumerWidget {
  const CreateLeaguePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: 名前が他のリーグ名と被っていないかチェックすること（最初にリーグ名のリストを引数でもらう）
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor.mainTheme,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(createLeagueProvider).form.reset();
          },
        ),
        centerTitle: true,
        title: const Text('リーグ追加'),
        elevation: 0,
      ),
      body: _pageBody(),
    );
  }

  Widget _pageBody() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          const _InputForm(),
          Expanded(child: Container()),
          const _SubmitButton(),
        ],
      ),
    );
  }
}

class _InputForm extends ConsumerWidget {
  const _InputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(createLeagueProvider);
    return ReactiveForm(
      formGroup: provider.form,
      child: Column(
        children: <Widget>[
          ReactiveTextField(
            formControlName: 'name',
            textAlign: TextAlign.center,
            validationMessages: (control) => {
              ValidationMessage.required: '名前を入力してください。',
              ValidationMessage.maxLength: '20文字以内で入力してください。',
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
          const _InputDateForm(
            formControlName: 'start_at',
            displayName: '開始日',
          ),
          const _InputDateForm(
            formControlName: 'end_at',
            displayName: '終了日',
          ),
          ReactiveTextField(
            formControlName: 'description',
            textAlign: TextAlign.left,
            validationMessages: (control) => {
              ValidationMessage.maxLength: '100文字以内で入力してください。',
            },
            maxLines: 3,
            decoration: const InputDecoration(
              icon: SizedBox(
                width: 90,
                height: 100,
                child: Center(
                  child: Text('説明'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputDateForm extends StatelessWidget {
  final String formControlName;
  final String displayName;
  const _InputDateForm(
      {Key? key, required this.formControlName, required this.displayName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
      child: Row(
        children: [
          Expanded(
            child: ReactiveTextField(
              formControlName: formControlName,
              textAlign: TextAlign.center,
              readOnly: true,
              decoration: InputDecoration(
                icon: SizedBox(
                  width: 90,
                  child: Center(
                    child: Text(displayName),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: ReactiveDatePicker(
              formControlName: formControlName,
              builder: (context, picker, child) {
                return GestureDetector(
                  onTap: picker.showPicker,
                  child: const Icon(
                    Icons.date_range,
                    size: 40,
                  ),
                );
              },
              firstDate: DateTime.utc(2000, 1, 1),
              lastDate: DateTime.utc(2100, 12, 31),
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
    final provider = ref.read(createLeagueProvider);
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

  Future _onSubmit(BuildContext context, CreateLeagueViewModel provider) async {
    unawaited(loadingScreen(context));

    var ret = await provider.createLeagueToRemote();
    final snackBar = SnackBar(
      content: Text(ret ? 'リーグを追加しました' : 'リーグの追加に失敗しました。もう一度お試しください'),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context)
        .popUntil(ModalRoute.withName(RouteName.manageLeagues));
    provider.form.reset();
  }
}
