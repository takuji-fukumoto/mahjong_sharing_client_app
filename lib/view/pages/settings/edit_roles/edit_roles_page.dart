import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:getwidget/components/dropdown/gf_dropdown.dart';
import 'package:mahjong_sharing_app/view/helper/widgets/loading_icon.dart';
import 'package:mahjong_sharing_app/view_model/settings_view_model.dart';

import '../../../../../constants.dart';

class EditRolesPage extends ConsumerWidget {
  const EditRolesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        title: const Text('ルール設定'),
      ),
      body: FutureBuilder(
        future: ref.read(settingsProvider).initializeSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _pageBody();
          } else {
            return const LoadingIcon();
          }
        },
      ),
    );
  }

  Widget _pageBody() {
    return Padding(
      padding: EdgeInsets.all(15),
      child: ListView(
        children: [
          _BonusSettings(),
          _OriginPointSettings(),
          _TopPrizeSettings(),
        ],
      ),
    );
  }
}

class _BonusSettings extends ConsumerWidget {
  _BonusSettings({Key? key}) : super(key: key);

  final _settings = [
    '',
    '5-10',
    '10-20',
    '10-30',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(settingsProvider);
    return Container(
      height: 60,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Container(
          padding: const EdgeInsets.only(left: 10),
          child: const Text('ウマ'),
        ),
        trailing: Container(
          margin: const EdgeInsets.only(right: 10),
          child: DropdownButtonHideUnderline(
            child: GFDropdown(
              borderRadius: BorderRadius.circular(5),
              border: const BorderSide(color: Colors.black12, width: 1),
              dropdownButtonColor: Colors.white,
              value: provider.bonusByRanking,
              onChanged: (newValue) async {
                await provider.setBonusByRanking(newValue as String);
              },
              items: _settings
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _OriginPointSettings extends ConsumerWidget {
  _OriginPointSettings({Key? key}) : super(key: key);

  final _settings = [
    20000,
    21000,
    22000,
    23000,
    24000,
    25000,
    26000,
    27000,
    28000,
    29000,
    30000,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(settingsProvider);
    return Container(
      height: 60,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Container(
          padding: const EdgeInsets.only(left: 10),
          child: const Text('配給原点'),
        ),
        trailing: Container(
          margin: const EdgeInsets.only(right: 10),
          child: DropdownButtonHideUnderline(
            child: GFDropdown(
              borderRadius: BorderRadius.circular(5),
              border: const BorderSide(color: Colors.black12, width: 1),
              dropdownButtonColor: Colors.white,
              value: provider.originPoints,
              onChanged: (newValue) async {
                await provider.setOriginPoints(newValue as int);
              },
              items: _settings
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopPrizeSettings extends ConsumerWidget {
  _TopPrizeSettings({Key? key}) : super(key: key);

  final _settings = [
    25000,
    26000,
    27000,
    28000,
    29000,
    30000,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(settingsProvider);
    return Container(
      height: 60,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Container(
          padding: const EdgeInsets.only(left: 10),
          child: const Text('オカ'),
        ),
        trailing: Container(
          margin: const EdgeInsets.only(right: 10),
          child: DropdownButtonHideUnderline(
            child: GFDropdown(
              borderRadius: BorderRadius.circular(5),
              border: const BorderSide(color: Colors.black12, width: 1),
              dropdownButtonColor: Colors.white,
              value: provider.topPrize,
              onChanged: (newValue) async {
                await provider.setTopPrize(newValue as int);
              },
              items: _settings
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
