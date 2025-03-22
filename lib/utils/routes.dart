import 'package:flutter/material.dart';
import '../common/constants/route_constants.dart';
import '../presentation/journeys/home/home_screen.dart';
import '../presentation/journeys/login/login_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting) => {
        RouteList.initial: (context) => LoginScreen(),
        RouteList.home: (context) => HomeScreen(),
      };
}
