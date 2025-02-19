// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_2/services/firestore.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final FirestoreService firestoreService = FirestoreService();

//   final TextEditingController textController = TextEditingController();
//   //open a dialog box
//   void openNotebox(String? docId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: TextField(
//           controller: textController,
//         ),
//         actions: [
//           //to save
//           ElevatedButton(
//             onPressed: () {
//               //add new note
//               if (docId == null) {
//                 firestoreService.addNote(textController.text);
//               } else {
//                 firestoreService.updateNode(docId, textController.text);
//               }

//               //clear textcontroller
//               textController.clear();

//               //close box
//               Navigator.pop(context);
//             },
//             child: const Text("Add"),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Notes")),
//       floatingActionButton: FloatingActionButton(
//         onPressed:  () => openNotebox(null), 
//         child: const Icon(Icons.add),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//           stream: firestoreService.getNotesStream(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               List notesList = snapshot.data!.docs;

//               return ListView.builder(
//                   itemCount: notesList.length,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot document = notesList[index];
//                     String docId = document.id;

//                     Map<String, dynamic> data =
//                         document.data() as Map<String, dynamic>;
//                     String noteText = data['note'];

//                     return ListTile(
//                         title: Text(noteText),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                                 onPressed: () => openNotebox(docId),
//                                 icon: const Icon(Icons.settings)),
//                             IconButton(
//                                 onPressed: () =>
//                                     firestoreService.deleteNote(docId),
//                                 icon: const Icon(Icons.settings)),
//                           ],
//                         ));
//                   });
//             } else {
//               return const Text("No notes...");
//             }
//           }),
//     );
//   }
// }
