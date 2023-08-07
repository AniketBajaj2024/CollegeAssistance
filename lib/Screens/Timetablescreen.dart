// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:csv/csv.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:maj_project/Screens/Nearest.dart';
// import 'package:maj_project/Screens/chatbot/chat_screen.dart';

// class TimeTableScree extends StatefulWidget {
//   const TimeTableScree({super.key});

//   @override
//   State<TimeTableScree> createState() => _TimeTableScreeState();
// }

// class Timetablentry {
//   final String day;
//   final String time;
//   final String subject;
//   final String classroom;
//   Timetablentry(
//       {required this.day,
//       required this.classroom,
//       required this.subject,
//       required this.time});
// }

// class _TimeTableScreeState extends State<TimeTableScree> {
//   List<Timetablentry> timetabledata = [];
//   String nearestclassroom = "";
//   Timetablentry? entry;
//   void initState() {
//     super.initState();
//     loadtimetabledataa();
//   }

//   Future<void> loadtimetabledataa() async {
//     final String csvData = await rootBundle.loadString('assets/Book1.csv');
//     final List<List<dynamic>> csvtable = CsvToListConverter().convert(csvData);
//     setState(() {
//       for (var i = 1; i < csvtable.length; i++) {
//         entry = Timetablentry(
//             day: csvtable[i][0],
//             classroom: csvtable[i][3],
//             time: csvtable[i][2],
//             subject: csvtable[i][1]);
//         timetabledata.add(entry!);
//       }
//     });
//   }

//   Stream<QuerySnapshot<Map<String, dynamic>>> getTimetableStream() {
//     return FirebaseFirestore.instance.collection('files').snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('College Timetable'),
//       ),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: getTimetableStream(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }

//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           final timetableDocs = snapshot.data!.docs;

//           // Convert timetableDocs to a List of Timetablentry
//           timetabledata = timetableDocs.map((doc) {
//             final data = doc.data();
//             return Timetablentry(
//               day: data['DAY'],
//               classroom: data['CLASS-ROOM'],
//               time: data['TIME'],
//               subject: data['SUBJECT'],
//             );
//           }).toList();

//           return Column(
//             children: [
//               DataTable(
//                 columns: const <DataColumn>[
//                   DataColumn(label: Text('Day')),
//                   DataColumn(label: Text('Time')),
//                   DataColumn(label: Text('Subject')),
//                   DataColumn(label: Text('Classroom'))
//                 ],
//                 rows: timetabledata.map((entry) {
//                   return DataRow(cells: <DataCell>[
//                     DataCell(Text(entry.day)),
//                     DataCell(Text(entry.classroom)),
//                     DataCell(Text(entry.subject)),
//                     DataCell(Text(entry.time))
//                   ]);
//                 }).toList(),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AvailableClassroomScreen(
//                         timetableData: timetabledata,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text("Available class"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             ChatScreen() // Navigate to the ChatScreen
//                         ),
//                   );
//                 },
//                 child: Text("Chat with Chatbot"),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maj_project/Screens/Nearest.dart';
import 'package:maj_project/Screens/chatbot/chat_screen.dart';

class TimeTableScree extends StatefulWidget {
  const TimeTableScree({super.key});

  @override
  State<TimeTableScree> createState() => _TimeTableScreeState();
}

class Timetablentry {
  final String day;
  final String time;
  final String subject;
  final String classroom;
  Timetablentry(
      {required this.day,
      required this.classroom,
      required this.subject,
      required this.time});
}

class _TimeTableScreeState extends State<TimeTableScree> {
  List<Timetablentry> timetabledata = [];
  String nearestclassroom = "";
  Timetablentry? entry;
  void initState() {
    super.initState();
    loadtimetabledataa();
  }

  Future<void> loadtimetabledataa() async {
    final String csvData = await rootBundle.loadString('assets/Book1.csv');
    final List<List<dynamic>> csvtable = CsvToListConverter().convert(csvData);
    setState(() {
      for (var i = 1; i < csvtable.length; i++) {
        final day = csvtable[i].elementAt(0);
        final subject = csvtable[i].elementAt(1);
        final time = csvtable[i].elementAt(2);
        final classroom = csvtable[i].elementAt(3);

        if (day != null &&
            subject != null &&
            time != null &&
            classroom != null) {
          entry = Timetablentry(
            day: day.toString(),
            classroom: classroom.toString(),
            time: time.toString(),
            subject: subject.toString(),
          );
        }
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTimetableStream() {
    return FirebaseFirestore.instance.collection('files').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('College Timetable'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: getTimetableStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final timetableDocs = snapshot.data!.docs;

          // Convert timetableDocs to a List of Timetablentry
          timetabledata = timetableDocs.map((doc) {
            final data = doc.data();
            final day = data['DAY'];
            final subject = data['SUBJECT'];
            final time = data['TIME'];
            final classroom = data['CLASS-ROOM'];
            if (day != null &&
                subject != null &&
                time != null &&
                classroom != null) {
              return Timetablentry(
                day: day.toString(),
                classroom: classroom.toString(),
                time: time.toString(),
                subject: subject.toString(),
              );
            } else {
              // Handle null data case here (if needed)
              // For now, returning an empty object
              return Timetablentry(
                  day: '', classroom: '', time: '', subject: '');
            }
          }).toList();

          return Column(
            children: [
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('Day')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Subject')),
                  DataColumn(label: Text('Classroom'))
                ],
                rows: timetabledata.map((entry) {
                  return DataRow(cells: <DataCell>[
                    DataCell(Text(entry.day)),
                    DataCell(Text(entry.classroom)),
                    DataCell(Text(entry.subject)),
                    DataCell(Text(entry.time))
                  ]);
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AvailableClassroomScreen(
                        timetableData: timetabledata,
                      ),
                    ),
                  );
                },
                child: Text("Available class"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen() // Navigate to the ChatScreen
                        ),
                  );
                },
                child: Text("Chat with Chatbot"),
              ),
            ],
          );
        },
      ),
    );
  }
}
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

