import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static Future<void> navigateTo(Widget screen) {
    return navigatorKey.currentState!.push(MaterialPageRoute(builder: (context)=> screen));
  }

  static void goBack(){
    return navigatorKey.currentState!.pop();
  }
}