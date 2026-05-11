import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/models/task_model.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth auth = FirebaseAuth.instance;

  String get userId => auth.currentUser!.uid;

  CollectionReference get tasks =>
      firestore.collection('users').doc(userId).collection('tasks');

  Future<void> addTask(TaskModel task) async {
    await tasks.add(task.toMap());
  }

  Stream<List<TaskModel>> getTasks() {
    return tasks.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TaskModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> updateTask(TaskModel task) async {
    await tasks.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await tasks.doc(id).delete();
  }
}
