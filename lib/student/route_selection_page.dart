import 'package:flutter/material.dart';

class RouteSelectionPage extends StatefulWidget {
  const RouteSelectionPage({super.key});

  @override
  _RouteSelectionPageState createState() => _RouteSelectionPageState();
}

class _RouteSelectionPageState extends State<RouteSelectionPage> {
  final List<String> routes = [
    'Route 1',
    'Route 2',
    'Route 3',
    'Route 4',
  ];

  String? selectedRoute;

  // Handle route selection
  void _selectRoute(String route) {
    setState(() {
      selectedRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Route'),
      ),
      floatingActionButton: (selectedRoute != null)
          ? FloatingActionButton(
              onPressed: () {
                // Go back to the previous page with the selected route
                Navigator.pop(context, selectedRoute);
              },
              child: const Icon(Icons.check),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // List of routes
            for (var route in routes)
              RadioListTile<String>(
                title: Text(route),
                value: route,
                groupValue: selectedRoute,
                onChanged: (String? value) {
                  if (value != null) {
                    _selectRoute(value);
                  }
                },
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
