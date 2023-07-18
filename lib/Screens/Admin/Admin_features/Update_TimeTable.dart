// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';

// class AdminScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Screen'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             _uploadTimetable(context);
//           },
//           child: Text('Upload Timetable'),
//         ),
//       ),
//     );
//   }

//   Future<void> _uploadTimetable(BuildContext context) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpeg'],
//     );

//     if (result != null) {
//       File file = File(result.files.single.path!);
//       String fileName = file.path.split('/').last;

//       try {
//         // Upload the file to Firebase Storage
//         Reference storageRef =
//             FirebaseStorage.instance.ref().child('timetables/$fileName');
//         UploadTask uploadTask = storageRef.putFile(file);
//         TaskSnapshot taskSnapshot = await uploadTask;

//         // Get the download URL of the uploaded file
//         String downloadURL = await taskSnapshot.ref.getDownloadURL();

//         // Update the timetable in Firestore
//         await FirebaseFirestore.instance
//             .collection('timetables')
//             .doc('student_timetable')
//             .set({'downloadURL': downloadURL});

//         // Show success message
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Success'),
//               content: Text('Timetable uploaded successfully.'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       } catch (e) {
//         // Show error message
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Error'),
//               content: Text('Failed to upload timetable. Please try again.$e'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     }
//   }
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FileUploader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Uploader'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _uploadFile(context);
          },
          child: Text('Upload File'),
        ),
      ),
    );
  }

  Future<void> _uploadFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = file.path.split('/').last;

      try {
        // Upload the file to Firebase Storage
        Reference storageRef =
            FirebaseStorage.instance.ref().child('files/$fileName');
        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get the download URL of the uploaded file
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        // Store the download URL in Firestore
        await FirebaseFirestore.instance
            .collection('files')
            .doc('file_doc')
            .set({'downloadURL': downloadURL});

        // Show success message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('File uploaded successfully.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Show error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to upload file. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
