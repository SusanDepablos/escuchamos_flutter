import 'package:escuchamos_flutter/App/View/User/Settings/ChangePassword.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/View/Auth/Login.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/RecoverAccount.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/AccountVerification.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/ChangePassword.dart';
import 'package:escuchamos_flutter/App/View/Auth/Register.dart';
import 'package:escuchamos_flutter/App/View/Auth/VerifyCodeView.dart';
import 'package:escuchamos_flutter/App/View/Home.dart';
import 'package:escuchamos_flutter/App/View/AboutScreen.dart';
import 'package:escuchamos_flutter/App/View/SearchView.dart';
import 'package:escuchamos_flutter/App/View/BaseNavigator.dart';
import 'package:escuchamos_flutter/App/View/User/Profile/EditProfile.dart';
import 'package:escuchamos_flutter/App/View/User/Profile/Profile.dart';
import 'package:escuchamos_flutter/App/View/Settings.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/DeactivateAccount.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/AccountInformation.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Account/EditAccount.dart';
import 'package:escuchamos_flutter/app/View/User/Account/PhoneUpdate.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Account/EmailUpdate.dart';

class AppRoutes {
  static final routes = {

    'login': (context) => Login(),

    'base': (context) => BaseNavigator(),

    'home': (context) => Home(), 

    'about': (context) => AboutScreen(),

    'search': (context) => SearchView(),

    'recover-account': (context) => RecoverAccount(),

    'settings': (context) => Settings(),

    'deactivate': (context) => DeactivateAccount(),

    'account-information': (context) => AccountInformation(),  

    'phone-update': (context) => PhoneUpdate(),   

    'verify-password': (context) => VerifyPassword(), 

    'edit-account': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final text = args['text'] as String;
      final label = args['label'] as String;
      final textChanged = args['textChanged'] as bool;
      final field = args['field'] as String;
      return EditAccount(text: text, label: label, textChanged: textChanged, field: field);
    },

    'account-Verification': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return RecoverAccountVerification(email: args);
    }, // Pantalla para verificar el código

    'change-Password': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return RecoverAccountChangePassword(email: args);
    }, // Pantalla para cambiar contraseña

    'register': (context) => Register(), // Pantalla para registrar una nueva cuenta

    'verify-code': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return VerifyCodeView(email: args);
    }, // Pantalla para verificar el código al registrarse

    'edit-profile': (context) => EditProfile(), // Pantalla de perfil

    'profile': (context) => Profile(), // Pantalla de perfil

    'user-change-password': (context) => UserChangePassword(), // Pantalla de perfil

  };
}
