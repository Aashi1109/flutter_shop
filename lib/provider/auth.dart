import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  static final signupUrl = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAmsJpk76u0E7swKsz3WTxux9adWENtSWQ');

  static final loginUrl = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAmsJpk76u0E7swKsz3WTxux9adWENtSWQ');

  String _token = '';
  String _userId = '';
  DateTime? _expiryTime;
  Timer? _logoutTimer;

  // Auth({this._token, this._userId, this._expiryTime});

  bool get isAuth {
    return _token.isNotEmpty;
  }

  String? get token {
    if ((_expiryTime != null && _expiryTime!.isAfter(DateTime.now())) &&
        _token.isNotEmpty &&
        _userId.isNotEmpty) {
      // print('in token if block');
      return _token;
    }
    // print(_token);
    return null;
    // return null;
  }

  String get curUserId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String authType) async {
    Uri url;
    switch (authType) {
      case 'login':
        url = loginUrl;
        break;
      case 'signup':
        url = signupUrl;
        // return;
        break;
      default:
        url = loginUrl;
    }

    try {
      final resp = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final respJsonBody = jsonDecode(resp.body);

      if (resp.statusCode >= 400) {
        throw HttpException(respJsonBody['error']['message']);
      }

      // print(respJsonBody);
      _token = respJsonBody['idToken'];
      _userId = respJsonBody['localId'];
      _expiryTime = DateTime.now().add(
        Duration(
          seconds: int.parse(
            respJsonBody['expiresIn'],
          ),
        ),
      );
      // print(DateTime.now());
      // print(_expiryTime);
      // print(_userId);
      autoLogout();

      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userAuthData = jsonEncode({
        'userId': _userId,
        'token': _token,
        'expiryTime': _expiryTime!.toIso8601String(),
      });
      await prefs.setString('userAuthData', userAuthData);
    } catch (err) {
      rethrow;
    }

    // print(jsonDecode(resp.body));
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signup');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'login');
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    // print(prefs.getKeys());
    if (!prefs.containsKey('userAuthData')) return false;
    // final containsKey = await prefs.containsKey('userAuthData');
    // if (containsKey) return;
    final storedAuthData =
        jsonDecode(prefs.getString('userAuthData')!) as Map<String, dynamic>;
    final storedDate = DateTime.parse(storedAuthData['expiryTime']);
    // print('user stored data $storedDate');

    if (storedDate.isBefore(DateTime.now())) return false;
    // print('after date check');

    _token = storedAuthData['token'];
    // print(_token);
    _userId = storedAuthData['userId'];
    // print(_userId);
    _expiryTime = storedDate;
    // print(_expiryTime);
    // print('after setting values');
    notifyListeners();

    // print('after notify');
    autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryTime = null;
    _logoutTimer = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
      _logoutTimer = null;
    }
    if (_expiryTime != null) {
      final timeDiff = _expiryTime!.difference(DateTime.now()).inSeconds;
      // print(timeDiff);
      _logoutTimer = Timer(Duration(seconds: timeDiff), logout);
    }
  }
}
