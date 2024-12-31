import 'package:bus/bus_driver/bus_driver_route_selection_screen.dart';
import 'package:bus/bus_driver/home_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BusDriverHomePage(),
    );
  }
}
