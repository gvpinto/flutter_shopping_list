import 'package:cloud_firestore/cloud_firestore.dart';

extension FirebaseFirestoneX on FirebaseFirestore {
  CollectionReference userListRef(String userId) =>
      collection('lists').doc(userId).collection('userList');
}
