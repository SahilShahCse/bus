import 'package:bus/bus_driver/bus_driver_route_selection_screen.dart';
import 'package:bus/loader_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../firebase.dart';

class BusDriverHomePage extends StatefulWidget {
  const BusDriverHomePage({super.key});

  @override
  State<BusDriverHomePage> createState() => _BusDriverHomePageState();
}

class _BusDriverHomePageState extends State<BusDriverHomePage> {
  List<String> selectedRoutes = [];
  String imageURL = 'assets/no_data.png';
  int currentStopIndex = 0;
  bool _isLoading = true;
  final FirebaseService _firebaseService = FirebaseService();

  // New function to check if route data exists
  Future<void> _checkRouteData() async {

    final data = await _firebaseService.fetchRouteData('driver123'); // Replace with dynamic driver ID
    if (data != null) {
      setState(() {
        selectedRoutes = List<String>.from(data['selectedRoutes'] ?? []);
        currentStopIndex = data['currentStopIndex'] ?? 0;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Function to navigate based on whether route data exists
  void _navigateBasedOnRouteData() {
    if (selectedRoutes.isEmpty) {
      // If no route is selected, prompt user to select a route
      navigateToRouteSelection();
    } else {
      // If route exists, go to next stop
      goToNextStop();
    }
  }

  void navigateToRouteSelection() async {
    final routes = await Navigator.push<List<String>>(
      context,
      MaterialPageRoute(
        builder: (context) => const BusDriverRouteSelectionScreen(),
      ),
    );

    if (routes != null && routes.isNotEmpty) {
      setState(() {
        selectedRoutes = routes;
        currentStopIndex = 0;
      });

      // Save routes to Firebase
      await _firebaseService.saveSelectedRoutes(
        driverId: 'driver123', // Replace with dynamic driver ID
        selectedRoutes: routes,
      );
    }
  }

  void goToNextStop() async {
    setState(() {
      if (currentStopIndex < selectedRoutes.length - 1) {
        currentStopIndex++;
      } else {
        _showJourneyCompletedDialog();
      }
    });

    // Update stop index in Firebase
    await _firebaseService.updateCurrentStopIndex(
      driverId: 'driver123', // Replace with dynamic driver ID
      currentStopIndex: currentStopIndex,
    );
  }

  void _showJourneyCompletedDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text(
            'Thank You!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'You have successfully completed the route. Thank you for driving!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context).pop();

                setState(() {
                  selectedRoutes = [];
                  currentStopIndex = 0;
                });

                // Delete route data from Firebase
                await _firebaseService.deleteRouteData('driver123'); // Replace with dynamic driver ID
              },
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkRouteData(); // Check if data exists when the page loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Driver Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LoaderBase(
          isLoading: _isLoading,
          child: Column(
            children: [
              if (selectedRoutes.isEmpty)
                Expanded(
                  child: _buildNoRouteSelected(),
                )
              else
                Expanded(
                  child: _buildRouteProgress(),
                ),
              _buildFooterButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoRouteSelected() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imageURL,
          height: 200,
        ),
        const SizedBox(height: 20),
        const Text(
          'No route selected',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please select a route to start your journey.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRouteProgress() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: selectedRoutes.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(
                  index == currentStopIndex
                      ? Icons.directions_bus
                      : Icons.location_on,
                  color: index == currentStopIndex ? Colors.green : Colors.grey,
                ),
                title: Text(
                  selectedRoutes[index],
                  style: TextStyle(
                    color: index == currentStopIndex ? Colors.green : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: index < currentStopIndex
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFooterButton() {
    return SafeArea(
      child: ElevatedButton(
        onPressed: _navigateBasedOnRouteData, // Trigger navigation based on data
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Center(
          child: Text(
            selectedRoutes.isEmpty ? 'Select a Route' : 'Go to Next Stop',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
