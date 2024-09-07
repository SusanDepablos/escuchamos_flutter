import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/View/Auth/Login.dart';
import 'package:escuchamos_flutter/App/View/Auth/Register.dart';
import 'package:escuchamos_flutter/App/View/Auth/VerifyCodeView.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/RecoverAccount.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/AccountVerification.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/ChangePassword.dart';
import 'package:escuchamos_flutter/App/View/Home.dart';
import 'package:escuchamos_flutter/App/View/AboutScreen.dart';
import 'package:escuchamos_flutter/App/View/SearchView.dart';
import 'package:escuchamos_flutter/App/View/BaseNavigator.dart';
import 'package:escuchamos_flutter/App/View/User/Profile/EditProfile.dart';
import 'package:escuchamos_flutter/App/View/User/Profile/Profile.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Settings.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/DeactivateAccount.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/AccountInformation.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Account/EditAccount.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Account/PhoneUpdate.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Account/EmailUpdate.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Account/CountryUpdate.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Deactivate/Deactivate.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/ChangePassword.dart';

class AppRoutes {
  static final routes = {
    // Pantallas de autenticación
    'login': (context) => Login(),
    'register': (context) => Register(),
    'verify-code': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return VerifyCodeView(email: args);
    },
    'recover-account': (context) => RecoverAccount(),
    'account-verification': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return RecoverAccountVerification(email: args);
    },
    'change-password': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as String;
      return RecoverAccountChangePassword(email: args);
    },

    // Pantallas principales
    'base': (context) => BaseNavigator(),
    'home': (context) => Home(),
    'about': (context) => AboutScreen(),
    'search': (context) => SearchView(),

    // Pantallas de perfil y configuración de usuario
    'edit-profile': (context) => EditProfile(),
    'profile': (context) => Profile(),
    'user-change-password': (context) => UserChangePassword(),
    'settings': (context) => Settings(),
    'deactivate-account': (context) => DeactivateAccount(),
    'deactivate': (context) => Deactivate(),
    'account-information': (context) => AccountInformation(),
    'edit-account': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final text = args['text'] as String;
      final label = args['label'] as String;
      final textChanged = args['textChanged'] as bool;
      final field = args['field'] as String;
      return EditAccount(text: text, label: label, textChanged: textChanged, field: field);
    },
    'phone-update': (context) => PhoneUpdate(),
    'country-update': (context) => CountryUpdate(),
    'email-update': (context) => EmailUpdate(),

  };
}
