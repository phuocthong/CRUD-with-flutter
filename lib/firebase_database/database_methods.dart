import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  Future addUserData(Map<String, dynamic> userdata, String id) async {
    return await FirebaseFirestore.instance.collection('User').doc(id).set(userdata);
  }

  Future<Stream<QuerySnapshot>> getUserData() async {
    return FirebaseFirestore.instance.collection('User').snapshots();
  }

  Future updateUserData(String id, Map<String, dynamic> updatedUserData) async {
    return await FirebaseFirestore.instance.collection('User').doc(id).update(updatedUserData);
  }

  Future deleteUserData(String id) async {
    return await FirebaseFirestore.instance.collection('User').doc(id).delete();
  }

}