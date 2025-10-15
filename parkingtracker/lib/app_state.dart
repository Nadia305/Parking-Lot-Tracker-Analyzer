import 'package:flutter/foundation.dart';
import 'lot.dart'; // import your Lot model

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState I = AppState._(); // singleton pattern

  // Local dictionary of lots
  final Map<String, Lot> _lotsByName = {};

  // Return a sorted list of lots (A–Z)
  List<Lot> get lots {
    final list = _lotsByName.values.toList();
    list.sort((a, b) => a.lotName.toLowerCase().compareTo(b.lotName.toLowerCase()));
    return list;
  }

  // Add a lot or update if it exists
  void upsertLot(Lot lot) {
    _lotsByName[lot.lotName] = lot;
    notifyListeners();
  }

  // Check if a lot name already exists
  bool hasLot(String name) => _lotsByName.containsKey(name);

  // Remove a lot
  void removeLot(String name) {
    _lotsByName.remove(name);
    notifyListeners();
  }

  // Replace all lots (e.g., when loading from backend)
  void setLots(List<Lot> newLots) {
    _lotsByName
      ..clear()
      ..addEntries(newLots.map((l) => MapEntry(l.lotName, l)));
    notifyListeners();
  }
}
