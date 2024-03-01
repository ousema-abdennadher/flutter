class Localisation {
  late final int? id;
  late final int? idCitoyen;
  late final String? adresse;
/*  final String? codePostal;
  final String? region;
  final String? ville;
  final String? titre;*/
  late final String? latitude;
  late final String? longitude;
  late final DateTime? createdAt;

  Localisation({
    this.id,
    this.idCitoyen,
    this.adresse,
    /*this.codePostal,
    this.region,
    this.ville,
    this.titre,*/
    this.latitude,
    this.longitude,
    this.createdAt,
  });

  factory Localisation.fromJson(Map<String, dynamic> json) {
    return Localisation(
      id: json['id'],
      idCitoyen: json['id_citoyen'],
      adresse: json['adresse'],
      /*codePostal: json['code_postal'],
      region: json['region'],
      ville: json['ville'],
      titre: json['titre'],*/
      latitude: json['latitude'],
      longitude: json['longitude'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_citoyen': idCitoyen,
      'adresse': adresse,
      /*'code_postal': codePostal,
      'region': region,
      'ville': ville,
      'titre': titre,*/
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt?.toIso8601String(),
    };
  }
  String lanLong(){
    return "$latitude  $longitude" ;
  }

  @override
  String toString() {
    return 'Localisation: {id: $id, idCitoyen: $idCitoyen, adresse: $adresse, latitude: $latitude, longitude: $longitude, createdAt: $createdAt}';
  }
}
