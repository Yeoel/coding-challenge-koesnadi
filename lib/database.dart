import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future createTask(Map<String, dynamic> taskMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('tasks')
        .add(taskMap);
  }

  Future<Stream<QuerySnapshot>> getTasks(userId) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .snapshots();
  }
}
