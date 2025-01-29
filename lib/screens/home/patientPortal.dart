import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../config.dart';

class PatientPortalScreen extends StatefulWidget {
  final String patientId; // Pass the patient's ID

  const PatientPortalScreen({super.key, required this.patientId});

  @override
  _PatientPortalScreenState createState() => _PatientPortalScreenState();
}

class _PatientPortalScreenState extends State<PatientPortalScreen> {
  List<dynamic> recentWork = []; // Stores recent work data
  bool isLoading = true; // Loading indicator

  @override
  void initState() {
    super.initState();
    fetchRecentWork(); // Fetch recent work when the screen loads
  }

  // Modify this to fetch work specific to the given patient ID
  Future<void> fetchRecentWork() async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URLS/audit/recent/${widget.patientId}'), // Use patient ID in the URL
      );

      print('Response Status: ${response.statusCode}'); // Log the status code
      print('Response Body: ${response.body}'); // Log the raw response

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded Data: $data'); // Log the decoded data

        setState(() {
          recentWork = data;
          isLoading = false;
        });
      } else {
        print('Failed to fetch recent work: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching recent work: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides the back button

        title: Row(
          children: [
            Text('Patient Portal',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            if (isLoading)
              CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildPortalCard(
                      icon: Icons.schedule,
                      title: 'View Medical Records',
                      onTap: () => Navigator.pushNamed(
                          context, '/view/appointments')),
                  _buildPortalCard(
                      icon: Icons.calendar_today,
                      title: 'Appointments',
                      onTap: () =>
                          Navigator.pushNamed(context, '/view/appointments')),
                  _buildPortalCard(
                      icon: Icons.local_hospital,
                      title: 'Find Doctors',
                      onTap: () =>
                          Navigator.pushNamed(context, '/find/doctors')),
                  _buildPortalCard(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () =>
                          Navigator.pushNamed(context, '/patient/settings')),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: isLoading
                  ? Center(child: CircularProgressIndicator()) // Loading spinner
                  : recentWork.isEmpty
                      ? Center(child: Text('No recent work found'))
                      : ListView.builder(
                          itemCount: recentWork.length,
                          itemBuilder: (context, index) {
                            final item = recentWork[index];
                            print('Rendering item: $item'); // Debugging line to see what is being rendered
                            return ListTile(
                              leading: Icon(Icons.history),
                              title: Text(item['description'] ?? 'No description'), // Null safety for missing data
                              subtitle: Text(
                                'Action: ${item['action'] ?? 'N/A'} | Timestamp: ${item['timestamp'] ?? 'N/A'}',
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortalCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            SizedBox(height: 16),
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
