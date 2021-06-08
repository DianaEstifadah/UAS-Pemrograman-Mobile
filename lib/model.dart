import 'dart:convert';
//class untuk mengelola objek acara 
class EventItem {
   int eventId;
   int createDate;
   int eventDate;
   int eventTime;
   String eventName;
   String eventAddress;
   int isCompleted;
   EventItem(
       {
         this.eventId,
         this.createDate,
         this.eventDate,
         this.eventTime,
         this.eventName,
         this.eventAddress,
         this.isCompleted
       }
    );
  //mengonversi JSON ke EventItem
   factory EventItem.fromJson(Map<String, dynamic> json) {
     return new EventItem (
       eventId: json['eventId'] as int,
       createDate: json['createDate'] as int,
       eventDate: json['eventDate'] as int,
       eventTime: json['eventTime'] as int,
       eventName: json['eventName'] as String,
       eventAddress: json['eventAddress'] as String,
       isCompleted: json['isCompleted'] as int,
     );
   }
 //mengonversi EventItem ke JSON
   Map<String, dynamic> toJson() => {
     'eventId': eventId,
     'createDate': createDate,
     'eventDate': eventDate,
     'eventTime': eventTime,
     'eventName': eventName,
     'eventAddress': eventAddress,
     'isCompleted': isCompleted,
   };
// digunakan untuk mengirim obyek ke tabel database
   Map<String, dynamic> toMap() {
     return {
       'eventId': eventId,
       'createDate': createDate,
       'eventDate': eventDate,
       'eventTime': eventTime,
       'eventName': eventName,
       'eventAddress': eventAddress,
       'isCompleted': isCompleted,
     };
   }
// digunakan sebagai objek masukan ke tabel di mana eventId bersifat AUTOINCREMENT
   Map<String, dynamic> toMapInsert() {
     return {
       'createDate': createDate,
       'eventDate': eventDate,
       'eventTime': eventTime,
       'eventName': eventName,
       'eventAddress': eventAddress,
       'isCompleted': isCompleted,
     };
   }
 // digunakan untuk menampung baris (row) datadari tabel database
   EventItem.fromMap(Map<String, dynamic> map) {
     eventId = map['eventId'];
     createDate = map['createDate'];
     eventDate = map['eventDate'];
     eventTime = map['eventTime'];
     eventName = map['eventName'];
     eventAddress = map['eventAddress'];
     isCompleted = map['isCompleted'];
   }
   // digunakan untuk menyimpan obyek ke SharedPreferences
   @override
   String toString() {
     var jsonData = json.encode(toJson());
     return jsonData;
   }
}
// class untuk mengelola objek tamu 
class GuestItem {
  int guestId;
  int eventId;
  String guestFullName;
  String guestNoPhone;
  String guestEmail;
  String guestAddress;
  String guestNote;
  int guestVisitTime;
  GuestItem(
      {
        this.guestId,
        this.eventId,
        this.guestFullName,
        this.guestNoPhone,
        this.guestEmail,
        this.guestAddress,
        this.guestNote,
        this.guestVisitTime,
      }
   );
  //mengonversi JSON ke GuestItem
  factory GuestItem.fromJson(Map<String, dynamic> json) {
    return new GuestItem (
      guestId: json['guestId'] as int,
      eventId: json['eventId'] as int,
      guestFullName: json['guestFullName'] as String,
      guestNoPhone: json['guestNoPhone'] as String,
      guestEmail: json['guestEmail'] as String,
      guestAddress: json['guestAddress'] as String,
      guestNote: json['guestNote'] as String,
      guestVisitTime: json['guestVisitTime'] as int,
    );
  }
  //mengonversi GuestItem ke JSON
  Map<String, dynamic> toJson() => {
    'guestId': guestId,
    'eventId': eventId,
    'guestFullName': guestFullName,
    'guestNoPhone': guestNoPhone,
    'email': guestEmail,
    'guestAddress': guestAddress,
    'guestNote': guestNote,
    'guestVisitTime': guestVisitTime,
  };
//digunakan untuk mengirim obyek ke tabel database
  Map<String, dynamic> toMap() {
    return {
      'guestId': guestId,
      'eventId': eventId,
      'guestFullName': guestFullName,
      'guestNoPhone': guestNoPhone,
      'guestEmail': guestEmail,
      'guestAddress': guestAddress,
      'guestNote': guestNote,
      'guestVisitTime': guestVisitTime,
    };
  }
  // digunakan sebagai objek masukan ke tabel di mana guestId bersifat AUTOINCREMENT
  Map<String, dynamic> toMapInsert() {
    return {
      'eventId': eventId,
      'guestFullName': guestFullName,
      'guestNoPhone': guestNoPhone,
      'guestEmail': guestEmail,
      'guestAddress': guestAddress,
      'guestNote': guestNote,
      'guestVisitTime': guestVisitTime,
    };
  }
  // untuk menampung baris (row) data dari tabel database
  GuestItem.fromMap(Map<String, dynamic> map) {
    guestId = map['guestId'];
    eventId = map['eventId'];
    guestFullName = map['guestFullName'];
    guestNoPhone = map['guestNoPhone'];
    guestEmail = map['guestEmail'];
    guestAddress = map['guestAddress'];
    guestNote = map['guestNote'];
    guestVisitTime = map['guestVisitTime'];
  }
  //untuk mengonversi GuestItem ke String.
  //untuk menyimpan obyek ke SharedPreferences
  @override
  String toString() {
    var jsonData = json.encode(toJson());
    return jsonData;
  }
}
//class untuk mengelola objek kolom dari tabel database
class ColumnItem {
  final String name;
  final String type;
  final String extra;
  const ColumnItem(
      {
        this.name,
        this.type,
        this.extra,
      }
  );
}
//Daftar konstanta untuk menentukan kolom-kolom pada tabel event di database.
const List<ColumnItem> eventColumns = const <ColumnItem>[
  const ColumnItem(name: "eventId", type: "INTEGER", extra: "PRIMARY KEY AUTOINCREMENT"),
  const ColumnItem(name: "createDate", type: "INTEGER", extra: ""),
  const ColumnItem(name: "eventDate", type: "INTEGER", extra: ""),
  const ColumnItem(name: "eventTime", type: "INTEGER", extra: ""),
  const ColumnItem(name: "eventName", type: "VARCHAR(50)", extra: ""),
  const ColumnItem(name: "eventAddress", type: "VARCHAR(500)", extra: ""),
  const ColumnItem(name: "isCompleted", type: "INTEGER", extra: ""),
];
//Daftar untuk menentukan kolom-kolom pada tabel guest yang ada di database
const List<ColumnItem> guestColumns = const <ColumnItem>[
  const ColumnItem(name: "guestId", type: "INTEGER", extra: "PRIMARY KEY AUTOINCREMENT"),
  const ColumnItem(name: "eventId", type: "INTEGER", extra: ""),
  const ColumnItem(name: "guestFullName", type: "VARCHAR(50)", extra: ""),
  const ColumnItem(name: "guestNoPhone", type: "VARCHAR(20)", extra: ""),
  const ColumnItem(name: "guestEmail", type: "VARCHAR(50)", extra: ""),
  const ColumnItem(name: "guestAddress", type: "VARCHAR(500)", extra: ""),
  const ColumnItem(name: "guestNote", type: "TEXT", extra: ""),
  const ColumnItem(name: "guestVisitTime", type: "INTEGER", extra: ""),
];
//untuk mengambil nama pada kolom
List<String> getColumnsName(List<ColumnItem> columnItems){
  List<String> result = new List();
  for (ColumnItem columnItem in columnItems){
    result.add(columnItem.name);
  }
  return result;
}