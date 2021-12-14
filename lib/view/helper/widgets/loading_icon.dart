import 'package:flutter/material.dart';

class LoadingIcon extends StatelessWidget {
  const LoadingIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey,
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      ),
    );
  }
}
