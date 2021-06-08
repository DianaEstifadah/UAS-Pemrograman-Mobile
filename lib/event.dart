import 'package:uas_pemrograman_mobile/database_helper.dart';
import 'package:uas_pemrograman_mobile/model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// untuk menambah atau mengedit acara
class EventActivity extends StatefulWidget {
  const EventActivity({Key key, this.event}) : super(key: key);
  final EventItem event;
  @override
  EventPage createState() {
    return EventPage();
  }
}

class EventPage extends State<EventActivity> {
  EventItem _event;
  String _selDate = '';
  String _selTime = '';
  String _selName = '';
  String _selAddress = '';
  TextEditingController _controllerDate = new TextEditingController();
  TextEditingController _controllerTime = new TextEditingController();
  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerAddress = new TextEditingController();
  // Inisialisasi
  @override
  void initState() {
    //Mengambil nilai dari widget.event dan mengisinya ke _event
    _event = widget.event;
    if (_event != null) {
      // mengambil data event sebelumnya
      _selName = _event.eventName;
      _selAddress = _event.eventAddress;
      _selDate =
          formatDate(new DateTime.fromMillisecondsSinceEpoch(_event.eventDate));
      _selTime = formatTime(new TimeOfDay.fromDateTime(
          new DateTime.fromMillisecondsSinceEpoch(_event.eventTime)));
      //Menampilkan pada TextField melalui perantara TextEditingController
      _controllerName.text = _selName;
      _controllerAddress.text = _selAddress;
      _controllerDate.text = _selDate;
      _controllerTime.text = _selTime;
    }
    super.initState();
  }

//untuk mengonversi angka di bawah 10 menjadi 2 digit.
  String sprintF(var number) {
    return number.toString().padLeft(2, "0");
  }

//Mengonversi tipe DateTime menjadi format tanggal.
  String formatDate(DateTime date) {
    int year = date.year;
    int month = date.month;
    int day = date.day;
    return day.toString() + "-" + sprintF(month) + "-" + year.toString();
  }

//Mengonversi tipe TimeOfDay menjadi format waktu.
  String formatTime(TimeOfDay time) {
    int hour = time.hour;
    int minute = time.minute;
    return sprintF(hour) + ":" + sprintF(minute);
  }

//untuk menampilkan dialog
  Future selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2030));
    if (picked != null)
      setState(() {
        //Menyimpan nilai pada _selDate
        _selDate = formatDate(picked);
        //Menampilkan pada TextField
        _controllerDate.text = _selDate;
      });
  }

//untuk menampilkan dialog TimePicker
  Future selectTime() async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: new TimeOfDay(
          hour: DateTime.now().hour, minute: DateTime.now().minute),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          //Menggunakan format 24 jam
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        //Menyimpan nilai pada _selTime
        _selTime = formatTime(picked);
        //Menampilkan pada TextField
        _controllerTime.text = _selTime;
      });
  }

//untuk menyimpan event
  void saveEvent() {
    bool isNew = false;
    //Jika _event null (tidak ada kiriman event dari Navigator)
    if (_event == null) {
      _event = new EventItem();
      _event.isCompleted = 0;
      //sebagai event baru
      isNew = true;
    }
    //Mengisi variabel _event
    _event.eventName = _selName;
    _event.eventAddress = _selAddress;
    int year = DateTime.now().year;
    int month = DateTime.now().month;
    int day = DateTime.now().day;
    //Mengisi _event.createDate dengan millisecond saat ini
    _event.createDate = DateTime.now().millisecondsSinceEpoch;
    //Mengonversi data dari TextField
    if (_selDate.isNotEmpty) {
      List<String> arrDate = _selDate.split("-");
      if (arrDate.length == 3) {
        day = int.parse(arrDate[0]);
        month = int.parse(arrDate[1]);
        year = int.parse(arrDate[2]);
      }
    }
    var selDTDate = new DateTime(year, month, day, 0, 0, 0);
    _event.eventDate = selDTDate.millisecondsSinceEpoch;
    int hour = DateTime.now().hour;
    int minute = DateTime.now().minute;
    //Mengonversi data dari TextField
    if (_selTime.isNotEmpty) {
      List<String> arrTime = _selTime.split(":");
      if (arrTime.length >= 2) {
        hour = int.parse(arrTime[0]);
        minute = int.parse(arrTime[1]);
      }
    }
    var selDTTime = new DateTime(year, month, day, hour, minute, 0);
    _event.eventTime = selDTTime.millisecondsSinceEpoch;
    DatabaseProvider databaseProvider = new DatabaseProvider();
    if (isNew) {
      //Membuka database
      databaseProvider.open().then((value) {
        //Menambahkan event ke database
        databaseProvider.insertEvent(_event).then((event) {
          //Menampilkan Toast
          Fluttertoast.showToast(
              msg: "Berhasil ditambahkan",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1);
          //Menutup database
          databaseProvider.close();
          //Menutup activity
          Navigator.pop(context, _event);
        });
      });
      //Jika event bukan merupakan event baru (mode edit)
    } else {
      //Membuka database
      databaseProvider.open().then((value) {
        //Memperbarui event di database
        databaseProvider.updateEvent(_event).then((event) {
          //Menampilkan Toast
          Fluttertoast.showToast(
              msg: "Acara berhasil diperbarui",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1);
          //Menutup database
          databaseProvider.close();
          //Menutup activity dan mengirim _event ke Navigator
          Navigator.pop(context, _event);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Acara"),
      ),
      body: Stack(
        //Positioned.fill digunakan untuk membuat tampilan satu layar penuh
        children: <Widget>[
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.grey[400],
              child: Card(
                elevation: 4.0,
                color: Colors.green[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  side: BorderSide(
                    color: Colors.blueGrey[50],
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blueGrey,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 120,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Tanggal",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: TextField(
                                  controller: _controllerDate,
                                  onTap: selectDate,
                                  textInputAction: TextInputAction.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey[400],
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 120,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Waktu",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: TextField(
                                  controller: _controllerTime,
                                  onTap: selectTime,
                                  textInputAction: TextInputAction.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blueGrey,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 120,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Nama Kegiatan",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: TextField(
                                  keyboardType: TextInputType.text,
                                  controller: _controllerName,
                                  autocorrect: false,
                                  textCapitalization: TextCapitalization.words,
                                  onChanged: (value) {
                                    setState(() {
                                      _selName = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.blueGrey,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 120,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Alamat",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  minLines: 2,
                                  controller: _controllerAddress,
                                  autocorrect: false,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  onChanged: (value) {
                                    setState(() {
                                      _selAddress = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveEvent,
        backgroundColor: Colors.blueGrey,
        tooltip: 'Tambah Acara',
        child: Icon(
          Icons.save,
          color: Colors.black45,
        ),
      ),
    );
  }
}
