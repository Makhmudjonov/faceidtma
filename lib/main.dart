import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.2.67:8080/reports'),
  );

  String _dateTimeString = '';
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // Timerni ishga tushirish
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateDateTime();
    });
  }

  // Sana va soatni yangilash
  void _updateDateTime() {
    setState(() {
      DateTime now = DateTime.now();

      String year = now.year.toString().padLeft(4, '0');
      String month = now.month.toString().padLeft(2, '0');
      String day = now.day.toString().padLeft(2, '0');

      String hour = now.hour.toString().padLeft(2, '0');
      String minute = now.minute.toString().padLeft(2, '0');
      String second = now.second.toString().padLeft(2, '0');

      _dateTimeString = "$year-$month-$day $hour:$minute:$second";
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Timerni to'xtatish
    channel.sink.close();
    super.dispose();
  }

  var user_data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Text(
            _dateTimeString,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 20),
        ],
        title: Text("STUDENT REPORT", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF253B80),
      ),
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          user_data = snapshot;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Ulanishda xatolik ${snapshot.hasError} hash code: ${snapshot.hashCode}",
              ),
            );
          }
          if (!snapshot.hasData) {
            user_data = snapshot.data;
            print("fdsafdfsdf: $user_data");
            return Text("data");
          }

          // JSON formatidagi ma'lumotni dekod qilish
          final message = jsonDecode(snapshot.data);
          return Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF253B80),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chap tomonda rasm
                  Expanded(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image(
                        image: NetworkImage(
                          message[0]["success"] == true
                              ? "http://192.168.2.67:8080/${message[0]['data']["student"]["picture"]}"
                              : "https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg",
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 30),

                  // O'ng tomonda ma'lumotlar
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Divider(),
                          InfoRow(
                            title: "Hemis ID",
                            value:
                                message[0]['success'] == true
                                    ? message[0]['data']['student']['hemis_id']
                                        .toString()
                                    : "",
                          ),
                          Divider(),
                          InfoRow(
                            title: "F.I.SH",
                            value:
                                message[0]['success'] == true
                                    ? message[0]['data']['student']['full_name']
                                    : "",
                          ),
                          Divider(),
                          InfoRow(
                            title: "Fakultet",
                            value:
                                message[0]['success'] == true
                                    ? message[0]['data']['student']['faculty']
                                    : "",
                          ),
                          Divider(),
                          InfoRow(
                            title: "Mutaxassislik",
                            value:
                                message[0]['success'] == true
                                    ? message[0]['data']['student']['specialty']
                                    : "",
                          ),
                          Divider(),
                          InfoRow(
                            title: "Kurs",
                            value:
                                message[0]['success'] == true
                                    ? message[0]['data']['student']['course']
                                        .toString()
                                    : "",
                          ),
                          Divider(),
                          InfoRow(
                            title: "Guruh",
                            value:
                                message[0]['success'] == true
                                    ? message[0]['data']['student']['group']
                                        .toString()
                                    : "",
                          ),
                          Divider(),
                          InfoRow(
                            title: "O'quv yili",
                            value:
                                message[0]['success'] == true
                                    ? message[0]['data']['student']['education_year']
                                    : "",
                          ),
                          // Divider(),
                          // InfoRow(
                          //   title: "O'quv turi",
                          //   value:
                          //       message[0]['success'] == true
                          //           ? message[0]['data']['student']['education_type']
                          //           : "",
                          // ),
                          Divider(),
                          InfoRow(
                            title: "User ID",
                            value:
                                message[0]['success'] == true
                                    ? message[0]['data']['student']['id']
                                        .toString()
                                    : "",
                          ),
                          // Divider(),
                          // InfoRow(
                          //   title: "Fan",
                          //   value:
                          //       message[0]['success'] == true
                          //           ? message[0]['data']['student']['subjects']
                          //           : "",
                          // ),
                          Divider(),
                          InfoRow(
                            title: "O'xshashlik",
                            value:
                                message[0]['success'] == true
                                    ? message[0]['data']['score'].toString()
                                    : "",
                          ),
                          Divider(),
                          InfoRow(
                            title: "Vaqt",
                            value:
                                message[0]['success'] == true
                                    ? message[0]['data']['date_time'].toString()
                                    : "",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
