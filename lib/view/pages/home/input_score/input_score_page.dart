import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mahjong_sharing_app/model/user_model.dart';
import 'package:mahjong_sharing_app/view/helper/widgets/loading_icon.dart';
import 'package:mahjong_sharing_app/view_model/collection_results_view_model.dart';
import 'package:mahjong_sharing_app/view_model/input_score_view_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../../constants.dart';

class InputScorePage extends ConsumerWidget {
  final Map<dynamic, dynamic> arguments;
  const InputScorePage({Key? key, required this.arguments}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = arguments['players'] as List<UserModel>;
    final targetIndex = arguments['target_index'] as int?;

    // ターゲットユーザーが参加者に選択されているか確認
    var provider = ref.read(inputScoreProvider);
    provider.checkTargetPlayer(players);

    if (targetIndex != null) {
      provider.targetIndex = targetIndex;
      var targetResult =
          ref.read(collectionResultsProvider).results[targetIndex];
      provider.setInputPlayerAndScore(targetResult.playerScores);
    } else {
      provider.targetIndex = -1;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColor.mainTheme,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            ref.read(inputScoreProvider).form.reset();
          },
        ),
        centerTitle: true,
        title: Text(targetIndex != null ? '対局編集' : '対局集計'),
        elevation: 0,
      ),
      body: _pageBody(),
    );
  }

  Widget _pageBody() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        child: Column(
          children: const <Widget>[
            _SelectPlayerListView(),
            _InputForm(),
            _SubmitButton(),
          ],
        ),
      ),
    );
  }
}

class _SelectPlayerListView extends ConsumerWidget {
  const _SelectPlayerListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(collectionResultsProvider);

    return Container(
      height: 60,
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black26,
            width: 0.5,
          ),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (var player in provider.players) _PlayerListItem(user: player),
        ],
      ),
    );
  }
}

class _PlayerListItem extends ConsumerWidget {
  final UserModel user;
  const _PlayerListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(inputScoreProvider);
    return InkWell(
      onTap: () {
        provider.choicePlayer(user);
      },
      child: SizedBox(
        height: 60,
        width: 60,
        child: Stack(
          children: [
            Center(child: _playerIcon(user, provider)),
            if (provider.isSelectedUser(user))
              const Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.lightBlue,
                  size: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _playerIcon(UserModel user, InputScoreViewModel provider) {
    return Column(
      children: [
        _AvatarBuilder(user: user),
        Text(
          user.name,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
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

class _InputForm extends ConsumerWidget {
  const _InputForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(inputScoreProvider);
    return ReactiveForm(
      formGroup: provider.form,
      child: Column(
        children: <Widget>[
          for (int i = 1; i <= 4; i++)
            _scoreInputField('player${i}_score', provider.targetPlayerName(i)),
        ],
      ),
    );
  }

  Widget _scoreInputField(String controlName, String displayName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: ReactiveTextField(
        formControlName: controlName,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          icon: SizedBox(
            width: 100,
            child: Center(
              child: Text(displayName),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends ConsumerWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputProvider = ref.read(inputScoreProvider);
    final collectionProvider = ref.read(collectionResultsProvider);

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
        child: const Text('集計'),
        onPressed: () async {
          if (inputProvider.form.valid) {
            await _onSubmit(context, inputProvider, collectionProvider);
          } else {
            var snackBar = const SnackBar(
              content: Text('入力に誤りがあります'),
              duration: Duration(seconds: 3),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            null;
          }
        },
      ),
    );
  }

  Future _onSubmit(BuildContext context, InputScoreViewModel inputProvider,
      CollectionResultsViewModel collectionProvider) async {
    if (!inputProvider.validateInput()) {
      var snackBar = const SnackBar(
        content: Text('入力に誤りがあります'),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    var roundResult = inputProvider.collectInput();
    collectionProvider.addRoundResults(roundResult,
        targetIndex: inputProvider.targetIndex);

    Navigator.of(context).popUntil(ModalRoute.withName(RouteName.home));
    inputProvider.form.reset();
  }
}
