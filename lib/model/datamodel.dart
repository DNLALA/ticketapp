import 'dart:typed_data';

class Artist {
  final int? id;
  final String name;
  final Uint8List imageFile;

  const Artist({
    this.id,
    required this.name,
    required this.imageFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageBytes': imageFile,
    };
  }

  factory Artist.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON cannot be null');
    }
    return Artist(
      id: json['id'],
      name: json['name'] ?? '',
      imageFile: json['imageBytes'],
    );
  }
}

class Show {
  final int? id;
  final int? artistId;
  final String month;
  final int day;
  final String time;
  final String name;
  final String location;
  final String fee;
  final String? orderId;
  final String? mapUrl;
  final String? ticketType;
  final String weekday;

  Show({
    this.id,
    required this.artistId,
    required this.month,
    required this.day,
    required this.time,
    required this.name,
    required this.location,
    required this.fee,
    required this.weekday,
    this.orderId,
    this.mapUrl,
    this.ticketType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artistId': artistId,
      'month': month,
      'day': day,
      'time': time,
      'name': name,
      'location': location,
      'fee': fee,
      'orderId': orderId,
      'mapUrl': mapUrl,
      'ticketType': ticketType,
      'weekday': weekday,
    };
  }

  factory Show.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON cannot be null');
    }
    return Show(
        id: json['id'],
        artistId: json['artistId'],
        month: json['month'] ?? '',
        day: json['day'] ?? 1,
        time: json['time'] ?? '',
        name: json['name'] ?? '',
        location: json['location'] ?? '',
        fee: json['fee'] ?? 0.0,
        orderId: json['orderId'],
        mapUrl: json['mapUrl'],
        ticketType: json['ticketType'],
        weekday: json['weekday']);
  }
}

class Ticket {
  final int? id;
  final int? showId;
  final String stage;
  final String view;
  final String selection;
  final String row;
  final String seat;
  final String name;

  Ticket({
    this.id,
    required this.showId,
    required this.stage,
    required this.view,
    required this.selection,
    required this.row,
    required this.seat,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'showId': showId,
      'stage': stage,
      'view': view,
      'selection': selection,
      'row': row,
      'seat': seat,
      'name': name,
    };
  }

  factory Ticket.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON cannot be null');
    }
    return Ticket(
      id: json['id'],
      showId: json['showId'],
      stage: json['stage'] ?? '',
      view: json['view'] ?? '',
      selection: json['selection'] ?? '',
      row: json['row'] ?? '',
      seat: json['seat'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class TransferInfo {
  final int id;
  final String firstName;
  final String lastName;
  final String emailPhone;
  final String note;
  final List<int> ticketIds;

  TransferInfo({
    this.id = 0,
    required this.firstName,
    required this.lastName,
    required this.emailPhone,
    required this.note,
    required this.ticketIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'emailPhone': emailPhone,
      'note': note,
    };
  }

  factory TransferInfo.fromJson(Map<String, dynamic> json) {
    return TransferInfo(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      emailPhone: json['emailPhone'],
      note: json['note'],
      ticketIds:
          (json['ticketIds'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }
}
