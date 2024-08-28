import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/View/Auth/Login.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/RecoverAccount.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/AccountVerification.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/ChangePassword.dart';
import 'package:escuchamos_flutter/App/View/Auth/Register.dart';
import 'package:escuchamos_flutter/App/View/Auth/VerifyCodeView.dart';
import 'package:escuchamos_flutter/App/View/Home.dart';
import 'package:escuchamos_flutter/App/View/BaseNavigator.dart';
import 'package:escuchamos_flutter/App/View/User/Profile/EditProfile.dart';
import 'package:escuchamos_flutter/App/View/User/Settings.dart';

class AppRoutes {
  static final routes = {

    'login': (context) => Login(), // Pantalla de inicio de sesión

    'Base': (context) => BaseNavigator(), // Pantalla de plantilla  buttomnavigatorbar

    'home': (context) => Home(), // No pasa argumentos aquí

    'recover-account': (context) => RecoverAccount(), // Pantalla para recuperar la cuenta

    'settings': (context) => Settings(), 


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
