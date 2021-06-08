import 'package:uas_pemrograman_mobile/database_helper.dart';
import 'package:uas_pemrograman_mobile/model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'event.dart';
import 'guests.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Selamat Datang di Buku Tamu',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MainActivity(title: 'Selamat Datang di Buku Tamu'),
    );
  }
}

/* Activity utama, untuk menampilkan daftar event/acara */
class MainActivity extends StatefulWidget {
  MainActivity({Key key, this.title}) : super(key: key);
  final String title;
  @override
  MainPage createState() => MainPage();
}

class MainPage extends State<MainActivity> {
  EventItem _event;
  List<EventItem> _listEvent = new List();
  DatabaseProvider databaseProvider = new DatabaseProvider();
  /* Inisialisasi awal */
  @override
  void initState() {
    super.initState();
    //Memuat data pada ListView
    _refreshList();
  }

  //Metode untuk memuat ulang daftar event
  void _refreshList() {
    //Membuka database
    databaseProvider.open().then((_) {
      // Memanggil fungsi getListEvent untuk mengambil daftar event
      databaseProvider.getListEvent().then((list) {
        if (list != null) {
          //Memperbarui variabel _listEvent
          setState(() {
            _listEvent = list;
          });
          //Menutup database
          databaseProvider.close();
        }
      });
    });
  }

  String sprintF(var number) {
    return number.toString().padLeft(2, "0");
  }

  String formatDate(int millis) {
    if (millis != null) {
      var date = new DateTime.fromMillisecondsSinceEpoch(millis);
      int year = date.year;
      int month = date.month;
      int day = date.day;
      List<String> monthNames = [
        "",
        "Januari",
        "Februari",
        "Maret",
        "April",
        "Mei",
        "Juni",
        "Juli",
        "Agustus",
        "September",
        "Oktober",
        "November",
        "Desember"
      ];
      return day.toString() + " " + monthNames[month] + " " + year.toString();
    }
    return '';
  }

  String formatTime(int millis) {
    if (millis != null) {
      var date = new DateTime.fromMillisecondsSinceEpoch(millis);
      int hour = date.hour;
      int minute = date.minute;
      return sprintF(hour) + ":" + sprintF(minute);
    }
    return '';
  }

  //untuk membuat widget item dari ListView
  Widget createEventItem(EventItem event) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
        side: BorderSide(
          color: Colors.blueGrey,
          width: 1.0,
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.green[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(6.0),
          ),
          side: BorderSide(
            color: Colors.green[100],
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        child: InkWell(
          //Saat baris widget ditap
          onTap: () {
            //Simpan nilai event pada variabel _event
            setState(() {
              _event = event;
            });
            //Memanggil GuestsActivity
            showGuestsActivity();
          },
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.event_note,
                  color: Colors.grey.shade600,
                  size: 56.0,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        event.eventName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        formatDate(event.eventDate) +
                            " " +
                            formatTime(event.eventTime),
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black45,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        event.eventAddress,
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.black45,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        //Saat tombol edit (pensil)di klik
                        onTap: () {
                          //Simpan nilai event pada variabel _event
                          setState(() {
                            _event = event;
                          });
                          //Memanggil EventActivity untuk pengeditan event
                          showEventActivity();
                        },
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        //Saat tombol hapus di klik
                        onTap: () {
                          if (_listEvent.length > 0) {
                            //Simpan nilai event pada variabel _event
                            setState(() {
                              _event = event;
                            });
                            // Menampilkan dialog konfirmasi penghaspusan
                            showDeleteDialog();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//untuk membangun daftar item dari ListView
  Widget listViewBuilder(BuildContext context, int index) {
    EventItem event = _listEvent[index];
    return createEventItem(event);
  }

// Metode untuk menampilkan EventActivity */
  void showEventActivity() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventActivity(
          event: _event,
        ),
      ),
    ).then((value) {
      //memuat ulang ListView saat MainActivity
      if (value != null)
        setState(() {
          _refreshList();
        });
    });
  }

  //Metode untuk menampilkan GuestsActivity
  void showGuestsActivity() {
    Navigator.push(
      context,
      MaterialPageRoute(
        //Memangil GuestsActivity sambil mengirim obyek _event
        builder: (context) => GuestsActivity(
          event: _event,
        ),
      ),
    );
  }

//untuk menampilkan dialog konfirmasi penghapusan event
  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hapus"),
          content: Text("Ingin menghapus acara?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ya"),
              //mengklik tombol Ya pada dialog
              onPressed: () {
                // Membuka database
                databaseProvider.open().then((value) {
                  //Menghapus event dari database
                  databaseProvider.deleteEvent(_event.eventId).then((event) {
                    //Menampilkan Toast setelah penghapusan
                    Fluttertoast.showToast(
                        msg: "Acara berhasil dihapus",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1);
                    // Menghapus item event dari _listEvent. Menggunakan setState agar item-item pada
                    //_listEvent diperbarui sehingga daftar item  pada ListView ikut diperbarui
                    setState(() {
                      _listEvent.remove(event);
                    });
                    //Menutup database
                    databaseProvider.close();
                    // Menutup dialog
                    Navigator.of(context).pop();
                  });
                });
              },
            ),
            FlatButton(
              child: Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _loading = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text("Menyiapkan Data")
        ],
      ),
    );
    Widget _blank = Center(
      child: Container(
        height: 40,
        child: Text("Belum ada acara tersedia"),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh',
              //Memuat data pada ListView saat tombol Refresh diklik
              onPressed: _refreshList),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: Colors.grey[400],
        ),
        child: Card(
          elevation: 4.0,
          color: Colors.green[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            side: BorderSide(
              color: Colors.green[100],
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: Text(
                  "Silakan memilih acara yang tersedia  klik tombol plus di bawah untuk membuat acara baru",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 9.0,
                    horizontal: 16.0,
                  ),
                  //Menggunakan FutureBuilder untuk mengakses database
                  child: FutureBuilder(
                    future: databaseProvider.open(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      //Saat koneksi ke database berhasil terhubung
                      if (snapshot.connectionState == ConnectionState.done) {
                        return FutureBuilder(
                          //FutureBuilder untuk mengambil daftar event
                          future: databaseProvider.getListEvent(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            // pemanggilan fungsi mendapatkan data
                            if (snapshot.hasData) {
                              if (snapshot.data != null) {
                                //Mengisi variabel _listEvent dari data snapshot
                                _listEvent = snapshot.data;
                                databaseProvider.close();
                                // _listEvent kosong
                                if (_listEvent.length == 0) {
                                  //Tampilkan widget _blank
                                  return _blank;
                                  //_listEvent tidak kosong
                                } else {
                                  //widget ListView
                                  return ListView.builder(
                                    itemCount: _listEvent.length,
                                    itemBuilder: listViewBuilder,
                                  );
                                }
                              } else {
                                return _blank;
                              }
                            } else {
                              return _blank;
                            }
                          },
                        );
                      } else {
                        return _loading;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //Saat FloatingActionButton ditap
        onPressed: () {
          //nilai _event
          setState(() {
            _event = null;
          });
          //Memanggil EventActivity
          showEventActivity();
        },
        backgroundColor: Colors.blueGrey[100],
        tooltip: 'Tambah Acara',
        child: Icon(
          Icons.add_box,
          color: Colors.black45,
        ),
      ),
    );
  }
}
