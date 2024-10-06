import 'package:escuchamos_flutter/App/View/Post/NewPost.dart';
import 'package:escuchamos_flutter/App/View/Post/NewRepost.dart';
import 'package:escuchamos_flutter/App/View/Post/Show.dart';
import 'package:flutter/material.dart';
import 'package:escuchamos_flutter/App/View/Auth/Login.dart';
import 'package:escuchamos_flutter/App/View/Auth/Register.dart';
import 'package:escuchamos_flutter/App/View/Auth/VerifyCodeView.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/RecoverAccount.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/AccountVerification.dart';
import 'package:escuchamos_flutter/App/View/Auth/AccountRecovery/ChangePassword.dart';
import 'package:escuchamos_flutter/App/View/Home.dart';
import 'package:escuchamos_flutter/App/View/AboutScreen.dart';
import 'package:escuchamos_flutter/App/View/SearchUser.dart';
import 'package:escuchamos_flutter/App/View/BaseNavigator.dart';
import 'package:escuchamos_flutter/App/View/User/Profile/EditProfile.dart';
import 'package:escuchamos_flutter/App/View/User/Profile/Profile.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Settings.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/DeleteAccount.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/AccountInformation.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Account/EditAccount.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Account/PhoneUpdate.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Account/EmailUpdate.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Account/CountryUpdate.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/Delete/Delete.dart';
import 'package:escuchamos_flutter/App/View/User/Settings/ChangePassword.dart';
import 'package:escuchamos_flutter/App/View/User/Index.dart';
import 'package:escuchamos_flutter/App/View/Follow/SearchFollowers.dart';
import 'package:escuchamos_flutter/App/View/Follow/SearchFollowed.dart';
import 'package:escuchamos_flutter/App/View/Follow/NavigatorFollow.dart';
import 'package:escuchamos_flutter/App/View/Reaction/Index.dart';
import 'package:escuchamos_flutter/App/View/Comment/Index.dart';
import 'package:escuchamos_flutter/App/View/Comment/NestedComment.dart';
import 'package:escuchamos_flutter/App/View/Admin/ManageUsersView.dart';

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

    //Pantalla Base

    'base': (context) => BaseNavigator(),

    // Pantallas principales
    'home': (context) => Home(),
    'about': (context) => AboutScreen(),
    'search': (context) => SearchView(),

    // Pantallas de perfil y configuración de usuario
    'edit-profile': (context) => EditProfile(),
    'profile': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final showShares = args['showShares'] as bool; // Extrae el ID
      final userId = args['userId'] as int; // Extrae el ID
      return Profile(showShares: showShares, userId: userId); // Pásalo a la vista
    },

    'user-change-password': (context) => UserChangePassword(),
    'settings': (context) => Settings(),
    'delete-account': (context) => DeleteAccount(),
    'delete': (context) => Delete(),
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

    //Usuario
    'index-user': (context) => IndexUser(),

    // Pantallas de seguidores y seguidos
    'search-followers': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final followedUserId = args['followedUserId'] as int;
      return SearchFollowers(
        followedUserId: followedUserId,
      );
    },

    'search-followed': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final followingUserId = args['followingUserId'] as int;
      return SearchFollowed(
        followingUserId: followingUserId,
      );
    },

    'navigator-follow': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final initialTab = args['initialTab'] as String;
      final userId = args['userId'] as int;
      return NavigatorFollow(
        initialTab: initialTab, userId: userId,
      );
    },

    'navigator-post': (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final initialTab = args['initialTab'] as String;
      final userId = args['userId'] as int;
      return NavigatorFollow(
        initialTab: initialTab, userId: userId,
      );
    },

    // pantalla de comentarios
    'index-comments': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final postId = args['postId'] as int;
      return IndexComment(postId: postId);
    },
  
    'nested-comments': (context) {
        final commentId = ModalRoute.of(context)!.settings.arguments as int;
        return NestedComments(commentId: commentId);
    },

    // pantalla de reacciones
    'index-reactions': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final model = args['model'] as String;
      final objectId = args['objectId'] as int;
      final appBar = args['appBar'] as String;
      return IndexReactions(
          model: model, objectId: objectId, appBar: appBar);
    },

    'show-post': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final id = args['id'] as int;
      return Show(
          id: id);
    },

    'new-post': (context) => NewPost(),

    'new-repost': (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final postId = args['postId'] as int;
      return NewRepost(postId: postId);
    },

    //admin
    'manage-users-view': (context) => ManageUsersView(),
  };
}
