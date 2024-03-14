import 'package:bifappp/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final _firestore = FirebaseFirestore.instance.collection("bifaman");
  late final CollectionReference<user> _firebase;

  Service() {
    _firebase = _firestore.withConverter<user>(
      fromFirestore: (snapshot, _) => user.fromMap(snapshot.data()!),
      toFirestore: (user, options) => user.toMap(),
    );
  }

  Stream<QuerySnapshot<user>> getUser() {
    return _firebase.snapshots();
  }

  void addtofirestore(user user) async {
    try {
      await _firebase.add(user);
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  void delete(String userId) {
    _firebase.doc(userId).delete();
  }
}
