import 'package:flutter/foundation.dart';

class Dechet {
  final int id;
  final String generalTypeName;
  final String name;
  final double pointsPerKg;
  final List<DechetObject> objects;


  Dechet( {
    required this.id,
    required this.generalTypeName,
    required this.name,
    required this.pointsPerKg,
    required this.objects,
  });

  factory Dechet.fromJson(Map<String, dynamic> json) {
    final List<DechetObject> objects = (json['objects'] as List)
        .map((objectJson) => DechetObject.fromJson(objectJson))
        .toList();

    return Dechet(
      id: json['id'],
      generalTypeName: json['generalTypeName'],
      name: json['name'],
      pointsPerKg: json['points_per_kg'],
      objects: objects,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Dechet &&
        id == other.id &&
        name == other.name &&
        pointsPerKg == other.pointsPerKg &&
        listEquals(objects, other.objects);
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    pointsPerKg.hashCode ^
    objects.hashCode;
  }

  @override
  String toString() {
    return 'Dechet: {id: $id,generalTypename: $generalTypeName ,name: $name, pointsPerKg: $pointsPerKg}';
  }
}

class DechetObject {
  final int id;
  final String name;
  final double poids;

  DechetObject({
    required this.id,
    required this.name,
    required this.poids,
  });

  double calculateTotalPoids(int quantity) {
    return poids * quantity.toDouble();
  }

  factory DechetObject.fromJson(Map<String, dynamic> json) {
    return DechetObject(
      id: json['id'],
      name: json['name'],
      poids: json['poids'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DechetObject &&
        id == other.id &&
        name == other.name &&
        poids == other.poids;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    poids.hashCode;
  }

  @override
  String toString() {
    return 'DechetObject: {id: $id, name: $name, poids: $poids}';
  }
}
