import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_app/src/models/index.dart';

class AuthApi {
  const AuthApi({required this.auth, required this.firestore});

  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Future<AppUser?> getUser() async {
    final User? user = auth.currentUser;
    if (user == null) {
      return null;
    }
    await _makeSureUserExists(user);

    return _convertUser(user);
  }

  AppUser _convertUser(User user) {
    return AppUser(uid: user.uid, email: user.email!, displayName: user.displayName!);
  }

  Future<AppUser> login({required String email, required String password}) async {
    final UserCredential credentials = await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = credentials.user!;
    return _convertUser(user);
  }

  Future<AppUser> createUser({required String email, required String password}) async {
    final UserCredential credentials = await auth.createUserWithEmailAndPassword(email: email, password: password);
    final User user = credentials.user!;
    final String displayName = email.split('@').first;
    await user.updateDisplayName(displayName);
    await _makeSureUserExists(user);
    return _convertUser(user);
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Stream<List<AppUser>> getUsers() {
    return firestore.collection('users').snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) => AppUser.fromJson(doc.data()))
              .toList(),
        );
  }

  Future<void> _makeSureUserExists(User user) async {
    final DocumentSnapshot<Map<String, dynamic>> doc = await firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return;
    } else {
      final AppUser appUser = _convertUser(user);
      await firestore.collection('users').doc(user.uid).set(appUser.toJson());
    }
  }
}
