import 'package:flutter/material.dart';

class BusDriverRouteSelectionScreen extends StatefulWidget {
  const BusDriverRouteSelectionScreen({super.key});

  @override
  State<BusDriverRouteSelectionScreen> createState() => _BusDriverRouteSelectionScreenState();
}

class _BusDriverRouteSelectionScreenState extends State<BusDriverRouteSelectionScreen> {
  final List<String> routes = [
    'Route 1',
    'Route 2',
    'Route 3',
    'Route 4',
  ];

  List<String> selectedRoutes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Routes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: routes.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              title: Text(routes[index]),
              value: selectedRoutes.contains(routes[index]),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedRoutes.add(routes[index]);
                  } else {
                    selectedRoutes.remove(routes[index]);
                  }
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedRoutes);
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
