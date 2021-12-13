import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

final createUserProvider =
    ChangeNotifierProvider((ref) => CreateUserViewModel());

class CreateUserViewModel extends ChangeNotifier {
  final form = FormGroup({
    'name': FormControl<String>(
      value: 'aaaa',
      validators: [Validators.required, Validators.maxLength(10)],
    ),
    'icon': FormControl<String>(
      value: '',
    ),
  });
  File? image;

  void resetForm() {
    form.control('name').value = '';
    form.control('icon').value = '';
    image = null;

    notifyListeners();
  }

  void changeIconImage(String path) {
    image = File(path);
    notifyListeners();
  }
}
