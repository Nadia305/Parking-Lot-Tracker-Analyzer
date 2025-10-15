// Initialize widget that will allow user to add/initialize new lots
import 'package:parkingtracker/app_state.dart';
import 'package:parkingtracker/lot.dart';

import 'package:flutter/material.dart';
import 'package:parkingtracker/requests.dart';

// Stateful = Mutable
class InitializeScreen extends StatefulWidget {
  const InitializeScreen({super.key});

  @override
  State<InitializeScreen> createState() => _InitializeScreenState();
}

class _InitializeScreenState extends State<InitializeScreen> {

  // Create text controllers to retrieve current values of text fields
  final lotNameController = TextEditingController();
  final rtspLinkController = TextEditingController();

  final Requests requests = Requests(); // Create Requests object to call functions to get data

  @override
  void dispose() {
    lotNameController.dispose();
    rtspLinkController.dispose();
    super.dispose();
  }

  // Initialize lot function, called when button pressed - pull data from both text fields, then call initLot with data.
  void initializeLot() async {
  final lotName = lotNameController.text.trim();
  final rtspLink = rtspLinkController.text.trim();

  if (lotName.isEmpty || rtspLink.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter both Lot Name and RTSP Link')),
    );
    return;
  }

  try {
    // Call your backend
    final response = await requests.initLot(lotName, rtspLink);

    if (response != null) {
      final status = (response['status'] ?? '').toString();
      final message = (response['message'] ?? '').toString();

      if (status.toLowerCase() == 'success') {
        // ✅ Update local list so Lots screen shows it immediately
        AppState.I.upsertLot(
          Lot(
            lotName: lotName,
            availableSpots: 0,
            totalSpots: 0,
          ),
        );

        // Feedback + reset inputs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lot "$lotName" added')),
        );
        lotNameController.clear();
        rtspLinkController.clear();
      }

      // Show server response dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
          title: Text(status.isEmpty ? 'Result' : status),
          content: Text(message.isEmpty ? 'Done.' : message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    // Handle network/other errors
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Init failed: $e')),
    );
  }
}



  // Build methods called anytime Flutter rebuilds UI, returns Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 210, 248),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 86, 163, 227),
        foregroundColor: Colors.white,
        title: Text('Initialize New Lot'),
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0), 
        child: Column (
        children: [
          TextField(
            controller: lotNameController,
            decoration: InputDecoration(labelText: 'Enter Lot Name', border: OutlineInputBorder()),
          ),
          SizedBox(height:15), // space out text fields
          TextField(
            controller: rtspLinkController,
            decoration: InputDecoration(labelText: 'Enter RTSP Link', border: OutlineInputBorder()),
          ),
          SizedBox(height:30),
          ElevatedButton(
            onPressed: initializeLot,
            child: Text("Initialize Lot"))
        ],
      )
    )
    );
  }
}
