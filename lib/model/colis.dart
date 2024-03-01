import 'dechet.dart';

class Colis {
  final int? id;
  final int idDechet;
  final int idReq;
  final double poidsEstimee;
  final double? poidsReel;
  Dechet? dechet; // Make 'dechet' optional by adding a '?'

  Colis({
    required this.id,
    required this.idDechet,
    required this.idReq,
    required this.poidsEstimee,
    this.poidsReel, // Make 'poidsReel' optional by adding a '?'
    this.dechet, // Make 'dechet' optional by adding a '?'
  });

  factory Colis.fromJson(Map<String, dynamic> json) {
    return Colis(
      id: json['id'],
      idDechet: json['id_dechet'],
      idReq: json['id_req'],
      poidsEstimee: json['poids_estimee'],
      poidsReel: json['poids_reel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_dechet': idDechet,
      'id_req': idReq,
      'poids_estimee': poidsEstimee,
      'poids_reel': poidsReel,
    };
  }

  @override
  String toString() {
    return 'Colis: {id: $id, idDechet: $idDechet, idReq: $idReq, poidsEstimee: $poidsEstimee, poidsReel: $poidsReel , dechet: ${dechet?.toString()}}';
  }
}
