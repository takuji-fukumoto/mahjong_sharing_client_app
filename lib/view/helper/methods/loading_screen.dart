import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/loading_icon.dart';

Future<void> loadingScreen(BuildContext context) async {
  unawaited(showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 0),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return const Center(
          child: LoadingIcon(),
        );
      }));
}
