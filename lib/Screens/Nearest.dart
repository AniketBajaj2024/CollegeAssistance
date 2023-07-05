// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maj_project/Screens/Timetablescreen.dart';
import 'package:maj_project/classrooms.dart';
// import 'package:geolocator/geolocator.dart';

// class NearestClassroom extends StatefulWidget {
//   const NearestClassroom({super.key});

//   @override
//   State<NearestClassroom> createState() => _NearestClassroomState();
// }

// class _NearestClassroomState extends State<NearestClassroom> {
//   String nearestclassroom = " ";

//   Future<Position?> _getCurrentPosition()async{
//     try{
//       //request permission to access the device's location
//       LocationPermission permission = await Geolocator.requestPermission();
//       if(permission == LocationPermission.denied){

//       }
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       return position;
//     }
//     catch(error){
//       print("Error getting the location");
//       return null;
//     }
//   }
//   Future<Void> FindNearestClassroom() async {
//     final List<String> availableclass = FindNearestClassroom();
//     final position currentposition = await _getCurrentPosition
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class AvailableClassroomScreen extends StatefulWidget {
  final List<Timetablentry> timetableData;
  const AvailableClassroomScreen({required this.timetableData});

  @override
  State<AvailableClassroomScreen> createState() =>
      _AvailableClassroomScreenState();
}

class _AvailableClassroomScreenState extends State<AvailableClassroomScreen> {
  // List<String> findOccupiedClassrooms() {
  List<String> findAvailableClassrooms() {
    DateTime currentTime = DateTime.now(); // got current time
    // iterate on timetable
    List<Timetablentry> filteredEntries = widget.timetableData.where((entry) {
      DateTime entryTime = DateFormat('HH:mm').parse(entry.time);
      return entryTime.isBefore(currentTime);
    }).toList();

    final List<String> occupiedclassrooms =
        filteredEntries.map((entry) => entry.classroom).toList();
    final List<String> availableclassrooms = allClassrooms
        .where((classroom) => !occupiedclassrooms.contains(classroom))
        .toList();
    return availableclassrooms;
  }

  @override
  Widget build(BuildContext context) {
    List<String> availableclassrooms = findAvailableClassrooms();

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Classrooms'),
      ),
      body: ListView.builder(
        itemCount: availableclassrooms.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(availableclassrooms[index]),
          );
        },
      ),
    );
  }
}
