import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tiinver_project/providers/profile/profile_provider.dart';
import 'package:tiinver_project/providers/signIn/sign_in_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class GlobalProviderAccess {
  static SignInProvider? get signProvider {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return Provider.of<SignInProvider>(context, listen: false);
    }
    return null;
  }

  static ProfileProvider? get profileProvider {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return Provider.of<ProfileProvider>(context, listen: false);
    }
    return null;
  }
}
