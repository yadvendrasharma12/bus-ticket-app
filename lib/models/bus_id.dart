class Bus {
  final String id;
  final String busName;
  final String busNumber;
  final int seatCapacity;
  final String seatArchitecture;
  final String acType;
  final String? frontImage;
  final num? fare;
  final SeatLayout? seatLayout; // ✅ add this

  Bus({
    required this.id,
    required this.busName,
    required this.busNumber,
    required this.seatCapacity,
    required this.seatArchitecture,
    required this.acType,
    this.frontImage,
    this.fare,
    this.seatLayout,
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    return Bus(
      id: json['_id']?.toString() ?? '',
      busName: json['busName']?.toString() ?? '',
      busNumber: json['busNumber']?.toString() ?? '',
      seatCapacity: json['seatCapacity'] ?? 0,
      seatArchitecture: json['seatArchitecture']?.toString() ?? '',
      acType: json['acType']?.toString() ?? '',
      frontImage: json['frontImage']?.toString(),
      fare: json['fare'],
      seatLayout: json['seatLayout'] != null
          ? SeatLayout.fromJson(Map<String, dynamic>.from(json['seatLayout']))
          : null,
    );
  }
}

class SeatLayout {
  final int rows;
  final int columns;
  final List<List<Seat>> map;

  SeatLayout({
    required this.rows,
    required this.columns,
    required this.map,
  });

  factory SeatLayout.fromJson(Map<String, dynamic> json) {
    final mapJson = json['map'] as List<dynamic>? ?? [];
    final seatMap = mapJson.map<List<Seat>>((row) {
      return (row as List<dynamic>)
          .map((seat) => Seat.fromJson(Map<String, dynamic>.from(seat)))
          .toList();
    }).toList();

    return SeatLayout(
      rows: json['rows'] ?? 0,
      columns: json['columns'] ?? 0,
      map: seatMap,
    );
  }
}

class Seat {
  final bool enabled;
  final String seatLabel;

  Seat({
    required this.enabled,
    required this.seatLabel,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      enabled: json['enabled'] ?? false,
      seatLabel: json['seatLabel']?.toString() ?? '',
    );
  }
}
