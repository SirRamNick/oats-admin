import 'package:flutter/material.dart';

PageRouteBuilder instantTransitionTo(Widget page) => PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );

MaterialPageRoute normalTransitionTo(Widget page) => MaterialPageRoute(
      builder: (context) => page,
    );
