import 'dart:async';
import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void updateLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));
    updateLoading(false);
  }
}
