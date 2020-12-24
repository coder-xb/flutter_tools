import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileState with ChangeNotifier {
  int _level = 0;
  ProfileModel _model;
  int get level => _level;
  ProfileModel get model => _model;

  void initInfo({
    int level,
    ProfileModel model,
    VoidCallback callback,
  }) {
    _level = level;
    _model = model;
    if (callback != null) callback();
    notifyListeners();
  }

  void setAvatar(String avatar) {
    _model.avatar = avatar;
    notifyListeners();
  }

  void setNickname(String nickname) {
    _model.nickname = nickname;
    notifyListeners();
  }
}
