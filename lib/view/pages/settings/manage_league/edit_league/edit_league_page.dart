import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_sharing_app/model/league_model.dart';
import 'package:mahjong_sharing_app/view/helper/methods/loading_screen.dart';
import 'package:mahjong_sharing_app/view_model/edit_league_view_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../constants.dart';

class EditLeaguePage extends ConsumerWidget {
  final Map<dynamic, dynamic> arguments;
  const EditLeaguePage({Key? key, required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final league = arguments['league'] as LeagueModel;
    final provider = ref.read(editLeagueProvider);
    provider.setForm(league);

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
        title: const Text('リーグ情報編集'),
        actions: [
          _DeleteButton(
            league: league,
          ),
        ],
        elevation: 0,
      ),
      body: _pageBody(league),
    );
  }

  Widget _pageBody(LeagueModel league) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          const _InputForm(),
          Expanded(child: Container()),
          _EditButton(
            league: league,
          ),
        ],
      ),
    );
  }
}

class _InputForm extends ConsumerWidget {
  const _InputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(editLeagueProvider);
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

class _EditButton extends ConsumerWidget {
  final LeagueModel league;
  const _EditButton({Key? key, required this.league}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(editLeagueProvider);
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
        child: const Text('更新'),
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

  Future _onSubmit(BuildContext context, EditLeagueViewModel provider) async {
    unawaited(loadingScreen(context));

    var ret = await provider.updateLeagueToRemote(league);
    final snackBar = SnackBar(
      content: Text(ret ? 'リーグ情報を更新しました' : 'リーグ情報の更新に失敗しました。もう一度お試しください'),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context)
        .popUntil(ModalRoute.withName(RouteName.manageLeagues));
    provider.form.reset();
  }
}

class _DeleteButton extends ConsumerWidget {
  final LeagueModel league;

  const _DeleteButton({Key? key, required this.league}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = ref.read(editLeagueProvider);
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
      ),
      child: const Icon(
        Icons.delete_forever,
        size: 30,
      ),
      onPressed: () async {
        await deleteLeague(context, provider);
      },
    );
  }

  Future deleteLeague(
      BuildContext context, EditLeagueViewModel provider) async {
    // ポップアップ出す
    var confirm = await confirmPopup(context);

    if (confirm == null || !confirm) {
      return;
    }

    unawaited(loadingScreen(context));
    var ret = await provider.deleteLeague(league);
    final snackBar = SnackBar(
      content: Text(ret ? 'リーグを削除しました' : 'リーグの削除に失敗しました。もう一度お試しください'),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context)
        .popUntil(ModalRoute.withName(RouteName.manageLeagues));
    provider.form.reset();
  }

  Future<bool?> confirmPopup(BuildContext context) async {
    return await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('リーグ削除'),
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
