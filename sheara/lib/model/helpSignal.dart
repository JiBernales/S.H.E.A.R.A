import 'dart:ffi';
import 'package:latlong2/latlong.dart';
final String signalsTable = 'signals';

class signalsFields {
  static final List<String> values = [
    id, victimName, urgencyLevel, lastSeenLatitude, lastSeenLongitude
  ];
  static final String id = '_id';
  static final String victimName = 'victimName';
  static final String urgencyLevel = 'urgencyLevel';
  static final String lastSeenLatitude = 'lastSeenLatitude';
  static final String lastSeenLongitude = 'lastSeenLongitude';
  static final String lastSeenTime = 'lastSeenTime';
}

class helpSignal {
  final int? id;
  String victimName;
  String urgencyLevel;
  double? lastSeenLatitude;
  double? lastSeenLongitude;
  DateTime lastSeenTime;

  void updateLocation(String newLocation) {

  }

  void updateLastSeenTime() {
    lastSeenTime = DateTime.now();
  }

  helpSignal({
    this.id,
    required this.victimName,
    required this.urgencyLevel,
    required this.lastSeenLatitude,
    required this.lastSeenLongitude,
    required this.lastSeenTime,
  });

  helpSignal copy({
    int? id,
    String? victimName,
    String? urgencyLevel,
    double? lastSeenLatitude,
    double? lastSeenLongitude,
    DateTime? lastSeenTime,
  }) =>
      helpSignal(
        id: id ?? this.id,
        victimName: victimName ?? this.victimName,
        urgencyLevel: urgencyLevel ?? this.urgencyLevel,
        lastSeenLatitude: lastSeenLatitude ?? this.lastSeenLatitude,
        lastSeenLongitude: lastSeenLongitude ?? this.lastSeenLongitude,
        lastSeenTime: lastSeenTime ?? this.lastSeenTime,
      );


  static helpSignal fromJson(Map<String, Object?> json) => helpSignal(
    id: json[signalsFields.id] as int?,
    victimName: json[signalsFields.victimName] as String,
    urgencyLevel: json[signalsFields.urgencyLevel] as String,
    lastSeenLatitude: json[signalsFields.lastSeenLatitude] as double?,
    lastSeenLongitude: json[signalsFields.lastSeenLongitude] as double?,
    lastSeenTime: DateTime.parse(json[signalsFields.lastSeenTime] as String),
  );

  Map<String, Object?> toJson() => {
    signalsFields.id: id,
    signalsFields.victimName: victimName,
    signalsFields.urgencyLevel: urgencyLevel,
    signalsFields.lastSeenLatitude: lastSeenLatitude,
    signalsFields.lastSeenLongitude: lastSeenLongitude,
    signalsFields.lastSeenTime: lastSeenTime.toIso8601String(),
  };
}