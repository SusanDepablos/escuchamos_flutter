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
import 'package:escuchamos_flutter/App/View/User/Settings.dart';
import 'package:escuchamos_flutter/App/View/User/DeactivateAccount.dart';
import 'package:escuchamos_flutter/App/View/User/AccountInformation.dart';
import 'package:escuchamos_flutter/App/View/User/Account/EditAccount.dart';
import 'package:escuchamos_flutter/app/View/User/Account/PhoneUpdate.dart';

class AppRoutes {
  static final routes = {

    'login': (context) => Login(),

    'Base': (context) => BaseNavigator(),

    'home': (context) => Home(), 

    'about': (context) => AboutScreen(),

    'Search': (context) => SearchView(),

    'recover-account': (context) => RecoverAccount(), // Pantalla para recuperar la cuenta

    'settings': (context) => Settings(),

    'deactivate': (context) => DeactivateAccount(),

    'account-information': (context) => AccountInformation(),  

    'phone-update': (context) => PhoneUpdate(),   

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


    'Change-Password': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return RecoverAccountChangePassword(email: args);
    }, // Pantalla para cambiar contraseña


    'register': (context) => Register(), // Pantalla para registrar una nueva cuenta


    'verify-code': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return VerifyCodeView(email: args);
    }, // Pantalla para verificar el código al registrarse


    'profile': (context) => EditProfile(), // Pantalla de perfil

  };
}
