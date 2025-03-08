import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future createTask(
      Map<String, dynamic> taskMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('Employee')
        .doc(id)
        .set(taskMap);
  }

}