class Lot {
  // Required
  String lotName;

  // Will be updated with backend
  int availableSpots;
  int totalSpots;
  List<List<dynamic>>? lotMap;

  // Optional extra info (safe defaults for future use)
  String id;
  bool handicap;
  String permitType;

  Lot({
    required this.lotName,
    this.availableSpots = 0,
    this.totalSpots = 0,
    this.lotMap,
    this.id = '',
    this.handicap = false,
    this.permitType = '',
  });

  // For backend / DB conversions
  factory Lot.fromMap(Map<String, dynamic> m) => Lot(
        lotName: m['lotName'] ?? '',
        availableSpots: m['availableSpots'] ?? 0,
        totalSpots: m['totalSpots'] ?? 0,
        lotMap: (m['lotMap'] as List?)?.map((e) => e as List<dynamic>).toList(),
        id: m['id']?.toString() ?? '',
        handicap: (m['handicap'] ?? 0) == 1,
        permitType: m['permitType'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'lotName': lotName,
        'availableSpots': availableSpots,
        'totalSpots': totalSpots,
        'lotMap': lotMap,
        'id': id,
        'handicap': handicap ? 1 : 0,
        'permitType': permitType,
      };
}
