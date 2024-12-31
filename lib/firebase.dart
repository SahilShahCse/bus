import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save the selected routes to Firestore
  Future<void> saveSelectedRoutes({
    required String driverId,
    required List<String> selectedRoutes,
  }) async {
    try {
      await _firestore.collection('routes').doc(driverId).set({
        'driverId': driverId,
        'selectedRoutes': selectedRoutes,
        'currentStopIndex': 0,
      });
    } catch (e) {
      print('Error saving selected routes: $e');
      rethrow;
    }
  }

  /// Fetch the route data from Firestore
  Future<Map<String, dynamic>?> fetchRouteData(String driverId) async {
    try {
      final docSnapshot = await _firestore.collection('routes').doc(driverId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data();
      }
    } catch (e) {
      print('Error fetching route data: $e');
    }
    return null;
  }

  /// Update the current stop index in Firestore
  Future<void> updateCurrentStopIndex({
    required String driverId,
    required int currentStopIndex,
  }) async {
    try {
      await _firestore.collection('routes').doc(driverId).update({
        'currentStopIndex': currentStopIndex,
      });
    } catch (e) {
      print('Error updating current stop index: $e');
      rethrow;
    }
  }

  /// Delete the route data from Firestore
  Future<void> deleteRouteData(String driverId) async {
    try {
      await _firestore.collection('routes').doc(driverId).delete();
    } catch (e) {
      print('Error deleting route data: $e');
      rethrow;
    }
  }


  /// Get all drivers who have selected a specific route and haven't visited it yet
  Future<List<Map<String, dynamic>>> getDriversForRoute(String route) async {
    try {
      // Get all driver documents in the 'routes' collection
      final querySnapshot = await _firestore.collection('routes').get();
      print('data : $querySnapshot');
      List<Map<String, dynamic>> driversList = [];

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        print(data);

        // Check if the driver has selected the route and hasn't visited it
        List<String> selectedRoutes = List<String>.from(data['selectedRoutes'] ?? []);
        int currentStopIndex = data['currentStopIndex'] ?? 0;


        // If the selectedRoutes list contains the provided route and currentStopIndex is 0
        if (selectedRoutes.contains(route) && selectedRoutes.indexOf(route) >= currentStopIndex) {
          driversList.add(data); // Add the driver's data to the list
        }
      }

      return driversList;
    } catch (e) {
      print('Error fetching drivers for route: $e');
      return [];
    }
  }
}
