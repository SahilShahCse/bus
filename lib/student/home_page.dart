import 'package:bus/loader_base.dart';
import 'package:flutter/material.dart';
import '../firebase.dart';
import 'route_selection_page.dart'; // Import the new route selection page

class HomePageForStudent extends StatefulWidget {
  const HomePageForStudent({super.key});

  @override
  State<HomePageForStudent> createState() => _HomePageForStudentState();
}

class _HomePageForStudentState extends State<HomePageForStudent> {
  final FirebaseService firebaseService = FirebaseService();
  String? selectedRoute;
  int busesPassingThroughRoute = 0;
  bool isLoading = false; // To track the loading state

  // Fetch drivers for the selected route
  void fetchDriversForRoute(String route) async {
    setState(() {
      isLoading = true; // Start loading when the request is made
    });

    List<Map<String, dynamic>> drivers =
        await firebaseService.getDriversForRoute(route);

    setState(() {
      busesPassingThroughRoute = drivers.length;
      isLoading = false; // Stop loading once the data is fetched
    });

    if (drivers.isNotEmpty) {
      for (var driver in drivers) {
        print('Driver ID: ${driver['driverId']}');
      }
    } else {
      print('No drivers found for this route or all have visited it');
    }
  }

  // Route selection page navigation
  Future<void> _selectRoute() async {
    final String? selectedRoute = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RouteSelectionPage()),
    );

    if (selectedRoute != null) {
      setState(() {
        this.selectedRoute = selectedRoute; // Set the selected route
        busesPassingThroughRoute =
            0; // Reset bus count when a new route is selected
        isLoading = true; // Start loading when route is selected
      });
      fetchDriversForRoute(selectedRoute); // Fetch buses for the selected route
    }
  }

  // Display the number of buses passing through the selected route
  Widget _buildBusesCountDisplay() {
    return LoaderBase(
      isLoading: isLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (selectedRoute == null)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/no_data.png',
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: const Text(
                        'select address to check bus availability...',
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )
              : Text(
                  (busesPassingThroughRoute == 0)
                      ? 'no bus from this location :<'
                      : '$busesPassingThroughRoute more will visit your stop :>',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
          const SizedBox(height: 8),
          if (selectedRoute != null && (busesPassingThroughRoute != 0))
            Text(
              'Get ready for the buses passing through your selected location!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bus Route Selector')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildBusesCountDisplay(), // Display buses passing count or loading indicator
            const Spacer(),
            _buildFooterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterButton() {
    return SafeArea(
      child: ElevatedButton(
        onPressed: _selectRoute,
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
            'Select Route',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
