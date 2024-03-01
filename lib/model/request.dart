class Request {
  final int? id;
  final int? clientId;
  final int? livreurId;
  final DateTime? date;
  final double? point;
  final bool? status;
  final String? location ;

  Request({
    this.id,
    this.clientId,
    this.livreurId,
    this.date,
    this.point,
    this.status,
    this.location ,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'livreurId': livreurId,
      'date': date?.toIso8601String(),
      'point': point,
      'status': status,
      'location' : location
    };
  }

  @override
  String toString() {
    if (id == null &&
        clientId == null &&
        livreurId == null &&
        date == null &&
        point == null &&
        status == null) {
      return 'No request in this object';
    }
    return 'Request: {id: $id, clientId: $clientId, livreurId: $livreurId, date: $date, point: $point, status: $status}';
  }
}
