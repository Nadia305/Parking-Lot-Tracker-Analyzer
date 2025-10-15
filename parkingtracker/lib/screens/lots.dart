// Lots widget that will hold list of lots to choose from.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parkingtracker/screens/lotInfo.dart';
import 'package:parkingtracker/requests.dart';

// NEW: shared state + model
import 'package:parkingtracker/app_state.dart';
import 'package:parkingtracker/lot.dart';

class LotsScreen extends StatefulWidget {
  const LotsScreen({super.key});

  @override
  State<LotsScreen> createState() => _LotsScreenState();
}

class _LotsScreenState extends State<LotsScreen> {
  final Requests requests = Requests();            // backend client
  Timer? _timer;                                   // refresh timer

  @override
  void initState() {
    super.initState();
    updateLotData();                               // initial fetch
    _timer = Timer.periodic(
      const Duration(seconds: 30),                 // periodic refresh
      (_) => updateLotData(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // For each lot currently in AppState, get fresh data from backend.
  Future<void> updateLotData() async {
    // copy to avoid concurrent modification if list changes during loop
    final lotsSnapshot = List<Lot>.from(AppState.I.lots);
    for (final lot in lotsSnapshot) {
      try {
        final data = await requests.fetchLotInfo(lot.lotName);
        if (data != null && mounted) {
          setState(() {
            lot.availableSpots = (data['available_spots'] ?? 0) as int;
            lot.totalSpots = (data['total_spots'] ?? 0) as int;
            // if you later return map data etc., update here too
          });
        }
      } catch (_) {
        // ignore one-off failures; you can show a toast if you want
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 210, 248),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 86, 163, 227),
        foregroundColor: Colors.white,
        title: const Text('Available Parking Lots'),
      ),
      body: AnimatedBuilder(
        animation: AppState.I,                      // rebuild when lots change
        builder: (context, _) {
          final lots = AppState.I.lots;
          if (lots.isEmpty) {
            return const Center(child: Text('No lots yet'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: lots.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final lot = lots[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => LotsInfoScreen(lot: lot),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 15.0, right: 25.0),
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(color: Colors.black, width: 4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(lot.lotName),
                      Text('${lot.availableSpots} spots left!'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
