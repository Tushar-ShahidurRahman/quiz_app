// import 'package:cloud_firestore/cloud_firestore.dart';
//
// Future<String?> _getUserRoleFromDatabase(String userId) async {
//   try {
//     // Get the user document from Firestore using the user ID
//     DocumentSnapshot snapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(userId)
//         .get();
//
//     if (snapshot.exists) {
//       // Retrieve the user's role from the document data
//       Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//       String role = data['role'];
//       return role;
//     } else {
//       // User document does not exist
//       return null;
//     }
//   } catch (error) {
//     print('Error getting user role: $error');
//     return null;
//   }
// }
