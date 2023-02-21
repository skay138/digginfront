import 'package:digginfront/models/userModel.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  userModel? _profile;
  userModel? get profile => _profile;

  setProfileProvider(userModel user) async {
    _profile = user;
    print(_profile);
    notifyListeners();
  }
}
