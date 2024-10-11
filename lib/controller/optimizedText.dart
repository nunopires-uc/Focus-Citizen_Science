import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ui_loginPage{

  late String lblAppTitle;
  late String txtBoxEmail;
  late String txtBoxPassword;
  late String btnLogin;
  late String btnGoogleLogin;
  late String btnSignup;
  late String btnForgotPassword;
  late double version;
  ui_loginPage.empty(){
    getDefaults();
  }
  Future<void> getDefaults() async{
    final prefs = await SharedPreferences.getInstance();
    lblAppTitle = prefs.getString('_lblAppTitle') ?? 'Focus';
    txtBoxEmail = prefs.getString('_txtBoxEmail') ?? 'Email';
    txtBoxPassword = prefs.getString('_txtBoxPassword') ?? 'Password';
    btnLogin = prefs.getString('_btnLogin') ?? 'Login';
    btnGoogleLogin = prefs.getString('_btnGoogleLogin') ?? 'Sign Up with Google';
    btnSignup = prefs.getString('_btnSignup') ?? 'New User? Signup';
    btnForgotPassword = prefs.getString('_btnForgotPassword') ?? 'Forgot your password?';
    version = prefs.getDouble('version') ?? 1.0;
  }

  Future<void> createPage() async{
    FirebaseFirestore.instance.collection('pages').doc('ui_login').set({'_lblAppTitle': lblAppTitle, '_txtBoxEmail':txtBoxEmail, '_txtBoxPassword':txtBoxPassword, '_btnLogin':btnLogin, '_btnGoogleLogin':btnGoogleLogin, '_btnSignup':btnSignup, '_btnForgotPassword':btnForgotPassword, 'version':version});
  }

  static Future<void> updateValues(_lblAppTitle, _txtBoxEmail, _txtBoxPassword, _btnLogin, _btnGoogleLogin, _btnSignup, _btnForgotPassword) async{

  }

  Future<void> getVersion() async {
    final prefs = await SharedPreferences.getInstance();
    DocumentSnapshot versionController = await FirebaseFirestore.instance.collection('pages').doc('ui_login').get();
    print('::::::::::::::->' + versionController['version'].toString());
    if(versionController['version'] > version){
      await prefs.setString('_lblAppTitle', versionController['_lblAppTitle']);
      await prefs.setString('_txtBoxEmail', versionController['_txtBoxEmail']);
      await prefs.setString('_txtBoxPassword', versionController['_txtBoxPassword']);
      await prefs.setString('_btnLogin', versionController['_btnLogin']);
      await prefs.setString('_btnGoogleLogin', versionController['_btnGoogleLogin']);
      await prefs.setString('_btnSignup', versionController['_btnSignup']);
      await prefs.setDouble('version', versionController['version']);
    }
  }
}